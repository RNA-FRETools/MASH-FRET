function p = calcCutoff(mol, p)

proj = p.curr_proj;

incl = false(size(p.proj{proj}.bool_intensities(:,mol)));
prm = p.proj{proj}.prm{mol}{2};
apply = prm{1}(1);
FRET = p.proj{proj}.FRET;
gamma = p.proj{proj}.prm{mol}{5}{3};

nExc = p.proj{proj}.nb_excitations;
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
start = ceil(prm{1}(4)/nExc);

method = prm{1}(2);
if method == 1
    cutOff = floor(prm{1}(4+method)/nExc);
else
    nChan = p.proj{proj}.nb_channel;
    nFRET = size(p.proj{proj}.FRET,1);
    nS = size(p.proj{proj}.S,1);

    I_den = p.proj{proj}.intensities_denoise(:, ...
        ((mol-1)*nChan+1):mol*nChan,:);
    chan = prm{1}(3);
    
    lastData = sum(double(~isnan(I_den(:,1,1))));

    if chan <= nFRET % single FRET channel
        i_f = chan;
        fret = calcFRET(nChan, nExc, exc, chanExc, FRET, I_den, gamma);
        trace = fret(:,i_f);

    elseif chan <= (nFRET+nS) % single stoichiometry channel
        i_s = chan - nFRET;
        S_chan = p.proj{proj}.S(i_s,:);
        [o,l_s,o] = find(exc==chanExc(S_chan));
        trace = sum(I_den(:,:,S_chan(1)),2)./sum(sum(I_den(:,:,:),2),3);

    elseif chan <= (nFRET+nS+nExc*nChan) % single intensity channel
        i_exc = ceil((chan - nFRET - nS)/nChan);
        i_c = (chan - nFRET - nS)-(i_exc-1)*nChan;
        trace = I_den(:,i_c,i_exc);

    elseif chan == (nFRET+nS+nExc*nChan+1) % all intensities
        trace = min(min(I_den, [], 3), [], 2);

    else % summed intensities
        trace = sum(sum(I_den,3),2);
    end
    
    nbFrames = numel(trace);
    
    trace = trace(start:end,:);
    frames = (1:nbFrames)';
    
    thresh = prm{2}(chan,1);
    extra = prm{2}(chan,2);
    extra = ceil(extra/nExc);
    minCut = ceil(max([prm{2}(chan,3) prm{1}(1)+start-1])/nExc);

    
    cutOff = find(trace < thresh) + start - 1;
    if ~isempty(cutOff)
        cutOff2 = frames(cutOff) - extra;
        [r,o,o] = find(cutOff2 > minCut);
        if ~isempty(r) &&  cutOff2(r(1),1)<lastData
            cutOff = cutOff2(r(1),1);
        else
            cutOff = lastData;
        end
    else
        cutOff = lastData;
    end
    p.proj{proj}.prm{mol}{2}{1}(4+method) = cutOff*nExc;

end

if apply
    incl(start:cutOff,1) = true;
else
    incl(start:end) = true;
end

p.proj{proj}.bool_intensities(:,mol) = incl;


