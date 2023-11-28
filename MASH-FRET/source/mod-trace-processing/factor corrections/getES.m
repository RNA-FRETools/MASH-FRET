function [ES,ok,str] = getES(pair,p_proj,prm,fact,h_fig)

% collect FRET dimensions
FRET = p_proj.FRET;
S = p_proj.S;
nF = size(FRET,1);

% initialize results
ES = [];
ok = false;
str = [];

% build sample for analysis
m_i = p_proj.coord_incl;
N = size(m_i,2);
insubgroup = true(nF,N);

s = find(S(:,1)==FRET(pair,1) & S(:,2)==FRET(pair,2),1);
if isempty(s)
    insubgroup(pair,:) = false;
else
    tag = prm(pair,1)-1;
    if tag>0
        insubgroup(pair,:) = m_i & p_proj.molTag(:,tag)';
        if ~sum(insubgroup(pair,:))
            str = cat(2,'ES histograms could not be built (no molecule in',...
                ' subgroup)');
            return
        end
    else
        insubgroup(pair,:) = m_i;
    end
end

% collect project data and parameters
I_den = p_proj.intensities_denoise;
nC = p_proj.nb_channel;
exc = p_proj.excitations;
nExc = p_proj.nb_excitations;
chanExc = p_proj.chanExc;
incl = p_proj.bool_intensities;

% build FRET and stoichiometry traces
if ~isempty(fact)
    gamma = fact(1,:);
    beta = fact(2,:);
else
    gamma = ones(1,nF);
    beta = ones(1,nF);
end

Icat = [];
incl = reshape(incl(:,insubgroup(pair,:)),[],1);
for c = 1:nC
    Ic = I_den(:,c:nC:end,:);
    Ic = reshape(Ic(:,insubgroup(pair,:),:),[],1,nExc);
    Icat = cat(2,Icat,Ic(incl,1,:));
end
E_AD = calcFRET(nC,nExc,exc,chanExc,FRET,Icat,gamma);
S_AD = calcS(exc,chanExc,S,FRET,Icat,gamma,beta);

s = find(S(:,1)==FRET(pair,1) & S(:,2)==FRET(pair,2));
if isempty(s)
    ES = NaN;
else
    E = E_AD(:,pair);
    St = S_AD(:,s);
    
    ivE = linspace(prm(pair,2),prm(pair,3),prm(pair,4));
    ivS = linspace(prm(pair,5),prm(pair,6),prm(pair,7));
    [ES,~,~] = histcounts2(1./St(:),E(:),ivS,ivE);
end

ok = true;

