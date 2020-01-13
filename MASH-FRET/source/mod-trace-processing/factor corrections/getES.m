function [ES,ok,str] = getES(p_proj,prm,fact,h_fig)

% collect FRET dimensions
FRET = p_proj.FRET;
nFRET = size(FRET,1);

% initialize results
ES = cell(1,nFRET);
ok = false;
str = [];

% build sample for analysis
m_incl = p_proj.coord_incl;
N = size(m_incl,2);
insubgroup = true(nFRET,N);
for i = 1:nFRET
    tag = prm(i,1)-1;
    if tag>0
        insubgroup(i,:) = m_incl & p_proj.molTag(:,tag)';
        if ~sum(insubgroup(i,:))
            str = cat(2,'ES histograms could not be built (no molecule in',...
                ' subgroup)');
            return
        end
    else
        insubgroup(i,:) = m_incl;
    end
end

% collect project data and parameters
I_den = p_proj.intensities_denoise;
m_incl = p_proj.coord_incl;
nC = p_proj.nb_channel;
exc = p_proj.excitations;
nExc = p_proj.nb_excitations;
chanExc = p_proj.chanExc;
l_incl = p_proj.bool_intensities;

% sample dimensions
N = size(m_incl,2);
L = size(I_den,1);
mols = 1:N;

% build FRET and stoichiometry traces
E_AD = [];
S_AD = [];
id_m = [];
if ~isempty(fact)
    gamma = repmat(fact(1,:),[L,1]);
    beta = repmat(fact(2,:),[L,1]);
else
    gamma = ones(L,nFRET);
    beta = ones(L,nFRET);
end

loading_bar('init',h_fig ,numel(mols(m_incl))+nFRET,...
    'Build ES histograms ...');
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

for m = mols(m_incl)
    E_AD = cat(1,E_AD,calcFRET(nC,nExc,exc,chanExc,FRET,...
        I_den(l_incl(:,m),((m-1)*nC+1):m*nC,:),gamma));
    S_AD = cat(1,S_AD,calcS(exc,chanExc,FRET,...
        I_den(l_incl(:,m),((m-1)*nC+1):m*nC,:),gamma,beta));
    id_m = cat(2,id_m,repmat(insubgroup(:,m),1,sum(l_incl(:,m))));
    
    err = loading_bar('update', h_fig);
    if err
        str = cat(2,'ES histograms could not be built because process ',...
            'was interrupted');
        return
    end
end

for i = 1:nFRET
    E = E_AD(~~id_m(i,:),:);
    S = S_AD(~~id_m(i,:),:);
    
    [ES{i},~,~,~] = hist2D([E(:),1./S(:)],[prm(i,2:4);prm(i,5:7)],'fast');
    
    err = loading_bar('update', h_fig);
    if err
        str = cat(2,'ES histograms could not be built because process ',...
            'was interrupted');
        return
    end
end

loading_bar('close', h_fig);

ok = true;

