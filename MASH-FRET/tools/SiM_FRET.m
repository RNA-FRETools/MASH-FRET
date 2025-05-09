function [I,prm] = SiM_FRET(K0,nL0,N,dir_out,varargin)
% SiM_FRET(K,nL,N,dir_out)
% SiM_FRET(K,nL,N,dir_out,expMov)
% SiM_FRET(K,nL,N,dir_out,expMov,expCoord)
%
% SiM_FRET (Simulation of Multiple FRET pair network) simulates and export N sets of intensity-time traces of multiple donor-acceptor FRET pairs.
% Associated single molecule video and molecule coordinates can be exported too.
%
% K: number of channels
% nL: number of alternating lasers
% N: sample size
% dir_out: destination directory
% expMov: (1) to export associated video file in sira format, (0) othertwise
% expCoord: (1) to export associated molecule coordinates file, (0) otherwise

% defaults
f = 10; % frame rate
L = 100; % observation time
tau_0 = 10*L/f; % bleaching time constant
J = 3; % number of states
kin = rand(J)/10;% transition rate matrix
kin(~~eye(J)) = 0;
I_0 = 56; % fluorescence intensity in absence of acceptor
camoffset = 113; % camera offset
resx = 100; % video x-dimension
resy = 100; % video y-dimension

% collect arguments
expMov = false;
expCoord = false;
if ~isempty(varargin)
    expMov = varargin{1};
    if size(varargin,2)>=2
        expCoord = varargin{2};
    end
end

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
bgI = rand(nL,K)*2;
L0 = nL*L;

% generates random coordinates
chanw = round(resx/K0);
coord = rand(N,2);
coord(:,1) = 1+coord(:,1)*(chanw-1);
coord(:,2) = 1+coord(:,2)*resy;
for k = 2:K0
    coord = cat(2,coord,[coord(:,1)+(k-1)*chanw,coord(:,2)]);
end

dummy = getSiMFRET_prm(N,f,L,tau_0,J,kin);

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
mix = cell(1,nFRET);
discr_seq = cell(1,nFRET);
dt_final = cell(1,nFRET);
E = cell(1,N);
for n = 1:N
    E{n} = zeros(J,J,L);
