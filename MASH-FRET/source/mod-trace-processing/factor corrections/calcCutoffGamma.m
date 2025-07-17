% calculate the cutoff when the acceptor fluorophores bleaches
% adapted from calcCutoff.m
% FS, last updated on 12.1.18
% MH, last update on 27.3.2019 >> i've updated the function to be usable in
% "gammaOpt.m" without messing up with molecule processing parameters 
% p.proj{proj}.prm{mol}. Processing parameters are now set only in the 
% combined function "gammaCorr.m" which is called by "updateTraces.m" (and
% thus "updateFields.m")

function cutOff = calcCutoffGamma(prm, I_a, nExc)

% default
minofft = 0;

thresh = prm(1);
extra = prm(2);
mincut = prm(3);
start = prm(4);
start = ceil(start/nExc);
if start==0
    start = 1;
end
extra = ceil(extra/nExc);
mincut = ceil(mincut/nExc);

[~,cutOff] = calcCutoff_thresh(I_a,minofft,start,thresh,extra,mincut,1);


