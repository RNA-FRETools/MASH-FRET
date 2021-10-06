function ok = buildModel(h_fig)
% buildModel simulates a set of discretised FRET time course from the
% kinetic rates and the FRET states defined by the user.
%
% Requires external files: setContPan.m

% Last update, 17.3.2020: (1) use pre-defined transition probabilties (wx) (2) use HMM transition probabiltiies to calculate initial state probabilities ((kx*expT).*wx) (3) add possibility to use pre-defined initial state probabilties (p0)
% update by MH, 19.12.2019: (1) fix error occuring when the sum of one of the rows/columns in the rate matrix is null (2) return execution success/failure in "ok"
% update by MH, 17.12.2019: remove dependency on updateMov.m (called from the pushbutton callback function)
% update by RB, 6.3.2018: review initial state probabilities

% defaults
Lmin = 5; % minimum trace length

% initialize execution failure/success
ok = 0;

% display action
setContPan(cat(2,'Generate random state sequences...'),'process',h_fig);

% collect parameters
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
prm = p.proj{proj}.sim;

N = prm.molNb;
bleach = prm.bleach;
expT = 1/prm.rate;
bleachL = prm.bleach_t/expT;
J = prm.nbStates;
impPrm = prm.impPrm;
molPrm = prm.molPrm;
imp_kx = impPrm & isfield(molPrm, 'kx');
imp_ip = impPrm & isfield(molPrm, 'p0');

if imp_kx % transition rate coefficients from presets
    kx_all = molPrm.kx;
else % transition rate coefficients from interface
    kx = prm.kx;
    kx_all  = repmat(kx,[1,1,N]);
end
kx_all = kx_all(1:J,1:J,:);
tau_all = 1./permute(sum(kx_all,2),[3,1,2]);
if imp_ip % initial state prob. from presets
    ip_all = molPrm.p0;
else % initial prob. calculated from state lifetimes
    ip_all = tau_all./repmat(sum(tau_all,2),[1,J,1]);
end
isTrans = prod(double(sum(sum(~~kx_all(1:J,1:J,1:N),1),2)),3);

L = prm.nbFrames;
mix = cell(1,N);
discr_seq = cell(1,N);
dt_final = cell(1,N);

if J>1 && isTrans
    n = 1;
    while n <= N
        kx = kx_all(:,:,n);
        kx(~~eye(J)) = 0;
        wx = kx./repmat(sum(kx,2),[1,J]);
        wx(isnan(wx)) = 0;
        ip = ip_all(n,:);
        tau = tau_all(n,:)/expT;

%         % MH 19.12.2019: identify zero sums in rate matrix
%         if sum(sum(kx,1)>0)~=J || sum(sum(kx,2)>0)~=J
%             setContPan(cat(2,'Simulation aborted: at least one ',...
%                 'transition from and to each state must be defined ',...
%                 '(rate non-null).'),'error',h_fig);
% 
%             % clear any results to avoid conflict
%             if isfield(h,'results') && isfield(h.results,'sim')
%                 h.results = rmfield(h.results,'sim');
%             end
%             guidata(h_fig,h);
%             return
%         end
        
        if bleach
            Ln = round(ceil(random('exp',bleachL)));
            if Ln>L
                Ln = L;
            end
            if Ln<Lmin
                Ln = Lmin;
            end
        else
            Ln = L;
        end

        if n <= N
            mix{n} = zeros(J,L);
            discr_seq{n} = zeros(L,1);
            stes = zeros(J,L);
            state1 = randsample(1:J, 1, true, ip); % pick a first state
            
            l = 0;
            while l<Ln
                
                curr_l = ceil(l);
                if curr_l==0
                    curr_l = 1;
                elseif curr_l>Ln
                    curr_l = Ln;
                elseif sum(stes(:,curr_l),1)==1
                    curr_l = curr_l+1;
                end
                
                % pick a first state
                if sum(wx(state1,:))==0
                    state2 = state1;
                else
                    state2 = randsample(1:J, 1, true, wx(state1,:)); % pick a next state
                end
                
                % dwell in numer of time bins
                if isinf(tau) % kinetic trap
                    dl = Ln-l;
                else
                    dl = random('exp',tau(state1));
                end
                
                % truncate dwell if larger than remaining time
                if (l+dl)>Ln
                    dl = Ln-l;
                end
                
                dt_final{n} = [dt_final{n}; [dl*expT state1 state2]];

                if l>0 && sum(stes(:,curr_l),1)<=1
                    
                    % the cumulation of the dt generated overflows or 
                    % reaches the integration time limit
                    if dl>=(1-sum(stes(:,curr_l),1))
                        dl = dl - (1 - sum(stes(:,curr_l),1));
                        l = l + (1 - sum(stes(:,curr_l),1));
                        stes(state1,curr_l) = stes(state1,curr_l) + 1 - ...
                            sum(stes(:,curr_l),1);
                        curr_l = curr_l + 1;
                    
                    % the cumulation of the dt generated does not reach the
                    % integration time limit
                    else
                        stes(state1,curr_l) = stes(state1,curr_l) + dl;
                        l = l + dl;
                        continue;
                    end
                end

                addl = fix(dl);
                if dl>0
                    stes(state1,(curr_l):(curr_l+addl-1)) = 1;
                end
                
                fract_end = dl-addl;
                % the cumulation of the dt generated overflows the 
                % integration time limit
                if fract_end>0
                    stes(state1,curr_l+addl) = fract_end;
                end
                
                l = l + fract_end + addl;
                state1 = state2;
            end
            
            stes = stes(:,1:L);
            mix{n} = stes./repmat(sum(stes,1),[J,1]);
            [o,max_ste] = max(stes,[],1);
            discr_seq{n} = max_ste';
            
            if Ln < L
                discr_seq{n}(1+Ln:L,:) = -1;
                mix{n}(1,1+Ln:L) = -1;
            end
            n = n+1;
        end
    end
    
else
    for n = 1:N
        ip = ip_all(n,:);
        mix{n} = zeros(J,L);
        if J > 1
            if sum(sum(kx,1)>0)~=J || sum(sum(kx,2)>0)~=J
                % MH 19.12.2019: identify zero sums in rate matrix
                setContPan(cat(2,'Simulation aborted: when no transition ',...
                    'is defined (null rates), initial state probabilities',...
                    ' must be pre-defined.'),'error',h_fig);

                % clear any results to avoid conflict
                if isfield(h,'results') && isfield(h.results,'sim')
                    h.results = rmfield(h.results,'sim');
                end
                guidata(h_fig,h);
                return
            end
            
            % pick a "first state" randomly
            state1 = randsample(1:J, 1, true, sum(ip,1));
        else
            state1 = 1;
        end
        
        if bleach
            Ln = ceil(random('exp',bleachL));
            if Ln > L*expT
                Ln = L*expT;
            end
        else
            Ln = L*expT;
        end
        
        mix{n}(state1,:) = 1;
        dt_final{n} = [L state1 NaN];
        discr_seq{n} = state1*ones(L,1);
        if Ln < L
            discr_seq{n}(1+Ln:L,:) = -1;
            mix{n}(1,1+Ln:L) = -1;
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

% return execution success
ok = 1;
