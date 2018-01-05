function prm = setDefPrm_TDP(prm_in, trace, isRatio, clr)
% prm = setDefparam_TDP(prm_in, trace)
%
% Set project parameters for TDP analysis if not existing
% "prm_in" >> TDP parameters loaded from project file and for the data type
% "trace" >> discretised traces of all molecules and from data type
% "prm" >> parameters adjusted regarding default parameters
%
% Requires external function: adjustParam.

% Create the 29th of April 2014 by Mélodie C.A.S. Hadzic
% Last update: 27th of May 2014 by Mélodie C.A.S. Hadzic

nStates = 4;
nTrs = nStates*(nStates-1);
nExp = 1;
method = 2;

prm = prm_in;

%% TDP plot
if ~isRatio
    tr_min = trace; tr_min(isnan(tr_min)) = Inf;
    tr_max = trace; tr_max(isnan(tr_max)) = -Inf;
    minVal = min(min(tr_min)); maxVal = max(max(tr_max));
    bin = (maxVal-minVal)/150;
    xy_axis = [bin (minVal-2*bin) (maxVal+2*bin)];
    xy_axis(~isfinite(xy_axis)) = 0;
else
    xy_axis = [0.005 -0.2 1.2];
end

% plotPrm{1} = [bin_x  x_inf  x_sup
%               bin_y  y_inf  y_sup
%               excl   gconv  norm 
%               count  empty  empty]
plotPrm{1} = [xy_axis; xy_axis; [1 0 0]; [0 0 0]];
% plotPrm{2} = TDP matrix
plotPrm{2} = [];
% plotPrm{3} = [dwells, ini. val., fin. val., molecule] >> bin & updated
plotPrm{3} = [];

prm.plot = adjustParam('plot', plotPrm, prm_in);

if size(prm.plot{1},1)<4
    prm.plot = plotPrm;
end


%% strating parameters for clustering (ntrs clusters)
% trs{1} = [method, mode, start nb. of states, curr. trans, restart nb., 
%	  apply bootstrapping, sample nb., replicate nb.]
trs{1} = [method 1 nStates 1 5 0 20 20];
% trs{2} = [state value, tol. radius]
trs{2} = repmat([0 Inf],[nStates,1]);
% trs{3} = rgb colours
trs{3} = clr(1:nTrs,:);

prm.clst_start = adjustParam('clst_start', trs, prm_in);
nStates = size(prm.clst_start,1);
nTrs = nStates*(nStates-1);

% add boba parameters if none
if size(prm.clst_start,2)<8
    prm.clst_start{1}(6:8) = [0 20 20];
end


%% clustering results (Kopt clusters)
% converged state centers and state fractions
% res{1} = [mu, fract]

% transitions adjusted after clustering
% res{2} = [dwells, ini. val., fin. val., mol, TDP_x coord, TDP_y coord,
%     mu_x index, mu_y index] 

% inferred model parameters
% res{3} = struct.BIC, struct.a, struct.o, struct.boba_K

% reference histograms adjusted after clustering
% res{4}{n} = [dwells, occ., norm. occ(1)., cum. occ, 1-cum(P)] dwell-time

prm.clst_res = adjustParam('clst_res', cell(1,4), prm_in);
% add boba results if none
if ~isempty(prm.clst_res{3}) && ~isfield(prm.clst_res{3},'boba_K')
    prm.clst_res{3}.boba_K = [];
    prm.clst_start{1}(6) = 0;
end


%% starting parameters for fitting
% prm.kin_start{n,1} = [stretch, exp nb, curr exp, apply BOBA, repl nb, 
%                       smple nb, weigthing, excl]
% prm.kin_start{n,2} = [low A, start A, up A, low tau, start tau, up tau, 
%                       low beta, start beta, up beta]
kin_def{1} = [0 nExp 1 1 20 100 0 1];
kin_def{2} = repmat([0 0.8 Inf 0 10 Inf 0 0.5 2],[nExp,1]);
prm.kin_def = adjustParam('kin_def', kin_def, prm_in);

kin_start = repmat(prm.kin_def, [nTrs,1]);
prm.kin_start = adjustParam('kin_start', kin_start, prm_in);


%% results of fitting
% kin_res{n,1} = [amp, sig_amp, dec, sig_dec, beta, sig_beta] boba fit
% kin_res{n,2} = [amp, dec, beta] reference fit
% kin_res{n,3} = [amp, dec, beta] inf boba fit
% kin_res{n,4} = [amp, dec, beta] sup boba fit
prm.kin_res = adjustParam('kin_res', cell(nTrs,5), prm_in);






