function p = recalcStates(p)

proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;

incl = p.proj{proj}.bool_intensities(:,mol);
I_den = ...
    p.proj{proj}.intensities_denoise(incl,((mol-1)*nChan+1):mol*nChan,:);

if nFRET > 0
    FRET_tr = calcFRET(nChan, nExc, exc, chanExc, FRET, I_den);
end
for n = 1:nFRET
    discr = p.proj{proj}.FRET_DTA(incl,(mol-1)*nFRET+n);
    discr = aveStates(FRET_tr, discr);
    p.proj{proj}.FRET_DTA(incl,(mol-1)*nFRET+n) = discr;
    p.proj{proj}.FRET_DTA(~incl,(mol-1)*nFRET+n) = NaN;
    
    discrVal = (sort(unique(discr), 'descend'))';
    n_state = numel(discrVal);
    p.proj{proj}.TP.prm{mol}{4}{3}(n,1:n_state) = discrVal;
end

for n = 1:nS
    discr = p.proj{proj}.S_DTA(incl,(mol-1)*nS+n);
    [o,l_s,o] = find(exc==chanExc(S(n)));
    num = sum(I_den(:,:,l_s),2);
    den = sum(sum(I_den,2),3);
    S_tr = num ./ (num + den);
    discr = aveStates(S_tr, discr);
    p.proj{proj}.S_DTA(incl,(mol-1)*nS+n) = discr;
    p.proj{proj}.S_DTA(~incl,(mol-1)*nS+n) = NaN;
    
    discrVal = (sort(unique(discr), 'descend'))';
    n_state = numel(discrVal);
    p.proj{proj}.TP.prm{mol}{4}{3}(n+nFRET,1:n_state) = discrVal;
end

for l = 1:nExc
    for c = 1:nChan
        discr = p.proj{proj}.intensities_DTA(incl,(mol-1)*nChan+c,l);
        tr = I_den(:,c,l);
        discr = aveStates(tr, discr);
        p.proj{proj}.intensities_DTA(incl,(mol-1)*nChan+c,l) = discr;
        p.proj{proj}.intensities_DTA(~incl,(mol-1)*nChan+c,l) = NaN;
       
        discrVal = (sort(unique(discr), 'descend'))';
        n_state = numel(discrVal);
        p.proj{proj}.TP.prm{mol}{4}{3}( ...
            (nFRET+nS+(l-1)*nChan+c),1:n_state) = discrVal;
    end
end

h.param = p;
guidata(h_fig, h);


function tr_discr_recalc = aveStates(tr, tr_discr)
discrVal = unique(tr_discr');
tr_discr_recalc = nan(size(tr_discr));
for i = 1:size(discrVal,2)
    [f,o,o] = find(tr_discr(:,1) == discrVal(i));
    tr_discr_recalc(f',1) = mean(tr(f',1));
end

