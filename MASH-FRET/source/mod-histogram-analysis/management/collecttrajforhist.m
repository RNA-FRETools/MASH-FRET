function [traj,isratio] = collecttrajforhist(proj,tpe,tag)
% [traj,isratio] = collecttrajforhist(tpe,tag)
%
% Collect/calculate trajectories of specified data type and for specified 
% moelcule subgroup, dedicated to histogram calculation.
%
% tpe: data type index
% tag: moelcule subgroup index (1 = all molecules)
% traj: [L-by-N] trajectories
% isratio: true if data is intensity ratio, false otherwise


% default
isratio = false;
traj = [];

% collect project's data
nChan = proj.nb_channel;
nExc = proj.nb_excitations;
allExc = proj.excitations;
chanExc = proj.chanExc;
nFRET = size(proj.FRET,1);
nS = size(proj.S,1);
I = proj.intensities;
I_den = proj.intensities_denoise;
I_discr = proj.intensities_DTA;
m_incl = proj.coord_incl;
FRET = proj.FRET;
FRET_discr = proj.FRET_DTA;
S = proj.S;
S_discr = proj.S_DTA;
L = size(I_den,1);
N = size(I_den,2)/nChan;

% select molecules
if tag==1
    m_tag = m_incl;
else
    m_tag = m_incl & proj.molTag(:,tag-1)';
end

% calculates number of total intensities
em0 = find(chanExc~=0);
inclem = true(1,numel(em0));
for em = 1:numel(em0)
    if ~sum(chanExc(em)==allExc)
        inclem(em) = false;
    end
end
em0 = em0(inclem);
nDE = numel(em0);

% calculate data trajectory
if tpe<=nChan*nExc % intensity
    i_c = mod(tpe,nChan); 
    i_c(i_c==0) = nChan;
    i_l = ceil(tpe/nChan);
    if sum(all(isnan(I_den(:,i_c:nChan:end,i_l))))
        traj = I(:,i_c:nChan:end,i_l);
    else
        traj = I_den(:,i_c:nChan:end,i_l);
    end

elseif tpe<=2*nChan*nExc % discr. intensity
    i_c = mod(tpe-nChan*nExc,nChan); i_c(i_c==0) = nChan;
    i_l = ceil((tpe-nChan*nExc)/nChan);
    if sum(all(isnan(I_discr(:,i_c:nChan:end,i_l))))
        traj = I(:,i_c:nChan:end,i_l);
    else
        traj = I_discr(:,i_c:nChan:end,i_l);
    end

elseif tpe<=(2*nChan*nExc + nDE) % total intensity
    id = tpe-2*nChan*nExc;
    traj = [];
    l0 = allExc==chanExc(em0(id));
    for n = 1:N
        I_n = sum(I_den(:,((n-1)*nChan+1):(n*nChan),l0),2);
        if all(isnan(I_n))
            traj = catwithdimextension(2,traj,...
                sum(I(:,((n-1)*nChan+1):(n*nChan),l0),2));
        else
            traj = catwithdimextension(2,traj,I_n);
        end
    end

elseif tpe<=(2*nChan*nExc + 2*nDE) % total discr. intensity
    id = tpe-2*nChan*nExc - nDE;
    traj = [];
    l0 = allExc==chanExc(em0(id));
    for n = 1:N
        I_n = sum(I_discr(:,((n-1)*nChan+1):(n*nChan),l0),2);
        if all(isnan(I_n))
            traj = catwithdimextension(2,traj,...
                sum(I(:,((n-1)*nChan+1):(n*nChan),l0),2));
        else
            traj = catwithdimextension(2,traj,I_n);
        end
    end

elseif tpe<=(2*nChan*nExc + 2*nDE + nFRET) % FRET
    I_re = nan(L*N,nChan,nExc);
    for c = 1:nChan
        I_re(:,c,:) = reshape(I_den(:,c:nChan:end,:), ...
            [N*L 1 nExc]);
    end
    i_f = tpe - 2*nChan*nExc - 2*nDE;

    gammas = [];
    for i_m = 1:N
        if size(proj.TP.prm{i_m},2)==5 && ...
                size(proj.TP.prm{i_m}{5},2)==5
            gamma_m = proj.TP.prm{i_m}{5}{3};
        elseif size(proj.TP.prm{i_m},2)==6 && ...
                size(proj.TP.prm{i_m}{6},2)>=1 && ...
                size(proj.TP.prm{i_m}{6}{1},2)==nFRET
            gamma_m = proj.TP.prm{i_m}{6}{1}(1,:);
        else
            gamma_m = ones(1,nFRET);
        end
        gammas = cat(1,gammas,repmat(gamma_m,L,1));
    end
    allFRET = calcFRET(nChan, nExc, allExc, chanExc, FRET, ...
        I_re, gammas);
    traj = allFRET(:,i_f);
    traj = reshape(traj, [L N]);

    % current data is an intensity ratio
    isratio = true;

elseif tpe<=(2*nChan*nExc+2*nDE+2*nFRET) % FRET
    i_f = tpe-2*nChan*nExc-2*nDE-nFRET;
    traj = FRET_discr(:,i_f:nFRET:end);

    % current data is an intensity ratio
    isratio = true;

elseif tpe<=(2*nChan*nExc + 2*nDE + 2*nFRET+nS) % Stoichiometry
    I_re = nan(L*N,nChan,nExc);
    for c = 1:nChan
        I_re(:,c,:) = reshape(I_den(:,c:nChan:end,:), ...
            [N*L 1 nExc]);
    end
    i_s = tpe - 2*nChan*nExc - 2*nDE - 2*nFRET;

    gammas = [];
    betas = [];
    for i_m = 1:N
        if size(proj.TP.prm{i_m},2)==5 && ...
                size(proj.TP.prm{i_m}{5},2)==5
            gamma_m = proj.TP.prm{i_m}{5}{3};
            beta_m = ones(1,nFRET);
        elseif size(proj.TP.prm{i_m},2)==6 && ...
                size(proj.TP.prm{i_m}{6},2)>=1 && ...
                size(proj.TP.prm{i_m}{6}{1},2)==nFRET
            gamma_m = proj.TP.prm{i_m}{6}{1}(1,:);
            beta_m = proj.TP.prm{i_m}{6}{1}(2,:);
        else
            gamma_m = ones(1,nFRET);
            beta_m = ones(1,nFRET);
        end
        gammas = cat(1,gammas,repmat(gamma_m,L,1));
        betas = cat(1,betas,repmat(beta_m,L,1));
    end
    allS = calcS(allExc,chanExc,S,FRET,I_re,gammas,betas);
    traj = allS(:,i_s);
    traj = reshape(traj, [L N]);

    % current data is an intensity ratio
    isratio = true;

elseif tpe<=(2*nChan*nExc + 2*nDE + 2*nFRET + 2*nS) % Stoichiometry
    i_s = tpe - 2*nChan*nExc - 2*nDE - 2*nFRET - nS;
    traj = S_discr(:,i_s:nS:end);

    % current data is an intensity ratio
    isratio = true;
end

traj = traj(:,m_incl & m_tag);
            