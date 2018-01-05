function [Ptbl N] = getHist(m, w, ovrfl, h_fig)

h = guidata(h_fig);
p = h.param.thm;
proj = p.curr_proj;
tpe = p.curr_tpe(proj);

allExc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;

nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
I = p.proj{proj}.intensities_denoise;
I(isnan(I)) = p.proj{proj}.intensities(isnan(I));
I_discr = p.proj{proj}.intensities_DTA;
FRET = p.proj{proj}.FRET;
FRET_discr = p.proj{proj}.FRET_DTA;
S = p.proj{proj}.S;
S_discr = p.proj{proj}.S_DTA;
nFRET = size(FRET,1);
nS = size(p.proj{proj}.S,1);
nMol = size(I,2)/nChan;
m_incl = p.proj{proj}.coord_incl;
incl = p.proj{proj}.bool_intensities;
N = size(I,1);

if numel(m)>1 && strcmp(m, 'all')
    m = 1:nMol;
    m = m(m_incl);
end

prm = p.proj{proj}.prm{tpe};

if tpe <= nChan*nExc % intensity
    i_c = mod(tpe,nChan); i_c(i_c==0) = nChan;
    i_l = ceil(tpe/nChan);
    trace = I(:,i_c:nChan:end,i_l);
    
elseif tpe <= 2*nChan*nExc % intensity
    i_c = mod(tpe-nChan*nExc,nChan); i_c(i_c==0) = nChan;
    i_l = ceil((tpe-nChan*nExc)/nChan);
    trace = I_discr(:,i_c:nChan:end,i_l);

elseif tpe <= 2*nChan*nExc + nFRET % FRET
    I_re = nan(N*nMol,nChan,nExc);
    for c = 1:nChan
        I_re(:,c,:) = reshape(I(:,c:nChan:end,:), [nMol*N 1 nExc]);
    end
    i_f = tpe - 2*nChan*nExc;
    gamma = [];
    for i_m = 1:nMol
        gamma = [gamma; repmat(p.proj{proj}.prmTT{i_m}{5}{3},N,1)];
    end
    allFRET = calcFRET(nChan, nExc, allExc, chanExc, FRET, I_re, gamma);
    trace = allFRET(:,i_f);
    trace = reshape(trace, [N nMol]);
    
elseif tpe <= 2*nChan*nExc+2*nFRET % FRET
    i_f = tpe - 2*nChan*nExc - nFRET;
    trace = FRET_discr(:,i_f:nFRET:end);

elseif tpe <= 2*nChan*nExc + 2*nFRET + nS % Stoichiometry
    i_s = tpe - 2*nChan*nExc - 2*nFRET;
    i_c = S(i_s);
    [o,i_l,o] = find(allExc==chanExc(i_c));
    I_re = nan(N*nMol,nChan,nExc);
    for c = 1:nChan
        I_re(:,c,:) = reshape(I(:,c:nChan:end,:), [nMol*N 1 nExc]);
    end
    trace = sum(I_re(:,:,i_l),2)./sum(sum(I_re,2),3);
    trace = reshape(trace, [N nMol]);
    
elseif tpe <= 2*nChan*nExc + 2*nFRET + 2*nS % FRET
    i_s = tpe - 2*nChan*nExc - 2*nFRET - nS;
    trace = S_discr(:,i_s:nS:end);
end

trace = trace(:,m);

x_bin = prm.plot{1}(1,1);
x_lim = prm.plot{1}(1,2:3);
x_axis = x_lim(1):x_bin:x_lim(2);

if numel(x_axis)<2
    Ptbl = [0 0 0];
    return;
end

N = 0;
if w
    for n = 1:numel(m)
        N = N + numel(trace(incl(:,m(n))',n));
        Pn(n,:) = hist(trace(incl(:,m(n))',n) ,x_axis);
        Pn(n,:) = Pn(n,:)/sum(Pn(n,:));
    end
    P = sum(Pn,1);
    P = P/sum(P);
else
    P = 0;
    for n = 1:numel(m)
        N = N + numel(trace(incl(:,m(n))',n));
        P = P + hist(trace(incl(:,m(n))',n) ,x_axis);
    end
end

cumP = cumsum(P);

Ptbl = [x_axis' P' cumP'];

if ~ovrfl
    Ptbl([1 end],:) = [];
end


