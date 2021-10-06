function [p,opt2] = updateIntensities(opt2,m,p)

proj = p.curr_proj;
nC = p.proj{proj}.nb_channel;

isCrossCorr = ~isempty(p.proj{proj}.intensities_crossCorr) && ...
    ~all(sum(sum(isnan(p.proj{proj}.intensities_crossCorr(:,...
    ((m-1)*nC+1):m*nC,:)),2),3));
if ~isCrossCorr
    opt2 = 'cross';
end
isBgCorr = ~isempty(p.proj{proj}.intensities_bgCorr) && ...
    ~all(sum(sum(isnan(p.proj{proj}.intensities_bgCorr(:,...
    ((m-1)*nC+1):m*nC,:)),2),3));
if ~isBgCorr
    opt2 = 'ttBg';
end

% save current processing parameters
if isempty(p.proj{proj}.TP.prm{m})
    p.proj{proj}.TP.prm{m} = cell(1,size(p.proj{proj}.TP.curr{m},2));
end
p.proj{proj}.TP.prm{m}([1:3,5]) = p.proj{proj}.TP.curr{m}([1:3,5]);

% correct background
if strcmp(opt2, 'ttBg') || strcmp(opt2, 'ttPr')
    p = bgCorr(m, p);
end

% correct cross-talks
if strcmp(opt2, 'cross') || strcmp(opt2, 'ttBg') || strcmp(opt2, 'ttPr')
    p = crossCorr(m, p);
end

% smooth traces
if strcmp(opt2, 'denoise') || strcmp(opt2, 'cross') || ...
        strcmp(opt2, 'ttBg') || strcmp(opt2, 'ttPr')
    p = denoiseTraces(m, p);
end

% clip traces
if strcmp(opt2, 'debleach') || strcmp(opt2, 'denoise') || ...
        strcmp(opt2, 'cross') || strcmp(opt2, 'ttBg') || ...
        strcmp(opt2, 'ttPr')
    p = calcCutoff(m, p);
end

% save changes to current parameters
p.proj{proj}.TP.curr{m}([1:3,5]) = p.proj{proj}.TP.prm{m}([1:3,5]);
p.proj{proj}.TP.def.mol([1:3,5]) = p.proj{proj}.TP.prm{m}([1:3,5]);

