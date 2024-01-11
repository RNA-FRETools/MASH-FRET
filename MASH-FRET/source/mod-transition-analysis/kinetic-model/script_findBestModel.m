function [D,mdlopt,mdl,dthist] = script_findBestModel(dt,Dmax,states,...
    expT,bin,T,sumexp,savecurve)
% [D,mdlopt,mdl,dthist] = script_findBestModel(dt,Dmax,states,expT,bin,T,sumexp,savecurve)
%
% Import dwell times from .clst file
% Find and return most sufficient model complexities (in terms of number of degenerated levels) for each state value
% Plot PH fits and BIC results
%
% dt: [nDt-by-3] dwell times (s), molecule indexes, state values
% Dmax: maximum number of degenerated levels
% states: [1-by-V] state values in dt
% expT: bin time (s)
% bin: binning factor for dwell times prior building histogram
% T: number of restart
% sumexp: (1) to fit a sume of exponential (0) to fit DPH
% savecurve: empty or destination folder to save best fit curves
% D: [1-by-V] most sufficient model complexity (number of degenerated 
%  levels per state value)
% mdlopt: [V-by-1] structure array containing best DPH fit parameters for 
%  the most sufficient model
%   mdlopt.pi_fit: {1-by-V} starting probabilities
%   mdlopt.tp_fit: {1-by-V} transition probabilities among degenerated 
%    states of a same state value
%   mdlopt.logL: {1-by-V} log likelihoods for best fits
%   mdlopt.N: [1-by-V] number of data
%   mdlopt.schm: {1-by-V} transition schemes
% mdl: {V-by-1}[S-by-1] structure array containing DPH fit parameters 
%  for model qualifications
% dthist: {1-by-V} dwell time histograms

% default
reffle = 'ref-table-schemes.mat'; % source file containing all transition schemes

% load already found possible transitions schemes
src = fileparts(mfilename('fullpath'));
reffle = [src,filesep,reffle];
schmD = {};
schm_tp = {};
ref.schmD = schmD;
ref.schm_tp = schm_tp;
if exist(reffle,'file')
    ref = load(reffle);
    schmD = ref.schmD;
    schm_tp = ref.schm_tp;
end

% initialize computation time
t_comp = tic;

% get dwell time histograms
V = numel(states);
dthist = cell(1,V);
dthist_bin = cell(1,V);
for v = 1:V
    dt_v = dt(dt(:,3)==v,1);
    if isempty(dt_v)
        continue
    end
    dt_v(:,1) = dt_v(:,1)/expT;
    
    % original dwell time histogram
    edg = 0.5:(max(dt_v)+0.5);
    x = mean([edg(2:end);edg(1:end-1)],1);
    P = histcounts(dt_v,edg);
    dthist{v} = [x',P'];
    
    % binned dwell time histogram
    dt_bin = bin*round(dt_v/bin); 
    edg = (bin/2):(max(dt_bin)+bin/2);
    x = mean([edg(2:end);edg(1:end-1)],1);
    P = histcounts(dt_bin,edg);
    dthist_bin{v} = [x',P'];
end

% Perorm ML-DPH
dispProgress('Perform ML-DPH on binned dwelltime histograms...\n',0);
mdl = cell(1,V);
schm_opt = cell(1,V);
for v = 1:V
    fprintf('for state %i/%i:\n',v,V);
    [schm_opt{v},mdl{v}] = MLDPH(dthist_bin{v},T,sumexp,Dmax);
end

% append reference file
if ~isequal(schmD,ref.schmD) || ~isequal(schm_tp,ref.schm_tp)
    save(reffle,'schmD','schm_tp','-mat');
end

% infer "true" DPH parameters
fprintf('Test best fit on authentic dwell time histograms...\n');
mdlopt.pi_fit = cell(1,V);
mdlopt.tp_fit = cell(1,V);
mdlopt.schm = cell(1,V);
mdlopt.logL = zeros(1,V);
mdlopt.N = zeros(1,V);
mdlopt.BIC = zeros(1,V);
for v = 1:V
    cvg = false;
    best = 0;
    while ~cvg
        best = best+1;
        D_v = size(schm_opt{v}{best},1)-2;
        if ~isempty(savecurve)
            ffile = [savecurve,sprintf('_dph_state%iD%i_dphplot',v,D_v)];
        else
            ffile = [];
        end
        mdl_v = script_inferPH(dthist{v},1,schm_opt{v}{best},ffile);
        cvg = isdphvalid(mdl_v.tp_fit) && ~isdoublon(mdl_v.tp_fit);
        if ~cvg
            mdl{v}(best).cvg = false;
            mdl{v}(best).BIC = Inf;
        end
    end
    mdlopt.pi_fit{v} = mdl_v.pi_fit;
    mdlopt.tp_fit{v} = mdl_v.tp_fit;
    mdlopt.schm{v} = mdl_v.schm;
    mdlopt.logL(v) = mdl_v.logL;
    mdlopt.N(v) = mdl_v.N;
    nfp = sum(sum(mdl_v.schm))-1;
    mdlopt.BIC(v) = nfp*log(mdl_v.N)-2*mdl_v.logL;
end

% show most sufficient state configuration
id = [];
D = zeros(1,V);
for v = 1:V
    D(v) = size(mdlopt.schm{v},1)-2;
    id = cat(2,id,repmat(v,[1,D(v)]));
end
fprintf(['Most sufficient state configuration:\n[%0.2f',...
    repmat(',%0.2f',[1,numel(states(id))-1]),']\n'],states(id));

% save computation time
mdlopt.t_dphtest = toc(t_comp);

fprintf('Most sufficient model complexity found in %0.0f seconds\n',...
    toc(t_comp));
