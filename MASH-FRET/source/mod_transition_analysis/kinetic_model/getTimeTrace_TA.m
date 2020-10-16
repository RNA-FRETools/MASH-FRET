function trace = getTimeTrace_TA(tpe,tag,p_proj)
% trace = getTimeTrace_TA(tpe,tag,p_proj)
%
% Get cumulated time trace from data type and moelcule tag used in TA
%
% tpe: index in list of data type
% tag: index in list of molecule tag
% p_proj: stucture containing project data

nChan = p_proj.nb_channel;
nExc = p_proj.nb_excitations;
chanExc = p_proj.chanExc;
allExc = p_proj.excitations;
FRET = p_proj.FRET;
S = p_proj.S;
m_incl = p_proj.coord_incl;
m_tag = p_proj.molTag(:,tag)';
nFRET = size(FRET,1);
nS = size(S,1);
I = p_proj.intensities;
L = size(I,1);
N = size(I,2)/nChan;

if tpe <= nChan*nExc % intensity
    i_c = mod(tpe,nChan); i_c(i_c==0) = nChan;
    i_l = ceil(tpe/nChan);
    trace = I(:,i_c:nChan:end,i_l);

elseif tpe <= (nChan*nExc+nFRET) % FRET
    I_re = nan(L*N,nChan,nExc);
    for c = 1:nChan
        I_re(:,c,:) = reshape(I(:,c:nChan:end,:), ...
            [N*L 1 nExc]);
    end
    i_f = tpe-nChan*nExc;

    gammas = [];
    for i_m = 1:N
        if size(p_proj.prmTT{i_m},2)==5 && size(p_proj.prmTT{i_m}{5},2)==5
            gamma_m = p_proj.prmTT{i_m}{5}{3};
        elseif size(p_proj.prmTT{i_m},2)==6 && ...
                size(p_proj.prmTT{i_m}{6},2)>=1 && ...
                size(p_proj.prmTT{i_m}{6}{1},2)==nFRET
            gamma_m = p_proj.prmTT{i_m}{6}{1}(1,:);
        else
            gamma_m = ones(1,nFRET);
        end
        gammas = [gammas; repmat(gamma_m,L,1)];
    end
    allFRET = calcFRET(nChan, nExc, allExc, chanExc, FRET, I_re, gammas);
    trace = allFRET(:,i_f);
    trace = reshape(trace, [L N]);

elseif tpe <= (nChan*nExc+nFRET+nS) % Stoichiometry
    I_re = nan(L*N,nChan,nExc);
    for c = 1:nChan
        I_re(:,c,:) = reshape(I(:,c:nChan:end,:),[N*L 1 nExc]);
    end
    i_s = tpe-nChan*nExc-nFRET;

    gammas = [];
    betas = [];
    for i_m = 1:N
        if size(p_proj.prmTT{i_m},2)==5 && size(p_proj.prmTT{i_m}{5},2)==5
            gamma_m = p_proj.prmTT{i_m}{5}{3};
            beta_m = ones(1,nFRET);
        elseif size(p_proj.prmTT{i_m},2)==6 && ...
                size(p_proj.prmTT{i_m}{6},2)>=1 && ...
                size(p_proj.prmTT{i_m}{6}{1},2)==nFRET
            gamma_m = p_proj.prmTT{i_m}{6}{1}(1,:);
            beta_m = p_proj.prmTT{i_m}{6}{1}(2,:);
        else
            gamma_m = ones(1,nFRET);
            beta_m = ones(1,nFRET);
        end
        gammas = [gammas; repmat(gamma_m,L,1)];
        betas = [betas; repmat(beta_m,L,1)];
    end
    allS = calcS(allExc,chanExc,S,FRET,I_re,gammas,betas);
    trace = allS(:,i_s);
    trace = reshape(trace, [L N]);
end

trace = trace(:,m_incl & m_tag);
