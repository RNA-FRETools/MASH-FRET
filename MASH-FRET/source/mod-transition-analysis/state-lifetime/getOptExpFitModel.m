function [res,ok] = getOptExpFitModel(dat,v,excl,hist_ref,nSpl,h_fig,lb)
% [res,ok] = getOptExpFitModel(dat,v,excl,hist_ref,nSpl,h_fig,lb)
%
% Determine the most sufficient number of exponenital function to describe the dwell time set and return the best set of fit parameters
%
% dat: [nDt-by-8] dwell times, state value before and after transition, molecule index, x- and y- TDP cooridnates, state indexes before and after transition
% v: state value index in list
% excl: (1) to exclude first and last dwell times, (0) otherwise
% hist_ref: {1-by-V} reference complementary cumulative histogram (last column) for all transitions (first cell) and each particular transitions
% nSpl: number of bootstrap sample
% h_fig: handle to main figure
% lb: (0) do not create a loading bar, (>0) otherwise
% res: structure containing fit results with fields:
%  res.fit_ref
%  res.n_rep
%  res.boba_mean
%  res.boba_inf
%  res.bob_sup
%  res.histspl
%  res.boba_fitres: [nExp-by-2] fitting parameters (amplitude and decay constant)
% ok: computation success (1) or failure (0)

% Created, 25.4.2020 by MH.

% initialize output
res = [];

% defaults
nMax = 3; % maximum number of exponential functions in the sum
ampMin = 0;
ampMax = Inf;
tauMin = 0;
tauMax = Inf;
modelSlct = 'mean'; % method to select the most sufficient number of exponential functions ('conf' or 'mean')
tol = 3; % deviation multiplication factor used to dertermine the number of decays (ex:3 for 3*sigma)
conf = 0; % confidence (maximum overlap percentage of decay error ranges)

% sort dwell times for BOBA analysis
[dt,~,~,ok,errmsg] = getDtFromState(dat,v,0,excl);
if ~ok
    if lb>0
        setContPan(errmsg,'error',h_fig);
    else
        disp(errmsg);
    end
    return
end
w_vect = ones(size(dt,2),1);

% open loading bar
if lb>0
    lb = 1;
end
if lb>0 && loading_bar('init',h_fig,nMax*nSpl,...
        'Determine most sufficient model to describe dwell times...')
    ok = 0;
    return
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;

% mute confirmation about number of replicates
prevMute = h.mute_actions;
h.mute_actions = true;
guidata(h_fig, h);

% set starting guess and parameter bounds
minDt = min(hist_ref(hist_ref(:,1)>0,1));
maxDt = max(hist_ref(:,1));
tau_start = logspace(log10(maxDt),log10(minDt),nMax);
amp0 = [ampMin*ones(nMax,1),...
    flip(logspace(-2,0,nMax),2)',...
    ampMax*ones(nMax,1)];
tau0 = [tauMin*ones(nMax,1),...
    flip(tau_start,2)',...
    tauMax*ones(nMax,1)];
fitprm0 = [amp0,tau0];

for n = nMax:-1:1
    
    fitprm = fitprm0(1:n,:);
    
    p_fit.lower = reshape(fitprm(:,[1,4])',[1,numel(fitprm(:,[1,4]))]);
    p_fit.start = reshape(fitprm(:,[2,5])',[1,numel(fitprm(:,[2,5]))]);
    p_fit.upper = reshape(fitprm(:,[3,6])',[1,numel(fitprm(:,[3,6]))]);
    
    % preliminary fit
    ref_res = mmexpfit_mod(hist_ref(:,1),hist_ref(:,end),p_fit,n,false);
    if isempty(ref_res)
        setContPan(...
            ['Preliminary fit with ',num2str(n),' components failed.'],...
            'error',h_fig)
        continue
    end

    p_fit.start = reshape(ref_res.cf',[1,numel(ref_res.cf)]);
    
    % bootstrap fit
    boba_res = BOBA_ana(dt,p_fit,false,n,true,0,nSpl,w_vect,h_fig,lb);
    if isempty(boba_res)
        ok = 0;
        res = [];
        return
    end
    
    % organise results
    boba_mean = mean(boba_res.cf,1);
    boba_std = std(boba_res.cf,0,1);
    cf_boba = reshape([boba_mean;boba_std],...
        [1 numel([boba_mean;boba_std])]);
    cf_boba = reshape(cf_boba',[4 n])';
    cf = sortrows(boba_res.cf,2); % sort according to 1st time decay
    
    % store results
    res.fit_ref = reshape(ref_res.cf',[2,n])';
    res.n_rep = boba_res.n_rep;
    res.spl = {boba_res.histall,boba_res.cf};
    res.boba_mean = cf_boba;
    res.boba_inf = reshape(cf(1,:)',[2 n])';
    res.boba_sup = reshape(cf(end,:)',[2 n])';
    
    % determine model validity
    tau = boba_mean(2:2:end)';
    o_tau = boba_std(2:2:end)';
    if isExpFitValid(n,tau,o_tau,tol,conf,modelSlct)
        break
    end
end

% close loading bar
if lb>0
    loading_bar('close', h_fig);
end

ok = 1;

% reset action muting
h.mute_actions = prevMute;
guidata(h_fig, h);

