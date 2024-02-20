function [p,opt] = updateIntensities(opt,m,p,h_fig)

proj = p.curr_proj;
% nC = p.proj{proj}.nb_channel;

% isCrossCorr = ~isempty(p.proj{proj}.intensities_crossCorr) && ...
%     ~all(sum(sum(isnan(p.proj{proj}.intensities_crossCorr(:,...
%     ((m-1)*nC+1):m*nC,:)),2),3));
% if ~isCrossCorr
%     opt = 'cross';
% end
% isReSpl = ~isempty(p.proj{proj}.intensities_bin) && ...
%     ~all(sum(sum(isnan(p.proj{proj}.intensities_bin(:,...
%     ((m-1)*nC+1):m*nC,:)),2),3));
% if ~isReSpl
%     opt = 'resample';
% end
% isBgCorr = ~isempty(p.proj{proj}.intensities_bgCorr) && ...
%     ~all(sum(sum(isnan(p.proj{proj}.intensities_bgCorr(:,...
%     ((m-1)*nC+1):m*nC,:)),2),3));
% if ~isBgCorr
%     opt = 'ttBg';
% end

% save current processing parameters
if isempty(p.proj{proj}.TP.prm{m})
    p.proj{proj}.TP.prm{m} = cell(1,size(p.proj{proj}.TP.curr{m},2));
end
p.proj{proj}.TP.prm{m}([1:3,5]) = p.proj{proj}.TP.curr{m}([1:3,5]);

% correct background
if strcmp(opt, 'ttBg') || strcmp(opt, 'ttPr')
    p = bgCorr(m, p, h_fig);
end

% re-sample trajectories
if strcmp(opt, 'resample') || strcmp(opt, 'ttBg') || strcmp(opt, 'ttPr')
    p = resampleTraj(m, p);
end

% correct cross-talks
if strcmp(opt, 'cross') || strcmp(opt, 'resample') || strcmp(opt, 'ttBg') ...
        || strcmp(opt, 'ttPr')
    p = crossCorr(m, p);
end

% smooth traces
if strcmp(opt, 'denoise') || strcmp(opt, 'cross') || ...
        strcmp(opt, 'resample') || strcmp(opt, 'ttBg') || ...
        strcmp(opt, 'ttPr')
    p = denoiseTraces(m, p);
end

% clip traces
if strcmp(opt, 'debleach') || strcmp(opt, 'denoise') || ...
        strcmp(opt, 'cross') || strcmp(opt, 'resample') || ...
        strcmp(opt, 'ttBg') || strcmp(opt, 'ttPr')
    p = calcCutoff(m, p);
end

% save changes to current parameters
p.proj{proj}.TP.curr{m}([1:3,5]) = p.proj{proj}.TP.prm{m}([1:3,5]);
p.proj{proj}.TP.def.mol([1:3,5]) = p.proj{proj}.TP.prm{m}([1:3,5]);

