function ok = buildModel(h_fig)
% buildModel simulates a set of discretised FRET time course from the
% kinetic rates and the FRET states defined by the user.
%
% Requires external files: setContPan.m

% Last update by MH, 19.12.2019
% >> fix error occuring when the sum of one of the rows/columns in the rate
%  matrix is null
% >> return execution success/failure in "ok"
%
% update by MH, 17.12.2019
% >> remove dependency on updateMov.m (called from the pushbutton callback 
% function)
%
% update by RB, 6.3.2018
% >> comment: To be checked 2018-03-06 

% initialize execution failure/success
ok = 0;

% display action
setContPan(cat(2,'Generate random state sequences...'),'process',h_fig);

% collect parameters
h = guidata(h_fig);
n_max = h.param.sim.molNb;
bleach = h.param.sim.bleach;
expT = 1/h.param.sim.rate;
bleachT = h.param.sim.bleach_t;
K = h.param.sim.nbStates;
impPrm = h.param.sim.impPrm;
molPrm = h.param.sim.molPrm;
imp_kx = impPrm & isfield(molPrm, 'kx');

if imp_kx
    kx_all = molPrm.kx;
    wx_all = molPrm.wx;
else
    kx = h.param.sim.kx;
    wx = h.param.sim.wx;
    kx_all  = repmat(kx,[1,1,n_max]);
    wx_all = repmat(wx,[1,1,n_max]);
end
ref = ~~(kx_all);
isTrans = prod(double(sum(sum(ref(1:K,1:K,1:n_max),1),2)),3);

N = h.param.sim.nbFrames;
mix = cell(1,n_max);
discr_seq = cell(1,n_max);
dt_final = cell(1,n_max);

if K>1 && isTrans
    n = 1;
    while n <= n_max
        if n==1
            kx = kx_all(1:K,1:K,n);
            wx = wx_all(1:K,1:K,n);
            wx = wx./repmat(sum(wx,2),[1,K]);

            % identify zero sums in rate matrix
            if sum(sum(kx,1)>0)~=K || sum(sum(kx,2)>0)~=K
                setContPan(cat(2,'Simulation aborted: at least one ',...
                    'transition from and to each state must be defined ',...
                    '(rate non-null).'),'error',h_fig);

                % clear any results to avoid conflict
                if isfield(h,'results') && isfield(h.results,'sim')
                    h.results = rmfield(h.results,'sim');
                end
                guidata(h_fig,h);
                return
            end

            %             P = kx*N; // M.CAS Hadzic 2012
            %             P = double(~~(kx)); %  M.CAS Hadzic 2014, to be updated
%             P = kx.*expT; % simple rate-to-prob-model for Markov chains, 2018-03-12 RB
            P = kx.*wx; % use probability-weighted rates
            for i=1:K 
                 %P(:,i) = (kx(:,i)./sum(kx,2)(i))*(1-exp(-sum(kx,2)(i)*expT));
%                  P(i,i) = 1 - sum(kx(i,:))*expT; % simple rate-to-prob-model for Markov chains, 2018-03-12 RB
                P(i,i) = 1 - sum(P(i,:));
            end
            % State probabilities from rates, 2018-03-12 RB PlosOne
            [V,D,W]=eig(P);
            D = diag(D);
            for i=1:K
                if round(1e5*real(D(i)))/1e5==1 && round(imag(D(i)))==0 
                    %disp(i) % control, 2018-03-12 RB
                    break   
                end
            end
            Prob = W(:,i)./sum(W(:,i));
        end
        
        if bleach
            end_t = ceil(random('exp',bleachT));
            if end_t > N*expT
                end_t = N*expT;
            end
        else
            end_t = N*expT;
        end

        if n <= n_max
            mix{n} = zeros(K,N);
            discr_seq{n} = zeros(N,1);

            t = 0;
            stes = zeros(K,N);
            
            % pick a "first state" randomly with uniform probabilities
            %s_curr = randsample(1:K, 1, true, double(~~(kx))); % M.CAS Hadzic 2014
            
            % pick a "first state" randomly weighted with state
            % propabilities 
            s_curr = randsample(1:K, 1, true, Prob); % 2018-03-12, RB PlosOne
          
            while t<end_t

                curr_f = ceil(t/expT);
                if curr_f==0
                    curr_f = 1;
                elseif sum(stes(:,curr_f),1)==1
                    curr_f = curr_f+1;
                end
                
                s_prev = s_curr; % previous state

                % pick a "next state" randomly with k-based probabilities
