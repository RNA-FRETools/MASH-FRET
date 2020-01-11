% calculate the cutoff when the acceptor fluorophores bleaches
% adapted from calcCutoff.m
% FS, last updated on 12.1.18
% MH, last update on 27.3.2019 >> i've updated the function to be usable in
% "gammaOpt.m" without messing up with molecule processing parameters 
% p.proj{proj}.prm{mol}. Processing parameters are now set only in the 
% combined function "gammaCorr.m" which is called by "updateTraces.m" (and
% thus "updateFields.m")

function cutOff = calcCutoffGamma(prm, trace, nExc)

thresh = prm(1);
extra = prm(2);
minCut = prm(3);
start = prm(4);
lastData = sum(double(~isnan(trace)));
start = ceil(start/nExc);
if start == 0
    start = 1;
end

nbFrames = numel(trace);
trace = trace(start:nbFrames,:);
frames = (1:nbFrames)';
extra = ceil(extra/nExc);
minCut = ceil(minCut/nExc);
cutOff = find(trace < thresh) + start - 1;
if ~isempty(cutOff)
    cutOff2 = frames(cutOff) - extra;
    [r,~,~] = find(cutOff2 > minCut);
    if ~isempty(r) &&  cutOff2(r(1),1)<lastData
        cutOff = cutOff2(r(1),1);
    else
        cutOff = lastData;
    end
else
    cutOff = lastData;
end


