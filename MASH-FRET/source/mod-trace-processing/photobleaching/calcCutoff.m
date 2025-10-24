function p = calcCutoff(mol, p)

% defaults
extra0 = 0; % old parameter prm{2}(chan,2)
mincut0 = 1; % old parameter prm{2}(chan,3)

proj = p.curr_proj;

nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
I0 = p.proj{proj}.intensities_bin(:,(mol-1)*nChan+1:mol*nChan,:);
prm = p.proj{proj}.TP.curr{mol}{2};
start = ceil(prm{1}(4)/nExc);
    
I_den = p.proj{proj}.intensities_denoise(:,((mol-1)*nChan+1):mol*nChan,:);
L = size(I_den,1);

method = prm{1}(2);
if method == 1
    cutOff0 = floor(prm{1}(4+method)/nExc);
    incl = true(L,1);
else
    trace = [];
    for c = 1:numel(chanExc)
        if chanExc(c)>0
            trace = cat(2,trace,sum(I_den(:,:,exc==chanExc(c)),2));
        end
    end
    minofft = prm{2}(:,2);
    thresh = prm{2}(:,1);
    cutev = prm{1}(3);
    [incl_em,cutOff] = calcCutoff_thresh(trace,minofft,start,thresh,...
        repmat(extra0,size(trace,1),1),repmat(mincut0,size(trace,1),1),mol);
    incl = all(incl_em,2);
    switch cutev
        case 1
            cutOff0 = min(cutOff);
        case 2
            cutOff0 = max(cutOff);
    end
end

lastN = find(all(~isnan(I0),[3,2]),1,'last');
if cutOff0>lastN
    fprintf(['Cutoff detection of mol %i: traces have missing data; ',...
        'cutoff set to latest valid data.\n'],mol);
    cutOff0 = lastN;
end

incl([1:(start-1),cutOff0+1:end],1) = false;
p.proj{proj}.TP.prm{mol}{2}{1}(4+method) = cutOff0*nExc;
p.proj{proj}.bool_intensities(:,mol) = incl;
c_tot = find(chanExc>0);
if method==2
    p.proj{proj}.TP.prm{mol}{2}{2}(:,3) = cutOff'*nExc;
    p.proj{proj}.emitter_is_on(:,nChan*(mol-1)+c_tot) = incl_em;
else
    p.proj{proj}.emitter_is_on(:,nChan*(mol-1)+c_tot) = ...
        repmat(incl,1,numel(c_tot));
end


