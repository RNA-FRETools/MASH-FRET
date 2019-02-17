% calculate the cutoff when the acceptor fluorophores bleaches
% adapted from calcCutoff.m
% FS, last updated on 12.1.18

function p = calcCutoffGamma(mol, p)

proj = p.curr_proj;
curr_mol = p.proj{proj}.curr{mol};
FRET = p.proj{proj}.FRET;
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
nFRET = size(p.proj{proj}.FRET,1);

I_den = p.proj{proj}.intensities_denoise(:, ...
    ((mol-1)*nChan+1):mol*nChan,:);

lastData = sum(double(~isnan(I_den(:,1,1))));

for i = 1:nFRET
    chan = FRET(i,2); % the acceptor channel
    start = ceil(curr_mol{5}{5}(i,5)/nExc);
    if start == 0
        start = 1;
    end
    ex = FRET(i,1);
    trace = I_den(:,chan,ex);
    nbFrames = numel(trace);
    trace = trace(start:nbFrames,:);
    frames = (1:nbFrames)';
    thresh = curr_mol{5}{5}(i,2);
    extra = curr_mol{5}{5}(i,3);
    extra = ceil(extra/nExc);
    minCut = ceil(curr_mol{5}{5}(i,4)/nExc);
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
    p.proj{proj}.curr{mol}{5}{5}(i,6) = cutOff*nExc;
end

