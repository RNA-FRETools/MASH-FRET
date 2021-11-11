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

% retrieve project content
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
prm = p.proj{proj}.sim.prm;
curr = p.proj{proj}.sim.curr;
def = p.proj{proj}.sim.def;

% apply current parameter set to project
prm.gen_dt = curr.gen_dt;

% collect simulation parameters
N = prm.gen_dt{1}(1);
L = prm.gen_dt{1}(2);
J = prm.gen_dt{1}(3);
isblch = prm.gen_dt{1}(5);
blch_cst = prm.gen_dt{1}(6);
kx = prm.gen_dt{2}(:,:,1);
wx = prm.gen_dt{2}(:,:,2);
isPresets = prm.gen_dt{3}{1};
presets = prm.gen_dt{3}{2};

% get proper transition rate constants
imp_kx = isPresets & isfield(presets, 'kx');
if imp_kx % transition rate coefficients from presets
    kx_all = presets.kx;
else % transition rate coefficients from interface
    kx_all  = repmat(kx,[1,1,N]);
end
kx_all = kx_all(1:J,1:J,:);

% get proper starting probabilities
imp_ip = isPresets & isfield(presets, 'p0');
tau_all = 1./permute(sum(kx_all,2),[3,1,2]);
if imp_ip % initial state prob. from presets
    ip_all = presets.p0;
else % initial prob. calculated from state lifetimes
    ip_all = tau_all./repmat(sum(tau_all,2),[1,J,1]);
end

% initializes results
mix = -ones(J,L,N);
discr_seq = -ones(L,N);
dt_final = cell(1,N);

% generate dwell times
isTrans = prod(double(sum(sum(~~kx_all(1:J,1:J,1:N),1),2)),3);
if J>1 && isTrans
    n = 1;
    while n <= N
        kx = kx_all(:,:,n);
        kx(~~eye(J)) = 0;
        wx = kx./repmat(sum(kx,2),[1,J]);
        wx(isnan(wx)) = 0;
        ip = ip_all(n,:);
        tau = tau_all(n,:);

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
        
        if isblch
            Ln = round(ceil(random('exp',blch_cst)));
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
                
                dt_final{n} = [dt_final{n}; [dl state1 state2]];

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
                        state1 = state2;
                        continue
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
            mix(:,:,n) = stes./repmat(sum(stes,1),[J,1]);
            [o,max_ste] = max(stes,[],1);
            discr_seq(:,n) = max_ste';
            
            if Ln < L
                discr_seq(1+Ln:L,n) = -1;
                mix(1,1+Ln:L,n) = -1;
            end
            n = n+1;
        end
    end
    
else
    for n = 1:N
        ip = ip_all(n,:);
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
        
        if isblch
            Ln = ceil(random('exp',blch_cst));
            if Ln > L
                Ln = L;
            end
        else
            Ln = L;
        end
        
        mix(state1,:,n) = 1;
        dt_final{n} = [L state1 NaN];
        discr_seq(:,n) = state1*ones(L,1);
        if Ln < L
            discr_seq(1+Ln:L,n) = -1;
            mix(1,1+Ln:L,n) = -1;
        end
    end
end

% save results in project parameters
prm.res_dt{1} = mix;
prm.res_dt{2} = discr_seq;
prm.res_dt{3} = dt_final;
curr.res_dt = prm.res_dt;

% reset following results
prm.res_dat = def.res_dat;
curr.res_dat = prm.res_dat;

% save modifications
p.proj{proj}.sim.curr = curr;
p.proj{proj}.sim.prm = prm;
h.param = p;
guidata(h_fig,h);

% return execution success
ok = 1;