end
E0 = rand(nFRET,J)*0.8;
for pair = pairs_red2green
    ok = buildModel(dummy);
    if ~ok
        return
    end
    h = guidata(dummy);
    mix{pair} = h.results.sim.mix;
    discr_seq{pair} = h.results.sim.discr_seq;
    dt_final{pair} = h.results.sim.dt_final;

    % get FRET state sequences
    for n = 1:N
        E{n}(FRET(pair,1),FRET(pair,2),:) = permute(...
            sum(repmat(E0(pair,:)',[1 L]).*mix{pair}{n},1),[1,3,2]);
        E{n}(E{n}<0 | isnan(E{n})) = NaN;
    end
end

close(dummy);

% generate random coefficients
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
gamma0 = 0.5+rand(1,K)/2; % generate random gamma and beta factors for scaling emitter 1 with others
beta0 = 0.5+rand(1,K)/2;
gamma = ones(1,nFRET);
beta = ones(1,nFRET);
for pair = 1:nFRET
    don = FRET(pair,1);
    acc = FRET(pair,2);
    if don==1
        gamma(pair) = gamma0(acc);
        beta(pair) = beta0(acc);
    else % gamma23 = gamma13/gamma12
        gamma(pair) = gamma0(acc)/gamma0(don);
        beta(pair) = beta0(acc)/beta0(don);
    end
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
In = cell(1,N);
I = zeros(L,K*N,nL);
fname = sprintf('%ichan%iexc',K0,nL0);
for n = 1:N
    In{n} = zeros(nL,K,L);

    [o,wl_red2green] = sort(wl,'descend');
    for l = wl_red2green
        don = find(chanExc==wl(l),1);
        if isempty(don)
            continue
        end
        In{n}(l,don,:) = I_0./...
            (1 + sum(E{n}(don,(1:K)>don,:)./(1-E{n}(don,(1:K)>don,:)),2));
        for acc = (don+1):K
            In{n}(l,acc,:) = sum(permute(In{n}(l,(1:K)<acc,:),[2,1,3]).*...
                E{n}((1:K)<acc,acc,:)./(1-E{n}((1:K)<acc,acc,:)),1)./...
                (1 + sum(E{n}(acc,(1:K)>acc,:)./(1-E{n}(acc,(1:K)>acc,:)),2));
        end
    end
    In{n}(isnan(In{n})) = 0;
    
    % add cross-talks and factor bias
    I_corr = permute(In{n},[3,2,1]);
    for k = 2:K
        I_corr(:,k,:) = I_corr(:,k,:)*gamma0(k);
    end
    for k = 2:K
        l0 = find(wl==chanExc(k),1);
        if ~isempty(l0)
            I_corr(:,:,l0) = I_corr(:,:,l0)*beta0(k);
        end
    end
    I_de = I_corr;
    for k1 = 1:K
        l0 = find(wl==chanExc(k));
        if ~isempty(l0)
            I_de(:,k,:) = I_de(:,k,:) + ...
                repmat(permute(De(k,:),[1,3,2]),[L,1,1]).*...
                repmat(I_corr(:,k,l0),[1,1,nL]);
        end
    end
    I_bt = I_de;
    for k1 = 1:K
        I_bt(:,k1,:) = I_bt(:,k1,:) + ...
            sum(repmat(Bt(:,k1)',[L,1,nL]).*I_de,2);
    end
    
    % add fluorescence background and photon noise
    I_bt = random('poiss', I_bt + repmat(permute(bgI,[3,2,1]),[L,1,1]));
    
    % add camera offset
    I_bt = I_bt + camoffset;
    
    I(:,(((n-1)*K)+1):n*K,:) = I_bt;
    
    % save data
    I2save = [];
    for l = 1:nL
        if l<=nL0
            I2save = cat(2,I2save,(l:nL:L0)'/f);
            I2save = cat(2,I2save,I_bt(:,1:K0,l));
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
if expMov
    figname = get(gcf,'Name');
    vers = figname(length('MASH-FRET '):end);
    fid = writeSiraFile('init',[dir_out,filesep,fname,'.sira'],vers,[1/f,...
        [resx,resy],L0]);
    if fid==-1
        disp('Enable to open video file');
        return
    end
    nPix = resx*resy;
    limchan = [1,round(resx/K0)];
    for k = 2:K0
        if k<K0
            limchan = cat(1,limchan,...
                [limchan(k-1,2)+1,limchan(k-1,2)+round(resx/K0)]);
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
            img(:,limchan(k,:)) = ...
                random('poiss',img(:,limchan(k,:))+bgI(k));
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
    fullfile = cat(2,dir_out,filesep,fname,'.coord');
    fid = fopen(fullfile,'Wt');
    fprintf(fid,cat(2,repmat('x%i\ty%i\t',[1,K0]),'\n'),...
        reshape([1:K0;1:K0],1,2*K0));
    fprintf(fid,cat(2,repmat('%0.1f\t%0.1f\t',[1,K0]),'\n'),coord');
    fclose(fid);
end

prm.f = f;
prm.L = L;
prm.tau_0 = tau_0;
prm.J = J;
prm.k = kin;
prm.I_0 = I_0;
prm.bgI = bgI(1:K0);
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


function h_fig = getSiMFRET_prm(N,f,L,tau_0,J,k)

h_fig = figure('visible','off');

h = struct();

h.mute_actions = false;
h.uipanel_S = NaN;
h.uipanel_TA = NaN;
h.uipanel_HA = NaN;

h.param = struct();
h.param.sim = struct();

h.param.sim.molNb = N;
h.param.sim.nbFrames = L;
h.param.sim.rate = f;
h.param.sim.nbStates = J;
h.param.sim.kx = k;
h.param.sim.bleach = false;
h.param.sim.bleach_t = tau_0;
h.param.sim.impPrm = false;
h.param.sim.molPrm = [];

guidata(h_fig,h);

