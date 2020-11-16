function [k_opt,k_err] = script_findBestModel(varargin)
% [k_opt,k_err] = script_findBestModel()
% [k_opt,k_err] = script_findBestModel(fname,import_prm)
%
% Import dwell times from .clst file
% Find and return most sufficient model complexities (in terms of number of degenerated levels) for each state value
% Plot PH fits and BIC results
%
% fname: path to file (clustered dwell times) or none to use default
% import_prm: {1-by-3} import parameters or none to use default
%  import_prm{1}: number of header lines in file
%  import_prm{2}: [1-by-4] file columns to import (time, molecule index, state index before and after transition)
%  import_prm{3}: [1-by-V] state value indexes in file
% w_opt: [1-by-J] optimized transition rate matrix
% w_err: [1-by-J] error matrix

% ex: [k_opt,k_err] = script_findBestModel('C:\data\proj1.clst',{35,[1,4,7,8],[1,2]});

% initialize output
k_opt = [];
k_err = [];
t_comp = tic;

% default
% fname0 = [fileparts(which(mfilename)),'\transition_analysis\clustering',...
%     '\sim_level3_final_publish_STaSI_FRETdonacc1.clst'];
% fname0 = [fileparts(which(mfilename)),'\transition_analysis\clustering',...
%     '\sim_level3_final_publish_vbFRET_2states_FRETdonacc1.clst'];
% import_prm0 = {35,[1,4,7,8],[1,2]};
% fname0 = [fileparts(which(mfilename)),'\transition_analysis\clustering',...
%     '\sim_level2_final_publish_vbFRET_3states_FRETdonacc1.clst'];
% import_prm0 = {56,[1,4,7,8],[1,2,3]};
fname0 = [fileparts(which(mfilename)),'\transition_analysis\clustering',...
    '\sim_level1_final_publish_vbFRET_2states_FRETdonacc1.clst'];
import_prm0 = {35,[1,4,7,8],[1,2]};
J_deg_max = 4; % maximum number of degenerated levels

% import settings
if nargin==0
    fname = fname0;
    import_prm = import_prm0;
elseif nargin==2
    fname = varargin{1};
    import_prm = varargin{2};
else
    disp('The number of input arguments is incorrect: type *help script_findBestModel* for help');
    return
end

% Get optimum DPHs for each model complexity
V = numel(import_prm{3});
mdl = cell(1,J_deg_max);
logL = Inf(V,J_deg_max);
for J_deg = 1:J_deg_max
    fprintf('for %i degenerated levels\n',J_deg);
    prm = [import_prm,repmat(J_deg,1,V)];
    [mdl{J_deg},~] = script_inferPH(0,fname,prm,1);
    LogL_v = [];
    for v = 1:V
        LogL_v = cat(1,LogL_v,mdl{J_deg}.logL{v});
    end
    logL(:,J_deg) = LogL_v;
end

% calculate BIC for all possible combinations of DPHs
N = sum(mdl{1}.N);
cmb = getCombinations(1:J_deg_max,1:V);
nCmb = size(cmb,1);
J = sum(cmb,2);
[J,id] = sort(J,'ascend');
cmb = cmb(id,:);
% df = (J.*(J+1))'; % J initial prob, J^2 trans prob
df = ((J.^2)-1)'; % (J-1) initial prob, J*(J-1) trans prob
BIC_cmb = -Inf(1,nCmb);
for c = 1:nCmb
    logL_c = 0;
    for v = 1:V
        logL_c = logL_c + logL(v,cmb(c,v));
    end
    BIC_cmb(c) = df(c)*log(N)-2*logL_c;
end

% calculate BIC for each DPH
BIC = -Inf(V,J_deg_max);
for J_deg = 1:J_deg_max
%     df = (J_deg*(J_deg+1));
    df = ((J_deg^2)-1);
    for v = 1:V
        N = mdl{1}.N(v);
        BIC(v,J_deg) = df*log(N)-2*logL(v,J_deg);
    end
end

disp('>> plot results');

% plot BIC for each combination of dwell time histograms
incl = ~isinf(BIC_cmb);
hfig1 = figure('color','white');
hfig1.Position = ...
    [hfig1.Position([1,2]),V*hfig1.Position(3)/2,hfig1.Position(4)];
cmbs = 1:nCmb;
ha1 = axes('parent',hfig1);
xlabel('Model complexity');
plot(ha1,cmbs(incl),BIC_cmb(incl),'+b','linewidth',2);
ha1.YLim = [min(BIC_cmb(incl)),max(BIC_cmb(incl))];
ha1.XLim = [0.5,nCmb+0.5];
ha1.XTick = cmbs;
ha1.XTickLabel = compose(repmat('%i',1,V),cmb)';
if v==1
    ylabel('normalized BIC');
end

% plot BIC for each dwell time histogram
incl = ~isinf(BIC);
J_degs = 1:J_deg_max;
hfig2 = figure('color','white');
hfig2.Position = ...
    [hfig2.Position([1,2]),V*hfig2.Position(3)/2,hfig2.Position(4)];
for v = 1:V
    ha2 = subplot(1,V,v);
    xlabel(sprintf('Model complexity for state %i',v));
    plot(ha2,J_degs(incl(v,:)),(BIC(v,incl(v,:))-min(BIC(v,incl(v,:))))/...
        (max(BIC(v,incl(v,:)))-min(BIC(v,incl(v,:)))),'+b',...
        'linewidth',2);
    ha2.YLim = [0,1];
    ha2.XLim = [0.5,J_deg_max+0.5];
    if v==1
        ylabel('normalized BIC');
    end
end
drawnow;

fprintf('Best model found in %0.0f seconds\n',toc(t_comp));


function cmb = getCombinations(js,vs)

cmb = [];
for v = 1:numel(vs)
    if v>1
        cmb_add = [];
        for j = 1:numel(js)
            cmb_add = cat(1,cmb_add,cat(2,cmb,repmat(js(j),size(cmb,1),1)));
        end
        cmb = cmb_add;
    else
        cmb = js';
    end
end

