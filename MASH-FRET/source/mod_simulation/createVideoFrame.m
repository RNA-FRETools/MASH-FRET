function [img,gaussMat,err] = createVideoFrame(l,Idon,Iacc,coord,img_bg,p)
% Create requested indexed video frame from the corresponding intensity 
% state sequences and fluorescent background image: add cross talks, 
% background, shot noise, PSF convoltion and camera noise.
%
% l: frame index
% Idon: {1-by-N} [L-by-1] donor intensity state sequences
% Iacc: {1-by-N} [L-by-1] acceptor intensity state sequences
% coord: [N-vy-4] molecule coordinates
% img_bg: fluorescent background image (photon counts)
% p: structure containing simulation parameters that must have fields:
%   p.movDim: video dimensions in x- and y-directions
%   p.rate: frame rate (s-1)
%   p.pixDim: pixel dimensions (in micrometers)
%   p.noiseType: camera noise distribution ('poiss','norm','user','none','hirsch')
%   p.camNoise: [1-by-6] distribution parameters
%   p.sat: saturation pixel value calculated from camera bit rate
%   p.totInt: total emitted intensity (a.u.)
%   p.btD: bleedthrough coefficients D -> A
%   p.btA: bleedthrough coefficients A -> D, usually zero
%   p.deD: direct excitation coefficients D, usually zero
%   p.deA: direct excitation coefficients A
%   p.PSF: convolute with PSF (0/1)
%   p.PSFw: PSF standard deviation (in micrometers)
%   p.matGauss: PSF factor matrix
%   p.z0Dec: defocusing exponential amplitude (in construction)
%   p.zDec: defocusing exponential time decay constant (in construction)
%   p.bgDec: exponentially decreasing background (0/1)
%   p.ampDec: background exponential amplitude
%   p.cstDec: background exponential time decay constant
%
% img: camera-detected video frame
% gaussMat: updated PSF factor matrix
% err: potential error message

% Last update: 29.11.2019 by MH
% >> move script that create video frames from plotExample.m to this 
%  separate file; this allows to call the same script from plotExample.m 
%  and exportResults.m, preventing unilateral modifications
% >> move script that generate exponentially decaying background to the 
%  separate function expBackground.m, and script that add camera noise to 
%  addCameraNoise.m; this allows to call the same script from here and 
%  createIntensityTraces.m, preventing unilateral modifications
%
% update: 7th of March 2018 by Richard Börner
% >> Comments adapted for Boerner et al 2017

% defaults
bgDec_dir = {'decrease','decrease'};

% get sample size (number of simulated molecules)
N = numel(Idon);

% get trace length
L = numel(Idon{1});

% identify gaussian camera noise
isgaussnoise = strcmp(p.noiseType,'norm'); % gaussian camera noise

% get pixel indexes from double coordinates
xy = ceil(coord);

% initialize first frame
res_x = p.movDim(1); % movie with
res_y = p.movDim(2); % movie height
splt = round(res_x/2);
img_don = zeros(res_y,splt);
img_acc = zeros(res_y,res_x-splt);

% split background image into channels
img_bg_don = img_bg(:,1:splt);
img_bg_acc = img_bg(:,(splt+1):end);

% adjust exp decay of background, to check
if p.bgDec
    timeaxis = (1:L)'/p.rate;
    img_bg_don = expBackground(l,bgDec_dir{1},timeaxis,img_bg_don,p.ampDec,...
        p.cstDec);
    img_bg_acc = expBackground(l,bgDec_dir{2},timeaxis,img_bg_acc,p.ampDec,...
        p.cstDec);
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
    I_don_de = Idon{n}(l,1) + p.deD*p.totInt; % there is no direct excitation of the Donor 
    I_acc_de = Iacc{n}(l,1) + p.deA*p.totInt;

    % bleedthrough (missing signal in each channel will be added in the other)
    % I_bt = I_de - Bt*I_j_de
    I_don_bt = (1-p.btD)*I_don_de + p.btA*I_acc_de;
    I_acc_bt = (1-p.btA)*I_acc_de + p.btD*I_don_de;

    % add photon emission noise, which is Poisson-noise
    if ~isgaussnoise % shot noise included in gaussian camera noise
        I_don_bt = random('poiss', I_don_bt);
        I_acc_bt = random('poiss', I_acc_bt);
    end

    % define Point-Spread-Function (PSF) for each simulated molecule
    if p.PSF
        o_psf = p.PSFw/p.pixDim; % PSF sigma (for both channels)
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
if p.PSF
    lim_don.x = [1,splt];
    lim_don.y = [1,res_y];
    lim_acc.x = [1,res_x-splt];
    lim_acc.y = [1,res_y];
    [img_don,gaussMat{1}] = getImgGauss(lim_don,p_don,1,p.matGauss{1});
    [img_acc,gaussMat{2}] = getImgGauss(lim_acc,p_acc,1,p.matGauss{2});
else
    % return previous PSF factor image
    gaussMat = p.matGauss;
end

img_don = img_don + img_bg_don;
img_acc = img_acc + img_bg_acc;

img = [img_don,img_acc];

% add camera noise
[img,err] = addCameraNoise(img,p);

% convert to proper intensity units
if strcmp(p.intOpUnits, 'photon')
    [mu_y_dark,K,eta] = getCamParam(p.noiseType,p.camNoise);
    img = arb2phtn(img, mu_y_dark, K, eta);
end

