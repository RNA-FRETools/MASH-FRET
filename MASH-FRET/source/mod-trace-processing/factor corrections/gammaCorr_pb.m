function [I_DTA,stop,gamma,ok,str] = gammaCorr_pb(i,I_den,prm,prm_dta,...
    p_proj,h_fig)

% collect project parameters
FRET = p_proj.FRET;
nFRET = size(FRET,1);
nS =  size(p_proj.S,1);
nExc = p_proj.nb_excitations;
nC = p_proj.nb_channel;
chanExc = p_proj.chanExc;
exc = p_proj.excitations;

% collect DTA parameters
method_dta = prm_dta{1}(1);
calc = prm_dta{1}(3);
thresh = prm_dta{4}(:,:,nFRET+nS+1:end);
prm_dta = permute(prm_dta{2}(method_dta,:,nFRET+nS+1:end),[3,2,1]);

% collect donor and acceptor intensity traces
don = FRET(i,1);
acc = FRET(i,2);
ldon = find(exc==chanExc(don),1);
I_AA = I_den(:,acc,prm(1));

% calculate and save cutoff on acceptor trace
stop = calcCutoffGamma(prm(2:end),I_AA,nExc);

% discretize donor and acceptor traces
id_don = nC*(ldon-1)+don;
id_acc = nC*(ldon-1)+acc;
I_DTA = getDiscr(method_dta, I_den(:,[don,acc],ldon)', [], ...
    prm_dta([id_don,id_acc],:), thresh(:,:,[id_don,id_acc]), calc, ...
    'Discretization for gamma factor calculation ...', h_fig)';

% calculate gamma
[gamma,ok,str] = prepostInt(stop, I_DTA(:,1), I_DTA(:,2), ...
    round(prm(6)/nExc));

