function p = calcCutoff(mol, p)

% Last update: by MH, 17.5.2019
% >> For now on, "summed intensities" and "all intensities" concern only
%    intensities collected at emitter-specific excitations because zero-
%    signals collected at unspecific illuminations are constantly 
%    "photobleached" and make the method unsuable
% >> "all intensities" uses intensities summed over all channels; this
%    allows to detect true photobleaching and not 0 FRET
%
% update: by MH, 3.4.2019
% >> manage missing intensities when loading ASCII traces with different 
%    lengths: cut-off frame is automatically set to last number in trace
%    and saved no matter if photobleaching correction is applied or not

proj = p.curr_proj;

nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
incl = false(size(p.proj{proj}.bool_intensities(:,mol)));
intensities = p.proj{proj}.intensities(:,(mol-1)*nChan+1:mol*nChan,:);
FRET = p.proj{proj}.FRET;
nFRET = size(p.proj{proj}.FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);
gamma = p.proj{proj}.prm{mol}{5}{3};
prm = p.proj{proj}.prm{mol}{2};

apply = prm{1}(1);
start = ceil(prm{1}(4)/nExc);

method = prm{1}(2);
if method == 1
    cutOff = floor(prm{1}(4+method)/nExc);
else
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
        S_chan = S(i_s,:);
        [o,l_s,o] = find(exc==chanExc(S_chan));
        trace = sum(I_den(:,:,S_chan(1)),2)./sum(sum(I_den(:,:,:),2),3);

    elseif chan <= (nFRET+nS+nExc*nChan) % single intensity channel
        i_exc = ceil((chan - nFRET - nS)/nChan);
        i_c = (chan - nFRET - nS)-(i_exc-1)*nChan;
        trace = I_den(:,i_c,i_exc);

    % modified by MH, 17.5.2019
%     elseif chan == (nFRET+nS+nExc*nChan+1) % all intensities
%         trace = min(min(I_den, [], 3), [], 2);
% 
%     else % summed intensities
%         trace = sum(sum(I_den,3),2);
%     end
    elseif chan == (nFRET+nS+nExc*nChan+1) % all intensities
        trace = Inf(size(I_den,1),1);
        for c = 1:nChan
            if chanExc(c)>0
                trace = min([trace,sum(I_den(:,:,exc==chanExc(c)),2)],[],...
                    2);
            end
        end
    else % summed intensities
        trace = zeros(size(I_den,1),1);
        for c = 1:nChan
            if chanExc>0
                trace = trace + sum(I_den(:,:,exc==chanExc(c)),2);
            end
        end
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

end

firstNan = find(isnan(sum(sum(intensities,3),2)),1);
if isempty(firstNan)
    firstNan = size(intensities,1)+1;
else
    firstNan = firstNan(1);
    if firstNan==1
        firstNan = 2;
    end
end

if cutOff>firstNan-1
    disp(cat(2,'intensity-time traces have missing data: cutoff set to ',...
        'last intensity data.'));
end
cutOff = min([firstNan-1,cutOff]);

if apply
    incl(start:cutOff,1) = true;
else
    incl(start:firstNan-1) = true;
end

p.proj{proj}.prm{mol}{2}{1}(4+method) = cutOff*nExc;
p.proj{proj}.bool_intensities(:,mol) = incl;


