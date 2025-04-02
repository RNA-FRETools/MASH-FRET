function p = calcCutoff(mol, p)

proj = p.curr_proj;

nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
incl = true(size(p.proj{proj}.bool_intensities(:,mol)));
intensities = p.proj{proj}.intensities(:,(mol-1)*nChan+1:mol*nChan,:);
FRET = p.proj{proj}.FRET;
nFRET = size(p.proj{proj}.FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);
if nFRET>0
    gamma = p.proj{proj}.TP.curr{mol}{6}{1}(1,:);
    if nS>0
        beta = p.proj{proj}.TP.curr{mol}{6}{1}(2,:);
    end
end
prm = p.proj{proj}.TP.curr{mol}{2};
start = ceil(prm{1}(4)/nExc);
    
I_den = p.proj{proj}.intensities_denoise(:,((mol-1)*nChan+1):mol*nChan,:);
lastData = sum(double(~isnan(I_den(:,1,1))));

method = prm{1}(2);
if method == 1
    cutOff = floor(prm{1}(4+method)/nExc);
else
    chan = prm{1}(3);

    if chan <= nFRET % single FRET channel
        i_f = chan;
        fret = calcFRET(nChan, nExc, exc, chanExc, FRET, I_den, gamma);
        trace = fret(:,i_f);

    elseif chan <= (nFRET+nS) % single stoichiometry channel
        
        i_s = chan-nFRET;
        s = calcS(exc, chanExc, S, FRET, I_den, gamma, beta);
        trace = s(:,S(i_s));

    elseif chan <= (nFRET+nS+nExc*nChan) % single intensity channel
        i_exc = ceil((chan - nFRET - nS)/nChan);
        i_c = (chan - nFRET - nS)-(i_exc-1)*nChan;
        trace = I_den(:,i_c,i_exc);

    elseif chan == (nFRET+nS+nExc*nChan+1) % first emitter
        trace = [];
        for c = 1:nChan
            if chanExc(c)>0
                trace = cat(2,trace,sum(I_den(:,:,exc==chanExc(c)),2));
            end
        end

    else % all emitters
        trace = zeros(size(I_den,1),1);
        for c = 1:nChan
            if chanExc>0
                trace = trace + sum(I_den(:,:,exc==chanExc(c)),2);
            end
        end
    end
    
    nbFrames = numel(trace);
    
    trace = trace(start:end,:);
    trace = discrtrace4pbdetect(trace');
    if size(trace,1)>1
        trace = min(trace,[],1);
    end
    
    thresh = prm{2}(chan,1);
    extra = prm{2}(chan,2);
    extra = ceil(extra/nExc);
    minCut = ceil(max([prm{2}(chan,3) prm{1}(1)+nExc*start-1])/nExc);

    frames = (start:nbFrames)';
    incl(frames(trace<thresh)) = false;
    prc = cumsum(double(trace<thresh),'reverse')./(numel(trace):-1:1);

    % cutOff = find(trace>=thresh,1,'last')+start-1;
    cutOff = find(prc>=0.99,1,'first')+start-1;
    if ~isempty(cutOff)
        cutOff2 = cutOff-extra;
        if cutOff2>=minCut &&  cutOff2<lastData
            cutOff = cutOff2;
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
firstNan(firstNan>(lastData+1)) = lastData+1;

if cutOff>firstNan-1
    disp(cat(2,'intensity-time traces have missing data: cutoff set to ',...
        'last intensity data.'));
end
cutOff = min([firstNan-1,cutOff]);
cutOff(cutOff>lastData) = lastData;

incl([1:(start-1),cutOff+1:end],1) = false;
p.proj{proj}.TP.prm{mol}{2}{1}(4+method) = cutOff*nExc;
p.proj{proj}.bool_intensities(:,mol) = incl;


function trace = discrtrace4pbdetect(trace)
prm(1) = 1;
prm(2) = 5;
prm(3) = 5;
prm([7,6,5]) = [0,0,0];
prm = repmat(prm,size(trace,2),1);
trace = getDiscr(2,trace,~isnan(trace),prm,[],false,0,[]);


