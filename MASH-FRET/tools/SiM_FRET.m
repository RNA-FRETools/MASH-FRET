function [I,prm] = SiM_FRET(K0,nL0,N,L0,J,dir_out,varargin)
% SiM_FRET(K,nL,N,L,J,dir_out)
% SiM_FRET(K,nL,N,L,J,dir_out,expTraj)
% SiM_FRET(K,nL,N,L,J,dir_out,expTraj,expMov)
% SiM_FRET(K,nL,N,L,J,dir_out,expTraj,expMov,expCoord)
%
% SiM_FRET (Simulation of Multiple FRET pair network) simulates and export N sets of intensity-time traces of multiple donor-acceptor FRET pairs.
% Associated single molecule video and molecule coordinates can be exported too.
%
% K: number of channels
% nL: number of alternating lasers
% N: sample size
% L: full observation time (in time steps)
% J: number of states
% dir_out: destination directory
% expTraj: (1) to export sm trajetcories to text files, (0) otherwise
% expMov: (2) to export single-channel video files (1) to export multi-channel video file, (0) othertwise
% expCoord: (1) to export associated molecule coordinates file, (0) otherwise

% defaults
f = 10; % frame rate
kin = 0.01*(1+randsample([-1,1],1)*0.1*rand(J));% transition rate matrix
kin(~~eye(J)) = 0;
I_0 = 100; % fluorescence intensity in absence of acceptor
camoffset = 113; % camera offset
Lmin = 5; % minimum trajectory length
itgarea = 20; % dimension of empty space around molecules (pixel)

% add source folders to MATLAB search path
disp('set MATLAB search path...')
codePath = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(codePath));

% collect arguments
expTraj = false;
expMov = 0;
expCoord = false;
if ~isempty(varargin)
    expTraj = varargin{1};
    if size(varargin,2)>=2
        expMov = varargin{2};
        if size(varargin,2)>=3
            expCoord = varargin{3};
        end
    end
end
singlechanvid = expMov==2;

% create dump directory if not existing
if ~exist(dir_out,'dir')
    mkdir(dir_out)
end

% correct input settings
if K0==1
    K = 2;
else
    K = K0;
end
if nL0==1
    nL = 2;
else
    nL = nL0;
end

% generate random fluorescent background (in PC)
bgI = rand(nL,K)*10;

% generate random bleaching and blinking time constants
L = floor(L0/nL);
L0 = nL*L;
tau_bleach = (0.9+0.1*rand(1,K))*L0; % bleaching time constant
tau_blink = repmat(0.9+0.1*rand(K,1),[1,2]).*repmat([L0/200,L0/10],[K,1]); % blink-off and -on time constants

% generates random coordinates
if singlechanvid
    chanw = ceil(sqrt(N*(itgarea^2))); % video x-dimension
    resx = chanw;
else
    chanw = ceil(sqrt(N*(itgarea^2)/K0)); % video x-dimension
    resx = chanw*K0;
end
resy = resx; % video y-dimension
coord = rand(N,2);
coord(:,1) = coord(:,1)*chanw;
coord(:,2) = coord(:,2)*resy;
for k = 2:K0
    if singlechanvid
        coord = cat(2,coord,coord(:,[1,2]));
    else
        coord = cat(2,coord,[coord(:,1)+(k-1)*chanw,coord(:,2)]);
    end
end

dummy = getSiMFRET_prm(N,f,L0,J,kin);

% get FRET pairs
FRET = [];
wl = [];
while isempty(wl) || numel(unique(wl))~=nL
    wl = round(1000*sort(rand(1,nL))); % laser wavelengths
end
chanExc = zeros(1,K);
chanExc(1:min([K,nL])) = wl(1:min([K,nL]));
for don = 1:(K-1)
    if chanExc(don)>0
        for acc = (don+1):K
            FRET = cat(1,FRET,[don,acc]);
        end
    end
end
nFRET = size(FRET,1);

[o,pairs_red2green] = sort(chanExc(FRET(:,1)),'descend');

