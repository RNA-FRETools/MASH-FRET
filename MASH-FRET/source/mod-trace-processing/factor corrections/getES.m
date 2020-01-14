function [ES,ok,str] = getES(p_proj,prm,fact,h_fig)

% collect FRET dimensions
FRET = p_proj.FRET;
S = p_proj.S;
nF = size(FRET,1);

% initialize results
ES = cell(1,nF);
ok = false;
str = [];

% build sample for analysis
m_i = p_proj.coord_incl;
N = size(m_i,2);
insubgroup = true(nF,N);
for i = 1:nF
    tag = prm(i,1)-1;
    if tag>0
        insubgroup(i,:) = m_i & p_proj.molTag(:,tag)';
        if ~sum(insubgroup(i,:))
            str = cat(2,'ES histograms could not be built (no molecule in',...
                ' subgroup)');
            return
        end
    else
        insubgroup(i,:) = m_i;
    end
end

% collect project data and parameters
I_den = p_proj.intensities_denoise;
nC = p_proj.nb_channel;
exc = p_proj.excitations;
nExc = p_proj.nb_excitations;
chanExc = p_proj.chanExc;
l_i = p_proj.bool_intensities;

% sample dimensions
N = size(m_i,2);
L = size(I_den,1);
mls = 1:N;

% build FRET and stoichiometry traces
E_AD = [];
S_AD = [];
id_m = [];
if ~isempty(fact)
    gamma = repmat(fact(1,:),[L,1]);
    beta = repmat(fact(2,:),[L,1]);
else
    gamma = ones(L,nF);
    beta = ones(L,nF);
end

lb = 0;
h = guidata(h_fig);
if ~isfield(h, 'barData')
    loading_bar('init',h_fig,numel(mls(m_i))+nF,'Build ES histograms ...');
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    lb = 1;
end

for m = mls(m_i)
    E_AD = cat(1,E_AD,calcFRET(nC,nExc,exc,chanExc,FRET,...
        I_den(l_i(:,m),((m-1)*nC+1):m*nC,:),gamma(l_i(:,m),1)));
    S_AD = cat(1,S_AD,calcS(exc,chanExc,S,FRET,...
        I_den(l_i(:,m),((m-1)*nC+1):m*nC,:),gamma(l_i(:,m),1),...
        beta(l_i(:,m),1)));
    id_m = cat(2,id_m,repmat(insubgroup(:,m),1,sum(l_i(:,m))));
    
    if lb
        err = loading_bar('update', h_fig);
        if err
            str = 'ES histograms could not be built (process interruption)';
            return
        end
    end
end

for i = 1:nF
    s = find(S(:,1)==FRET(i,1) & S(:,2)==FRET(i,2));
    if isempty(s)
        ES{i} = NaN;
        continue
    end
    
    E = E_AD(~~id_m(i,:),i);
    St = S_AD(~~id_m(i,:),s);
    
    [ES{i},~,~,~] = hist2D([E(:),1./St(:)],[prm(i,2:4);prm(i,5:7)],'fast');
    
    if lb
        err = loading_bar('update', h_fig);
        if err
            str = 'ES histograms could not be built (process interruption)';
            return
        end
    end
end

if lb
    loading_bar('close', h_fig);
end

ok = true;

