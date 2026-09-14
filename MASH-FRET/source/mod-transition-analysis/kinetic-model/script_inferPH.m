function [mdl,nb] = script_inferPH(dt,PHtype,R,dlmin,dpmin,mmax,schm,...
    savecurve,verbose)
% [mdl,nb] = script_inferPH(dt,PHtype,R,dlmin,schm,savecurve,dispit)
%
% Trains phase-type (PH) distributions of specific complexities in terms of 
% number of degenerated levels on experimental dwell time histograms and 
% returns best fit parameters
%
% dt: [nDat-by-2] dwell times, count
% PHtype: 1 for discrete distribution, 2 for continuous
% R: number of successful initializations to stop process
% dlmin: convergence criterion on log-likelihood ratio
% dpmin: convergence criterion on parameters
% mmax: maximum nb of EM iterations
% schm: [D+2-by-D+2] transition schemes to fit
% savecurve: empty or destination folder to save best fit curves
% dispit: 1 to show progress in command window, 0 to mute
% mdl: structure containing fit PH parameters
%   mdl.pi_fit: [1-by-D] starting probabilities
%   mdl.tp_fit: [D-by-D+1] transition probabilities among expTydegenerated states of a same state value
%   mdl.logL: log likelihood
%   mdl.N: number of dwell times
%   mdl.schm: [D+2-by-D+2] transition scheme that was fit
%   mdl.cvg: 1 if MLPH has converged, 0 otherwise
%   mdl.PHtype: distribution type 1 for discrete PH, 2 for continuous PH
% nb: number of characters printed in command window

% control data sufficiency
nb = 0;
mdl = initmdlstruct(PHtype,0,schm);
if isempty(dt)
    if verbose
        nb = fprintf('no dwell time left for ML-PH\n');
    end
    return
end

% collect PH fit curve export
saveit = ~isempty(savecurve);

% adjust convergence criterion on log-likelihood
if isequal(dlmin,'auto')
    dlmin = 0;
end

% get model characteristics
D = size(schm,1)-2;

% get data characteristics
nDat = sum(dt(:,end)); % total histogram count
logbin = size(dt,2)==3; % bins are log-scaled

% ML-PH inference
logL_best = -Inf;
a_best = [];
T_best = [];
t_best = [];
r = 0;
while r<R
    if verbose
        nb = dispProgress(sprintf(' success %i/%i: ',r+1,R),nb);
    end

    % random starting guess for initial probabilities
    a0 = double(schm(1,2:end-1));
    a0 = a0/sum(a0);
    
    % random starting guess for transition probabilities
    tp0 = rand(D,D+1);
    tp0(~schm(2:end-1,2:end)) = 0;
    tp0(~~eye(D,D+1)) = 10*rand(1,D);
    tp0 = tp0./repmat(sum(tp0,2),[1,D+1]);
    if PHtype==2 % continuous PH
        tp0(~~eye(D,D+1)) = 0;
        tp0(~~eye(D,D+1)) = -sum(tp0,2);
    end
    T0 = tp0(:,1:D);
    t0 = tp0(:,end);

    % train a PH model on experimental CDF
    switch PHtype
        case 1 % DPH, C-code faster
            if logbin
                [a_fit,T_fit,logL_fit,nb_fit] = trainPH_logbin(a0,T0,t0,dt',...
                    dlmin,dpmin,mmax,verbose,logbin);
            else
                [a_fit,T_fit,logL_fit,m_fit,nb_fit,cvg] = trainPH(a0,T0,t0,...
                    dt',dlmin,dpmin,mmax,~~verbose);
            end
            t_fit = 1-sum(T_fit,2);
        case 2 % CPH, C-code missing (matrix exponential calculations?)
            [a_fit,T_fit,t_fit,logL_fit,nb_fit] = trainPH_matlab(PHtype,a0,...
                T0,dt',~verbose);
    end
    if isinf(logL_fit) || isempty(a_fit) || isempty(T_fit) || ...
            isempty(t_fit)
        dispProgress('',nb_fit);
        continue
    end
    nb = nb+nb_fit;
    r = r+1;
    if logL_fit>logL_best
        logL_best = logL_fit;
        a_best = a_fit;
        T_best = T_fit;
        t_best = t_fit;
    end
end
if isempty(a_best) || isempty(T_best) || isempty(t_best)
    return
end

% export hitstogram and PH fit curve to ASCII file
if saveit
    L = length(dt);
    P_fit = zeros(L,1);
    if ~(isempty(a_best) || isempty(T_best)) || isempty(t_best)
        for l = 1:L
            switch PHtype
                case 1 % discrete PH
                    P_fit(l) = a_best*(T_best^(dt(l,1)-1))*t_best;
                case 2 % continuous PH
                    P_fit(l) = a_best*expm(T_best*dt(l,1))*t_best;
            end
        end
    end
    dat = [dt,P_fit];
    save(savecurve,'dat','-ascii')
end

% get transition probability matrix from generator matrix
tp_best = tpfromT(T_best,t_best,PHtype);

% return results
mdl.pi_fit = a_best;
mdl.tp_fit = tp_best;
mdl.logL = logL_best;
mdl.N = nDat;
mdl.schm = schm;
mdl.PHtype = PHtype;
mdl.cvg = ~isinf(logL_best) & ~isnan(logL_best);


function mdl = initmdlstruct(PHtype,nDat,schm)
mdl.pi_fit = [];
mdl.tp_fit = [];
mdl.logL = -Inf;
mdl.N = nDat;
mdl.schm = schm;
mdl.PHtype = PHtype;
mdl.cvg = false;


function tp = tpfromT(T,t,PH_type)

% get PH transition probabilities
D = size(T,1);
tp = [T,t];
if PH_type==2 % continuous PH
    tp(~~eye(D)) = 0;
    tp(~~eye(D)) = 1-sum(tp,2);
end