% get state sequences for each pair
disp('Get state sequences for each FRET pair...')
mix = cell(1,nFRET);
discr_seq = cell(1,nFRET);
dt_final = cell(1,nFRET);
E = cell(1,N);
for n = 1:N
    E{n} = zeros(J,J,L0);
end
E0 = [];
for pair = 1:nFRET
    erand = rand(1,10);
    eval = linspace(min(erand),max(erand),J);
    ord = randsample(J,J,false);
    E0 = cat(1,E0,eval(ord));
end
for pair = pairs_red2green
    ok = buildModel(dummy);
    if ~ok
        return
    end
    h = guidata(dummy);
    mix{pair} = h.param.proj{1}.sim.prm.res_dt{1};
    discr_seq{pair} = h.param.proj{1}.sim.prm.res_dt{2};
    dt_final{pair} = h.param.proj{1}.sim.prm.res_dt{3};

    % get FRET state sequences
    for n = 1:N
        fretseq0 = sum(repmat(E0(pair,:)',[1 L0]).*mix{pair}(:,:,n),1);
        E{n}(FRET(pair,1),FRET(pair,2),:) = permute(fretseq0,[1,3,2]);
    end
end
figname = get(dummy,'name');
close(dummy);

% generate random coefficients
disp('Generate random correction factors...')
Bt = rand(K)/10;
for k = 1:K
    Bt(k,(1:K)<=k) = 0;
end
De = rand(K,nL)/20;
for k = 1:K
    if chanExc(k)>0
        De(k,wl>=chanExc(k)) = 0;
    end
end

% generate random gamma and beta factors for scaling emitter 1 with others
QY0 = 0.2+0.8*rand(1,K); % quantum yield
eta = 0.9+0.1*rand(1,K); % detection efficiency
laspow = (0.5+0.5*rand(1,nL))/10; % laser power in W
eps0 = (0.9+0.1*rand(1,K))*80000; % extinction coefficient
gamma = ones(1,nFRET);
beta = ones(1,nFRET);
for pair = 1:nFRET
    don = FRET(pair,1);
    acc = FRET(pair,2);
    gamma(pair) = (QY0(acc)*eta(acc))/(QY0(don)*eta(don));

    ldon = find(wl==chanExc(don));
    lacc = find(wl==chanExc(acc));
    if isempty(lacc) || isempty(ldon)
        continue
    end
    beta(pair) = (laspow(lacc)*eps0(acc))/(laspow(ldon)*eps0(don));
end

% get file structure
header = '';
fmt = '';
for l = 1:nL
    if l<=nL0
        header = cat(2,header,sprintf('timeat%inm',wl(l)),'\t');
        fmt = cat(2,fmt,'%d\t');
        for k = 1:K
            if k<=K0
                header = cat(2,header,sprintf('I_%iat%inm',k,wl(l)),'\t');
                fmt = cat(2,fmt,'%d\t');
            end
        end
    end
end
header(end) = 'n';
fmt(end) = 'n';

% get intensities
disp('Calculate intensities...')
In = cell(1,N);
I = zeros(L0,K*N,nL);
fname = sprintf('%ichan%iexc',K0,nL0);
for n = 1:N
    In{n} = zeros(nL,K,L0);

    % generate random emitter off times
    ison = ones(1,K,L0);
    for k = 1:K

        % generate random photobleaching times
        Lnk = ceil(max([min([random('exp',tau_bleach),L0]),Lmin]));
        ison(1,k,(Lnk+1):end) = 0;

        % generate random blinking times
        [mix,~,~] = genstateseq(L0,ones(2),2,[0,1;1,0],[0.5,0.5],...
            tau_blink(k,:));
        blinkseq0 = sum(mix.*repmat([0;1],1,L0),1);
        ison(1,k,:) = ison(1,k,:).*permute(blinkseq0,[1,3,2]);
    end

    % cancel FRET when donor or acceptor bleaches
    for don = 1:K
        for acc = 1:K
            E{n}(don,acc,:) = ...
                E{n}(don,acc,:).*ison(1,don,:).*ison(1,acc,:);
        end
    end

    % calculate ideal intensities
    [o,wl_red2green] = sort(wl,'descend');
    for l = wl_red2green
        don = find(chanExc==wl(l),1);
        if isempty(don)
            continue
        end
        In{n}(l,don,:) = I_0./...
            (1 + sum(E{n}(don,(1:K)>don,:)./(1-E{n}(don,(1:K)>don,:)),2));
        In{n}(l,don,:) = In{n}(l,don,:).*ison(1,don,:); % off donor data
        for acc = (don+1):K
            In{n}(l,acc,:) = sum(permute(In{n}(l,(1:K)<acc,:),[2,1,3]).*...
                E{n}((1:K)<acc,acc,:)./(1-E{n}((1:K)<acc,acc,:)),1)./...
                (1 + sum(E{n}(acc,(1:K)>acc,:)./(1-E{n}(acc,(1:K)>acc,:)),2));
            In{n}(l,acc,:) = In{n}(l,acc,:).*ison(1,acc,:); % off acceptor data
        end
    end
    
    % add cross-talks and factor bias
    I_corr = permute(In{n},[3,2,1]);
    for k = 2:K
        l0 = find(wl==chanExc(k),1);
        if ~isempty(l0)
            I_corr(:,:,l0) = ...
                I_corr(:,:,l0)*eps0(k)*laspow(l0)/(eps0(1)*laspow(1));
        end
    end
    for k = 2:K
        I_corr(:,k,:) = ...
            I_corr(:,k,:)*QY0(k)*eta(k)/(QY0(1)*eta(1));
    end
    I_de = I_corr;
    for k = 1:K
        l0 = find(wl==chanExc(k));
        if ~isempty(l0)
            % does not take into account FRET when DE by greener wl
        %     I_de(:,k,:) = I_de(:,k,:) + ...
        %         repmat(permute(De(k,:),[1,3,2]),[L,1,1]).*...
        %         repmat(I_corr(:,k,l0),[1,1,nL]);
            % take into account FRET when DE by greener wl
            I_de(:,(1:K)>=k,wl<wl(l0)) = I_de(:,(1:K)>=k,wl<wl(l0)) + ...
                repmat(permute(De(k,wl<wl(l0)),[1,3,2]),[L0,nnz((1:K)>=k),1]).*...
                repmat(I_corr(:,(1:K)>=k,l0),[1,1,nnz(wl<wl(l0))]); 
        end
    end
    I_bt = I_de;
    for k = 1:K
        I_bt(:,k,:) = I_bt(:,k,:) + ...
            sum(repmat(Bt(:,k)',[L0,1,nL]).*I_de,2);
    end
    
    % add fluorescence background and photon noise
    I_bt = random('poiss', I_bt + repmat(permute(bgI,[3,2,1]),[L0,1,1]));
    
    % add camera offset
    I_bt = I_bt + camoffset;
    
    I(:,(((n-1)*K)+1):n*K,:) = I_bt;
    
    % save data
    if ~expTraj
        continue
    end
    I2save = [];
    for l = 1:nL
        if l<=nL0
            I2save = cat(2,I2save,(l:nL:L0)'/f);
            I2save = cat(2,I2save,I_bt(l:nL:L0,1:K0,l));
        end
    end
    fullfile = cat(2,dir_out,filesep,fname,sprintf('_mol%ion%i.txt',n,N));
    fid = fopen(fullfile,'Wt');
    fprintf(fid,cat(2,'coordinates:',repmat('\t%0.1f,%0.1f',[1,K0]),'\n'),...
        coord(n,:));
    fprintf(fid,header);
    fprintf(fid,fmt,I2save');
    fclose(fid);
end

% export video
if expMov==2
    disp('Calculate videos...')
    vers = figname(length('MASH-FRET '):end);
    pos = ceil(coord);
    for k = 1:K0
        fid = writeSiraFile('init',...
            [dir_out,filesep,fname,'_em',num2str(k),'.sira'],vers,...
            [1/f,[resx,resy],L0]);
        if fid==-1
            disp('Enable to open video file');
            return
        end
        nPix = resx*resy;
        for l = 1:L0
            exc = mod(l,nL0);
            if exc==0
                exc = nL0;
            end
            l_exc = ceil(l/nL0);
            img = random('poiss',zeros(resy,resx)+bgI(exc,k)) + camoffset;
            for n = 1:N
                img(pos(n,2*k),pos(n,2*k-1)) = I(l_exc,((n-1)*K)+k,exc);
            end
            writeSiraFile('append',fid,img,nPix);
        end
        fclose(fid);
    end
end
if expMov==1
    disp('Calculate video...')
    vers = figname(length('MASH-FRET '):end);
    fid = writeSiraFile('init',[dir_out,filesep,fname,'.sira'],vers,[1/f,...
        [resx,resy],L0]);
    if fid==-1
        disp('Enable to open video file');
        return
    end
    nPix = resx*resy;
    limchan = [1,chanw];
    for k = 2:K0
        if k<K0
            limchan = cat(1,limchan,...
                [limchan(k-1,2)+1,limchan(k-1,2)+chanw]);
        else
            limchan = cat(1,limchan,[limchan(k-1,2)+1,resx]);
        end
    end
    pos = ceil(coord);
    for l = 1:L0
        exc = mod(l,nL0);
        if exc==0
            exc = nL0;
        end
        l_exc = ceil(l/nL0);
        img = zeros(resy,resx);
        for k = 1:K0
            img(:,limchan(k,1):limchan(k,2)) = random('poiss',...
                img(:,limchan(k,1):limchan(k,2))+bgI(exc,k));
        end
        img = img + camoffset;
        for n = 1:N
            for k = 1:K0
                img(pos(n,2*k),pos(n,2*k-1)) = I(l_exc,((n-1)*K)+k,exc);
            end
        end
        writeSiraFile('append',fid,img,nPix);
    end
    fclose(fid);
end
if expCoord
    disp('Export coordinates...')
    fullfile = cat(2,dir_out,filesep,fname,'.coord');
    fid = fopen(fullfile,'Wt');
    fprintf(fid,cat(2,repmat('x%i\ty%i\t',[1,K0]),'\n'),...
        reshape([1:K0;1:K0],1,2*K0));
    fprintf(fid,cat(2,repmat('%0.1f\t%0.1f\t',[1,K0]),'\n'),coord');
    fclose(fid);
end

disp('Export simulation parameters...')
prm.f = f;
prm.L = L;
prm.tau_0 = tau_bleach;
prm.tau_blink = tau_blink;
prm.J = J;
prm.k = kin;
prm.I_0 = I_0;
prm.bgI = bgI;
prm.camoffset = camoffset;
prm.FRET = FRET(1:nFRET,:);
prm.wl = wl(1:nL0);
prm.chanExc = chanExc(1:K0);
prm.E0 = E0;
prm.Bt = Bt(1:K0,1:K0);
prm.De = De(1:K0,1:nL0);
prm.gamma = gamma(1:nFRET);
prm.beta = beta(1:nFRET);

save(cat(2,dir_out,filesep,fname,'.mat'),'prm');

disp('process completed!');


function h_fig = getSiMFRET_prm(N,f,L,J,k)

h_fig = figure('visible','off','name','MASH-FRET dummy');

h = struct();

h.mute_actions = false;
h.uipanel_S = NaN;
h.uipanel_TA = NaN;
h.uipanel_HA = NaN;

h.param.curr_proj = 1;
h.param.proj = cell(1,1);
h.param.proj{1}.sim.prm.gen_dt = [];
h.param.proj{1}.sim.prm.res_dt = cell(1,3);
h.param.proj{1}.sim.def.res_dat = [];

h.param.proj{1}.sim.curr.gen_dt = cell(1,3);
h.param.proj{1}.sim.curr.gen_dt{1} = [N,L,J,f,0,0];
h.param.proj{1}.sim.curr.gen_dt{2} = k;
h.param.proj{1}.sim.curr.gen_dt{3} = cell(1,2);
h.param.proj{1}.sim.curr.gen_dt{3}{1} = 0;
h.param.proj{1}.sim.curr.gen_dt{3}{2} = [];

guidata(h_fig,h);

