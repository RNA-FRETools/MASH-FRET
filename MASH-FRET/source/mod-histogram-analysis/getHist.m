function [Ptbl,L] = getHist(m,w,ovrfl,h_fig)

h = guidata(h_fig);
p = h.param.thm;
proj = p.curr_proj;
tpe = p.curr_tpe(proj);
tag = p.curr_tag(proj);

allExc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;

nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
em0 = find(chanExc~=0);
nDE = numel(em0);
I = p.proj{proj}.intensities_denoise;
I_discr = p.proj{proj}.intensities_DTA;
FRET = p.proj{proj}.FRET;
FRET_discr = p.proj{proj}.FRET_DTA;
S = p.proj{proj}.S;
S_discr = p.proj{proj}.S_DTA;
nFRET = size(FRET,1);
nS = size(p.proj{proj}.S,1);
N = size(I,2)/nChan;
m_incl = p.proj{proj}.coord_incl;
incl = p.proj{proj}.bool_intensities;
L = size(I,1);

if numel(m)>1 && strcmp(m, 'all')
    m = 1:N;
    if tag==1
        m = m(m_incl);
    else
        m = m(m_incl & p.proj{proj}.molTag(:,tag-1)');
    end
end

if isempty(m)
    Ptbl = [];
    L = 0;
    return
end

prm = p.proj{proj}.prm{tag,tpe};

if tpe <= nChan*nExc % intensity
    i_c = mod(tpe,nChan); i_c(i_c==0) = nChan;
    i_l = ceil(tpe/nChan);
    trace = I(:,i_c:nChan:end,i_l);
    
elseif tpe <= 2*nChan*nExc % intensity
    i_c = mod(tpe-nChan*nExc,nChan); i_c(i_c==0) = nChan;
    i_l = ceil((tpe-nChan*nExc)/nChan);
    trace = I_discr(:,i_c:nChan:end,i_l);
            
elseif tpe <= (2*nChan*nExc + nDE) % total intensity
    id = tpe-2*nChan*nExc;
    trace = [];
    l0 = allExc==chanExc(em0(id));
    for n = 1:N
        trace = cat(2,trace,sum(I(:,((n-1)*nChan+1):(n*nChan),l0),2));
    end

elseif tpe <= (2*nChan*nExc + 2*nDE) % total discr. intensity
    id = tpe-2*nChan*nExc - nDE;
    trace = [];
    l0 = allExc==chanExc(em0(id));
    for n = 1:N
        trace = cat(2,trace,...
            sum(I_discr(:,((n-1)*nChan+1):(n*nChan),l0),2));
    end

elseif tpe <= (2*nChan*nExc + 2*nDE + nFRET) % FRET
    I_re = nan(L*N,nChan,nExc);
    for c = 1:nChan
        I_re(:,c,:) = reshape(I(:,c:nChan:end,:), [N*L 1 nExc]);
    end
    i_f = tpe - 2*nChan*nExc - 2*nDE;
    gammas = [];
    for i_m = 1:N
        if size(p.proj{proj}.prmTT{i_m},2)==5 && ...
                size(p.proj{proj}.prmTT{i_m}{5},2)==5
            gamma_m = p.proj{proj}.prmTT{i_m}{5}{3};
        elseif size(p.proj{proj}.prmTT{i_m},2)==6 && ...
                size(p.proj{proj}.prmTT{i_m}{6},2)>=1 && ...
                size(p.proj{proj}.prmTT{i_m}{6}{1},2)==nFRET
            gamma_m = p.proj{proj}.prmTT{i_m}{6}{1}(1,:);
        else
            gamma_m = ones(1,nFRET);
        end
        gammas = [gammas; repmat(gamma_m,L,1)];
    end
    allFRET = calcFRET(nChan, nExc, allExc, chanExc, FRET, I_re, gammas);
    trace = allFRET(:,i_f);
    trace = reshape(trace, [L N]);
    
elseif tpe <= (2*nChan*nExc + 2*nDE + 2*nFRET) % FRET
    i_f = tpe - 2*nChan*nExc - 2*nDE - nFRET;
    trace = FRET_discr(:,i_f:nFRET:end);

elseif tpe <= (2*nChan*nExc + 2*nDE + 2*nFRET + nS) % Stoichiometry
    I_re = nan(L*N,nChan,nExc);
    for c = 1:nChan
        I_re(:,c,:) = reshape(I(:,c:nChan:end,:), [N*L 1 nExc]);
    end
    i_s = tpe - 2*nChan*nExc - 2*nDE - 2*nFRET;
    gammas = [];
    betas = [];
    for i_m = 1:N
        if size(p.proj{proj}.prmTT{i_m},2)==5 && ...
                size(p.proj{proj}.prmTT{i_m}{5},2)==5
            gamma_m = p.proj{proj}.prmTT{i_m}{5}{3};
            beta_m = ones(1,nFRET);
        elseif size(p.proj{proj}.prmTT{i_m},2)==6 && ...
                size(p.proj{proj}.prmTT{i_m}{6},2)>=1 && ...
                size(p.proj{proj}.prmTT{i_m}{6}{1},2)==nFRET
            gamma_m = p.proj{proj}.prmTT{i_m}{6}{1}(1,:);
            beta_m = p.proj{proj}.prmTT{i_m}{6}{1}(2,:);
        else
            gamma_m = ones(1,nFRET);
            beta_m = ones(1,nFRET);
        end
        gammas = [gammas; repmat(gamma_m,L,1)];
        betas = [betas; repmat(beta_m,L,1)];
    end
    allS = calcS(allExc, chanExc, S, FRET, I_re, gammas, betas);
    trace = allS(:,i_s);
    trace = reshape(trace, [L N]);
    
elseif tpe <= (2*nChan*nExc + 2*nDE + 2*nFRET + 2*nS) % S
    i_s = tpe - 2*nChan*nExc - 2*nDE - 2*nFRET - nS;
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

L = 0;
if w
    for n = 1:numel(m)
        L = L + numel(trace(incl(:,m(n))',n));
        Pn(n,:) = hist(trace(incl(:,m(n))',n) ,x_axis);
        Pn(n,:) = Pn(n,:)/sum(Pn(n,:));
    end
    if ~ovrfl
        Pn(:,[1 end]) = [];
        x_axis([1 end]) = [];
    end
    P = sum(Pn,1);
    P = P/sum(P);
else
    P = 0;
    for n = 1:numel(m)
        L = L + numel(trace(incl(:,m(n))',n));
        P = P + hist(trace(incl(:,m(n))',n) ,x_axis);
    end
    if ~ovrfl
        P([1 end]) = [];
        x_axis([1 end]) = [];
    end
end

cumP = cumsum(P);

Ptbl = [x_axis' P' cumP'];


