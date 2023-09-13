function mdl = script_inferPH(dt,n_rs,schm,savecurve)
% mdl = script_inferPH(dt,n_rs,schm,savecurve)
%
% Trains DPH distributions of specific complexities (in terms of number of degenerated levels) on experimental dwell time histograms (one histogram per state value).
% Returns best fit parameters
%
% dt: [nDat-by-2] dwell times, count
% n_rs: number of restarts
% schm: [D+2-by-D+2] transition schemes to fit
% savecurve: empty or destination folder to save best fit curves
% mdl: structure containing fit DPH parameters
%   mdl.pi_fit: [1-by-D] starting probabilities
%   mdl.tp_fit: [D-by-D+1] transition probabilities among degenerated states of a same state value
%   mdl.logL: log likelihood
%   mdl.N: number of bins in dwell tiem histogram
%   mdl.schm: [D+2-by-D+2] transition scheme that was fit

% defaults
PH_type = 1;% 1 for discrete, 2 for continuous

% control data sufficiency
if isempty(dt)
    mdl.pi_fit = 1;
    mdl.tp_fit = [1,0];
    mdl.logL = -Inf;
    mdl.N = 0;
    mdl.schm = schm;
    fprintf('no dwell time left for ML-DPH\n');
    return
end

% collect DPH fit curve export
saveit = ~isempty(savecurve);

% get data mensurations
D = size(schm,1)-2;
x = dt(:,1)';
P = dt(:,2)';
nDat = sum(P);
incl = (x>0 & P>0);

% ML-DPH inference
logL = -Inf;
a_fit = [];
T_fit = [];
rs = 1;
rs0 = 0;
while rs<=n_rs
    if rs0~=rs
        fprintf(['restart ',num2str(rs),'/',num2str(n_rs),': ']);
        rs0 = rs;
    end

    % random starting guess for initial probabilities
    a_start = double(schm(1,2:end-1));
    a_start = a_start/sum(a_start);
    
    % random starting guess for transition probabilities
    if PH_type==2 % continuous PH
        w0 = rand(D,D+1);
        w0(~schm(2:end-1,2:end)) = 0;
        w0 = w0./repmat(sum(w0,2),[1,D+1]);

        r0 = rand(D,1);

        T_start = w0.*repmat(r0,[1,D+1]);
        t_start = T_start(:,end);
        T_start = T_start(:,1:D);
        T_start(~~eye(D)) = -(sum(T_start,2)+t_start);
    end

    if PH_type==1 % discrete PH
        tp0 = rand(D,D+1);
        tp0(~schm(2:end-1,2:end)) = 0;
        tp0(~~eye(size(tp0))) = 10;
        tp0 = tp0./repmat(sum(tp0,2),[1,D+1]);

        t_start = tp0(:,D+1);
        T_start = tp0(:,1:D);
    end

    % train a PH model on experimental CDF
    [a_res,T_res,logL_res,nb_res] = ...
        trainPH(a_start,T_start,t_start,[x(incl);P(incl)]);
    if isinf(logL_res) || isempty(a_res) || isempty(T_res)
        dispProgress('',nb_res);
        continue
    end
    rs = rs+1;
    if logL_res>logL
        logL = logL_res;
        a_fit = a_res;
        T_fit = T_res;
    end
end

if isempty(a_fit) || isempty(T_fit)
    mdl.pi_fit = [];
    mdl.tp_fit = [];
    mdl.logL = Inf;
    mdl.N = nDat;
    mdl.schm = schm;
    return
end

% export hitstogram and DPH fit curve to ASCII file
v_e = ones(D,1);
if saveit
    L = numel(x);
    P_fit = zeros(1,L);
    if ~(isempty(a_fit) || isempty(T_fit))
        if PH_type==1 % discrete PH
            t = v_e-T_fit*v_e;
        end
        for l = 1:L
            if PH_type==1 % discrete PH
                P_fit(1,l) = a_fit*(T_fit^(x(l)-1))*t;
            else% continuous PH
                P_fit(1,l) = a_fit*expm(T_fit*x(l))*v_e;
            end
        end
    end
    dat = [x',P',P_fit'];
    save(savecurve,'dat','-ascii')
end

% get DPH transition probabilities
if PH_type==2 % continuous PH
    r = -diag(T_fit)/dt_bin;
    w = T_fit./repmat(r,1,D);
    w(~~eye(D)) = 0;
    w = cat(2,w,1-sum(w,2));
    tp_fit = w.*repmat(r,[1,D+1]);
    tp_fit(~~eye(D)) = 1-sum(tp_fit,2);
    
else % discrete PH
    t = v_e-T_fit*v_e;
    tp_fit = [T_fit,t];
end

% return results
mdl.pi_fit = a_fit;
mdl.tp_fit = tp_fit;
mdl.logL = logL;
mdl.N = nDat;
mdl.schm = schm;