%                 s_curr = randsample(1:K, 1, true, kx(s_prev,:)/sum(kx(s_prev,:)));
                
                % pick a "next state" randomly with defined probabilities
                s_curr = randsample(1:K, 1, true, wx(s_prev,:));
                
                % dwell in s
                dt = random('exp',1/kx(s_prev,s_curr)); 
                
                % truncate dwell if larger than remaining time
                if (t+dt)>end_t
                    dt = end_t - t;
                end
                
                dt_final{n} = [dt_final{n}; [dt s_prev s_curr]];

                if t>0 && sum(stes(:,curr_f),1)<=1
                    
                    % the cumulation of the dt generated overflows or 
                    % reaches the integration time limit
                    if dt/expT>=(1-sum(stes(:,curr_f),1))
                        dt = dt - expT*(1 - sum(stes(:,curr_f),1));
                        t = t + expT*(1 - sum(stes(:,curr_f),1));
                        stes(s_prev,curr_f) = stes(s_prev,curr_f) + ...
                            1 - sum(stes(:,curr_f),1);
                        curr_f = curr_f + 1;
                    
                    % the cumulation of the dt generated does not reach the
                    % integration time limit
                    else
                        stes(s_prev,curr_f) = stes(s_prev,curr_f) + ...
                            dt/expT;
                        t = t + dt;
                        dt = 0;
                        continue;
                    end
                end

                addl = fix(dt/expT);
                if addl>0
                    stes(s_prev,(curr_f):(curr_f+addl-1)) = 1;
                end
                
                fract_end = dt-addl*expT;
                % the cumulation of the dt generated overflows the 
                % integration time limit
                if fract_end>0
                    stes(s_prev,curr_f+addl) = fract_end;
                end
                
                t = t + fract_end*expT + addl*expT;
            end
            
            stes = stes(:,1:N);
            mix{n} = stes./repmat(sum(stes,1),[K,1]);
            [o,max_ste] = max(stes,[],1);
            discr_seq{n} = max_ste';
            
            if end_t/expT < N
                discr_seq{n}(1+end_t/expT:N,:) = -1;
                mix{n}(1,1+end_t/expT:N) = -1;
            end
            n = n+1;
        end
    end
    
else
    for n = 1:n_max
        mix{n} = zeros(K,N);
        if K > 1
            % pick a "first state" randomly
            if n==1 && ~imp_kx
                kx = kx(1:K,1:K);
                P = kx*N;
                % pick a "first state" randomly with uniform probabilities
                s_curr = randsample(1:K, 1, true, sum(P,1));

            elseif imp_kx
                kx = kx_all(1:K,1:K,n);
                P = kx*N;
                % pick a "first state" randomly with uniform probabilities
                s_curr = randsample(1:K, 1, true, sum(P,1));
            end
        else
            s_curr = 1;
        end
        
        if bleach
            end_t = ceil(random('exp',bleachT));
            if end_t > N*expT
                end_t = N*expT;
            end
        else
            end_t = N*expT;
        end
        
        mix{n}(s_curr,:) = 1;
        dt_final{n} = [N*expT s_curr NaN];
        discr_seq{n} = s_curr*ones(N,1);
        if end_t/expT < N
            discr_seq{n}(1+end_t/expT:N,:) = -1;
            mix{n}(1,1+end_t/expT:N) = -1;
        end
    end
end

% clear previous results
if isfield(h,'results') && isfield(h.results,'sim')
    h.results = rmfield(h.results,'sim');
end

h.results.sim.mix = mix;
h.results.sim.discr_seq = discr_seq;
h.results.sim.dt_final = dt_final;
guidata(h_fig,h);

% cancelled by MH, 17.12.2019
% updateMov(h_fig);

% return execution success
ok = 1;
