function [img,gaussMat,err] = createVideoFrame(l,Idon,Iacc,coord,img_bg,prm,outun)
% Create requested indexed video frame from the corresponding intensity 
% state sequences and fluorescent background image: add cross talks, 
% background, shot noise, PSF convoltion and camera noise.
%
% l: frame index
% Idon: {1-by-N} [L-by-1] donor intensity state sequences
% Iacc: {1-by-N} [L-by-1] acceptor intensity state sequences
% coord: [N-vy-4] molecule coordinates
% img_bg: fluorescent background image (photon counts)
% prm: simulation parameters
% outun: output intensity units
% img: camera-detected video frame
% gaussMat: updated PSF factor matrix
% err: potential error message

% update 29.11.2019 by MH: (1) move script that create video frames from plotExample.m to this separate file; this allows to call the same script from plotExample.m and exportResults.m, preventing unilateral modifications (2) move script that generate exponentially decaying background to the separate function expBackground.m, and script that add camera noise to addCameraNoise.m; this allows to call the same script from here and createIntensityTraces.m, preventing unilateral modifications
% update 7.3.2018 by RN: Comments adapted for Boerner et al 2017

% defaults
bgDec_dir = {'decrease','decrease'};

% collect parameters
viddim = prm.gen_dat{1}{2}{1};
pixsz = prm.gen_dat{1}{2}{3};
noisetype = prm.gen_dat{1}{2}{4};
noiseprm = prm.gen_dat{1}{2}{5};
Itot = prm.gen_dat{3}{1}(1);
btD = prm.gen_dat{5}(1,1);
btA = prm.gen_dat{5}(1,2);
deD = prm.gen_dat{5}(2,1);
deA = prm.gen_dat{5}(2,2);
isPSF = prm.gen_dat{6}{1};
PSFw = prm.gen_dat{6}{2};
factmat = prm.gen_dat{6}{3};
isbgdec = prm.gen_dat{8}{5}(1);
bgcst = prm.gen_dat{8}{5}(2);
bgamp = prm.gen_dat{8}{5}(3);


% get sample size and video length
[L,N] = size(Idon);

% identify gaussian camera noise
isgaussnoise = strcmp(noisetype,'norm'); % gaussian camera noise

% get pixel indexes from double coordinates
xy = ceil(coord);

% initialize first frame
res_x = viddim(1); % movie with
res_y = viddim(2); % movie height
splt = round(res_x/2);
img_don = zeros(res_y,splt);
img_acc = zeros(res_y,res_x-splt);

% split background image into channels
img_bg_don = img_bg(:,1:splt);
img_bg_acc = img_bg(:,(splt+1):end);

% adjust exp decay of background, to check
if isbgdec
    timeaxis = (1:L)';
    img_bg_don = expBackground(l,bgDec_dir{1},timeaxis,img_bg_don,bgamp,...
        bgcst);
    img_bg_acc = expBackground(l,bgDec_dir{2},timeaxis,img_bg_acc,bgamp,...
        bgcst);
end

% add noise to fluorescent background image
if ~isgaussnoise % no Poisson noise for pure Gaussian noise
    img_bg_don = random('poiss',img_bg_don);
    img_bg_acc = random('poiss',img_bg_acc);
end

% calculate video frame
for n = 1:N

    % direct excitation assuming I_Dem_Dex without FRET = I_Aem_Aex
    % comment: this value can only be correct for ALEX type
    % measurements. Therefore, direct excitation should only be
    % simulated for ALEX type simulations.
    % I_de = I + De*I_j
    I_don_de = Idon(l,n) + deD*Itot; % there is no direct excitation of the Donor 
    I_acc_de = Iacc(l,n) + deA*Itot;

    % bleedthrough (missing signal in each channel will be added in the other)
    % I_bt = I_de - Bt*I_j_de
    I_don_bt = (1-btD)*I_don_de + btA*I_acc_de;
    I_acc_bt = (1-btA)*I_acc_de + btD*I_don_de;

    % add photon emission noise, which is Poisson-noise
    if ~isgaussnoise % shot noise included in gaussian camera noise
        I_don_bt = random('poiss', I_don_bt);
        I_acc_bt = random('poiss', I_acc_bt);
    end

    % define Point-Spread-Function (PSF) for each simulated molecule
    if isPSF
        o_psf = PSFw/pixsz; % PSF sigma (for both channels)
        if size(o_psf,1)>1
            o_psf1 = o_psf(n,1); 
            o_psf2 = o_psf(n,1);
        else
            o_psf1 = o_psf(1,1); 
            o_psf2 = o_psf(1,2);
        end
        p_don.amp(n,1) = I_don_bt;
        p_don.mu(n,1) = coord(n,1);
        p_don.mu(n,2) = coord(n,2);
        p_don.sig(n,1:2) = [o_psf1 o_psf1];

        p_acc.amp(n,1) = I_acc_bt;
        p_acc.mu(n,1) = coord(n,3) - splt;
        p_acc.mu(n,2) = coord(n,4);
        p_acc.sig(n,1:2) = [o_psf2 o_psf2];
        
    else
        img_don(xy(n,2),xy(n,1)) = I_don_bt;
        img_acc(xy(n,4),xy(n,3)-splt) = I_acc_bt;
    end

end

% build noisy + PSF convoluted sm fluorescence image
if isPSF
    lim_don.x = [1,splt];
    lim_don.y = [1,res_y];
    lim_acc.x = [1,res_x-splt];
    lim_acc.y = [1,res_y];
    [img_don,gaussMat{1}] = getImgGauss(lim_don,p_don,1,factmat{1});
    [img_acc,gaussMat{2}] = getImgGauss(lim_acc,p_acc,1,factmat{2});
else
    % return previous PSF factor image
    gaussMat = factmat;
end

img_don = img_don + img_bg_don;
img_acc = img_acc + img_bg_acc;

img = [img_don,img_acc];

% add camera noise
[img,err] = addCameraNoise(img,prm);

% convert to proper intensity units
if strcmp(outun, 'photon')
    [mu_y_dark,K,eta] = getCamParam(noisetype,noiseprm);
    img = arb2phtn(img, mu_y_dark, K, eta);
end

