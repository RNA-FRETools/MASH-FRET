function [I_DTA,stop,gamma,ok,str] = gammaCorr_pb(pair,I_den,m,prm,...
    prm_dta,p_proj,h_fig)

% collect project parameters
FRET = p_proj.FRET;
nFRET = size(FRET,1);
nS =  size(p_proj.S,1);
nExc = p_proj.nb_excitations;
nC = p_proj.nb_channel;
chanExc = p_proj.chanExc;
exc = p_proj.excitations;
incl = p_proj.bool_intensities(:,m);
isfretimp = isfield(p_proj,'FRET_DTA_import') & ...
    ~isempty(p_proj.FRET_DTA_import);

% collect DTA parameters
method_dta = prm_dta{1}(1);
calc = prm_dta{1}(3);

% collect donor and acceptor intensity traces
don = FRET(pair,1);
acc = FRET(pair,2);
ldon = find(exc==chanExc(don),1);
I_AA = I_den(:,acc,prm(1));

% calculate and save cutoff on acceptor trace
stop = calcCutoffGamma(prm(2:end),I_AA,nExc);

% discretize donor and acceptor traces
is2D = method_dta==3;
id_don = nC*(ldon-1)+don;
id_acc = nC*(ldon-1)+acc;

nF = size(FRET,1);
if isfretimp
    splt0 = p_proj.sampling_time*nExc;
    splt = p_proj.resampling_time*nExc;
    fret_DTA_imp = resample(...
        p_proj.FRET_DTA_import(:,(m-1)*nF+pair),splt,splt0)';
else
    fret_DTA_imp = NaN(size(p_proj.FRET_DTA((m-1)*nF+pair)))';
end

actstr = 'Discretization for gamma factor calculation ...';

if method_dta==8 % imported FRET discr 
    
    % calculates FRET-time traces
    f_tr = [];
    if nF > 0
        f_tr = calcFRET([],[],exc,chanExc,FRET(pair,:),I_den,1);
        f_tr = f_tr';
    end
    prm_dta = permute(prm_dta{2}(method_dta,:,pair),[3,2,1]);
    fret_DTA = (getDiscr(method_dta,cat(3,f_tr,fret_DTA_imp(:,incl)),...
        true(1,sum(incl)),prm_dta,[],calc,actstr,h_fig))';

    I_tr = I_den(:,[don,acc],ldon)';
    I_DTA = cat(2,trajkernel(I_tr(1,:)',true(1,size(fret_DTA,1)),...
        fret_DTA(:,pair)'),trajkernel(I_tr(2,:)',...
        true(1,size(fret_DTA,1)),fret_DTA(:,pair)'));

else
    if is2D 
        I_tr = {[I_den(:,don,ldon)';I_den(:,acc,ldon)']};
        for chan = 1:size(I_tr{1},1)
            I_tr{1}(chan,:) = (I_tr{1}(chan,:)-mean(I_tr{1}(chan,:)))/...
                std(I_tr{1}(chan,:));
        end
        prm_dta = permute(prm_dta{2}(method_dta,:,pair),[3,2,1]);
        thresh_dta = [];
    else
        thresh = prm_dta{4}(:,:,nFRET+nS+1:end);
        thresh_dta = thresh(:,:,[id_don,id_acc]);
        
        I_tr = I_den(:,[don,acc],ldon)';
        prm_dta = permute(prm_dta{2}(method_dta,:,nFRET+nS+1:end),[3,2,1]);
        prm_dta = prm_dta([id_don,id_acc],:);
    end

    discr = getDiscr(method_dta, I_tr, [], prm_dta, thresh_dta, calc, ...
        actstr, h_fig)';

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
end

% calculate gamma
[gamma,ok,str] = prepostInt(stop, I_DTA(:,1), I_DTA(:,2), ...
    round(prm(6)/nExc));

