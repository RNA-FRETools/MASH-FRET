function [degen,mdl,cmb,BIC_cmb,BIC] = script_findBestModel(dt,J_deg_max,states,expT,dt_bin)
% [degen,mdl,cmb,BIC_cmb,BIC] = script_findBestModel(dt,J_deg_max,states,expT,dt_bin)
%
% Import dwell times from .clst file
% Find and return most sufficient model complexities (in terms of number of degenerated levels) for each state value
% Plot PH fits and BIC results
%
% dt: [nDt-by-3] dwell times (s), molecule indexes, state values
% J_deg_max: maximum number of degenerated levels
% states: [1-by-V] state values in dt
% expT: bin time (s)
% dt_bin: binning factor for dwell times prior building histogram
% degen: [1-by-V] most sufficient model complexity (number of degenerated levels per state value)
% mdl: structures containing best DPH fit parameters for the most sufficient model
%   mdl.pi_fit: {1-by-V} starting probabilities
%   mdl.tp_fit: {1-by-V} transition probabilities among degenerated states of a same state value
%   mdl.logL: {1-by-V} log likelihoods for best fits
%   mdl.N: [1-by-V] number of data
% cmb: [nCmb-by-V] all possible combinations of model complexities
% BIC_cmb: [1-by-nCmb] BIC for all complexity combinations
% BIC: [V-by-J_deg_max] BIC for all complexities

t_comp = tic;

% default
plotIt = true;

% Get optimum DPHs for each model complexity
disp('Train DPH distributions on binned dwelltime histograms...')
V = numel(states);
mdl = cell(1,J_deg_max);
logL = Inf(V,J_deg_max);
for J_deg = 1:J_deg_max
    fprintf('for %i degenerated states: ',J_deg);
    mdl{J_deg} = script_inferPH(dt,states,expT,dt_bin,repmat(J_deg,[1,V]),0);
    LogL_v = [];
    for v = 1:V
        LogL_v = cat(1,LogL_v,mdl{J_deg}.logL(v));
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

[~,cmb_opt] = min(BIC_cmb);
degen = cmb(cmb_opt,:);
id = [];
for v = 1:V
    id = cat(2,id,repmat(v,[1,degen(v)]));
end
fprintf(['Most sufficient state configuration:\n[%0.2f',...
    repmat(',%0.2f',[1,numel(states(id))-1]),']\n'],states(id));

% infer "true" DPH parameters
disp('Optimize DPH distributions on authentic dwell time histograms...')
mdl = script_inferPH(dt,states,expT,1,degen,1);

fprintf('Most sufficient model complexity found in %0.0f seconds\n',...
    toc(t_comp));

if ~plotIt
    return
end

% plot results
hfig1 = figure('color','white');
hfig1.Position = ...
    [hfig1.Position([1,2]),2*V*hfig1.Position(3)/2,hfig1.Position(4)];

% plot BIC for each dwell time histogram
incl = ~isinf(BIC);
J_degs = 1:J_deg_max;
for v = 1:V
    ha = subplot(1,2*V,v);
    xlabel(sprintf('Model complexity for state %i',v));
    plot(ha,J_degs(incl(v,:)),(BIC(v,incl(v,:))-min(BIC(v,incl(v,:))))/...
        (max(BIC(v,incl(v,:)))-min(BIC(v,incl(v,:)))),'+b',...
        'linewidth',2);
    ha.YLim = [0,1];
    ha.XLim = [0.5,J_deg_max+0.5];
    if v==1
        ylabel('normalized BIC');
    end
end

% plot BIC for each combination of dwell time histograms
incl = ~isinf(BIC_cmb);
cmbs = 1:nCmb;
ha = subplot(1,2,2);
xlabel('Model complexity');
plot(ha,cmbs(incl),BIC_cmb(incl),'+b','linewidth',2);
ha.YLim = [min(BIC_cmb(incl)),max(BIC_cmb(incl))];
ha.XLim = [0.5,nCmb+0.5];
ha.XTick = cmbs;
ha.XTickLabel = compose(repmat('%i',1,V),cmb)';
if v==1
    ylabel('normalized BIC');
end

drawnow;


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

