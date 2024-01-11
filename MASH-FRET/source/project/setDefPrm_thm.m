function prm = setDefPrm_thm(prm_in,dat,isratio,clr)

% defaults
K = 2;
axisratio = [-0.2,0.025,1.2];
boba = 1;
Nrepl = 1;
Nspl = 100;
wght = 1;


% determines data type
dattype = dat{1};
dat = dat{2};

% Histograms plot
if isratio
    bin = axisratio(2);
    minVal = axisratio(1);
    maxVal = axisratio(3);
    Nrepl = size(dat,2);
elseif dattype==1 % trajectories
    tr_min = dat; tr_min(isnan(tr_min)) = Inf;
    tr_max = dat; tr_max(isnan(tr_max)) = -Inf;
    minVal = min(min(tr_min)); maxVal = max(max(tr_max));
    bin = (maxVal-minVal)/150;
    minVal = 0;
    maxVal = (maxVal+2*bin);
    Nrepl = size(dat,2);
elseif dattype==2 % histogram
    bin = dat(2,1)-dat(1,1);
    minVal = dat(1,1)-bin/2;
    maxVal = dat(end,1)+bin/2;
    boba = 0;
end
xy_axis = [bin minVal maxVal];
xy_axis(~isfinite(xy_axis)) = 0;

% plotPrm{1} = [bin_x, x_inf, x_sup, overflow bins]
if isempty(xy_axis)
    xy_axis = [0.1,0,1];
end
plotPrm{1} = [xy_axis 0];
% plotPrm{2} = [interval, probability, cumulative probability]
plotPrm{2} = [];
% plotPrm{3} = total number of data points
plotPrm{3} = 0;

prm.plot = adjustParam('plot', plotPrm, prm_in);

% starting parameters for thermodynamic analysis
% thm{1} = [method, apply BOBA, repl. nb., sample nb., weighting]
thm{1} = [1 boba Nrepl Nspl wght];
% thm{2} = threshold values
thresh = linspace(0,1,K+1);
thm{2} = thresh(2:end-1);
% thm{3} = [low amp., start amp., up amp., low center, start center, 
%           up center, low FWHM, start FWHM, up FWHM clr]
states = linspace(0,1,K+2);
thm{3} = [repmat([0 0.1 Inf -Inf],[K,1]) states(2:end-1)' ...
    repmat([Inf 0 0.14 Inf],[K,1]) clr(1:K,:)];
% thm{4} = [apply improvement factor, improvement factor, max. nb. of Gaussian, likelihood calculation]
thm{4} = [0 1.2 10 1];
prm.thm_start = adjustParam('thm_start', thm, prm_in);


% results for thermodynamic analysis
% res{1,1} = [relative pop., sigma]
% res{1,2} = bootstrap populations
% res{1,3} = sampled histograms

% res{2,1} = [amp. fit, amp. sigma, center fit, center sigma, FWHM fit, 
%           FWHM sigma, rel. occ. fit, rel. occ. sigma]
% res{2,2} = [bootstrap amp., bootstrap center, bootstrap FWHM, bootstrap 
%           rel. occ.]
% res{2,3} = sampled histograms

% res{3,1} = [logL BIC AIC]
% res{3,2}{K} = [best amp., best center, best FWHM]
% res{3,3} = []
res = cell(3,3);
prm.thm_res = adjustParam('thm_res', res, prm_in);


