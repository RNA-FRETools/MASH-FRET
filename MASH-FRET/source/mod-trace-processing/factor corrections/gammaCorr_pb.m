function [I_DTA,I_DA,stop,gamma,ok,str] = gammaCorr_pb(i,I_den,prm,prm_dta,...
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

% collect donor and acceptor intensity traces
don = FRET(i,1);
acc = FRET(i,2);
ldon = find(exc==chanExc(don),1);

% calculate and save cutoff on acceptor trace
stop = calcCutoffGamma(prm(2:end),I_den(:,acc,prm(1)),nExc);

% discretize donor and acceptor traces
is2D = method_dta==3;
id_don = nC*(ldon-1)+don;
id_acc = nC*(ldon-1)+acc;
I_DA = I_den(:,[don,acc],ldon)';

if is2D 
    I_tr = {[I_den(:,don,ldon)';I_den(:,acc,ldon)']};
    for chan = 1:size(I_tr{1},1)
        I_tr{1}(chan,:) = (I_tr{1}(chan,:)-mean(I_tr{1}(chan,:)))/...
            std(I_tr{1}(chan,:));
    end
    prm_dta = permute(prm_dta{2}(method_dta,:,i),[3,2,1]);
    thresh_dta = [];
else
    thresh = prm_dta{4}(:,:,nFRET+nS+1:end);
    thresh_dta = thresh(:,:,[id_don,id_acc]);
    
    I_tr = I_den(:,[don,acc],ldon)';
    prm_dta = permute(prm_dta{2}(method_dta,:,nFRET+nS+1:end),[3,2,1]);
    prm_dta = prm_dta([id_don,id_acc],:);
end

discr = getDiscr(method_dta, I_tr, [], prm_dta, thresh_dta, calc, ...
    'Discretization for gamma factor calculation ...', h_fig)';

if is2D
    I_DTA = zeros(size(discr{1},2),2);
    stateVals = unique(discr{1}(1,:));
    for val = stateVals
        frames = discr{1}(1,:)==val;
        I_DTA(frames,1) = mean(I_den(frames,don,ldon));
        I_DTA(frames,2) = mean(I_den(frames,acc,ldon));
    end

else
    I_DTA = discr;
end

% calculate gamma
[gamma,ok,str] = prepostInt(stop, I_DTA(:,1), I_DTA(:,2), ...
    round(prm(6)/nExc));

