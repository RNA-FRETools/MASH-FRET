function [Idon_ic,Iacc_ic,err] = createIntensityTraces(Idon,Iacc,coord,img_bg,prm,opun)
% Create donor and acceptor intensity-time traces from the corresponding 
% intensity state sequences and fluorescent background image: add cross 
% talks, background, shot noise and camera noise.
%
% Idon: [L-by-1] donor intensity state sequence
% Iacc: [L-by-1] acceptor intensity state sequence
% coord: [1-by-4] molecule coordinates
% img_bg: fluorescent background image
% prm: applied simulation parameters
% opun: output intensity units
%
% Idon_ic: [L-by-1] camera-detected donor intensity-time trace
% Iacc_ic: [L-by-1] camera-detected acceptor intensity-time trace

% update 29.11.2019 by MH: (1) move script that create intensity-time traces from plotExample.m to this separate file; this allows to call the same script from plotExample.m and exportResults.m, preventing unilateral modifications, (2) move script that generate dynamic background to the separate function expBackground.m, and script that add camera noise to addCameraNoise.m; this allows to call the same script from here and createVideoFrame.m, preventing unilateral modifications
% update 7.3.2018 by RB: Comments adapted for Boerner et al 2017

% defaults
bgDec_dir = {'decrease','decrease'};

% collect simulation parameters
rate = prm.gen_dt{1}(4);
noisetype = prm.gen_dat{1}{2}{4};
noiseprm = prm.gen_dat{1}{2}{5};
Itot = prm.gen_dat{3}{1}(1);
btD = prm.gen_dat{5}(1,1);
btA = prm.gen_dat{5}(1,2);
deD = prm.gen_dat{5}(2,1);
deA = prm.gen_dat{5}(2,2);
isbgdec = prm.gen_dat{8}{5}(1);
bgcst = prm.gen_dat{8}{5}(2);
bgamp = prm.gen_dat{8}{5}(3);

% identify gaussian camera noise
isgaussnoise = strcmp(noisetype,'norm');

% get pixel indexes from double coordinates
xy = ceil(coord);

% get trace length
L = numel(Idon);

% direct excitation assuming I_Dem_Dex without FRET = I_Aem_Aex
% comment: this value can only be correct for ALEX type
% measurements. Therefore, direct excitation should only be
% simulated for ALEX type simulations.
% I_de = I + De*I_j
I_don_de = Idon + deD*Itot; % usally zero, there is no direct excitation of the Donor 
I_acc_de = Iacc + deA*Itot;

% bleedthrough (missing signal in each channel will be added in the other)
% I_bt = I_de - Bt*I_j_de
I_don_bt = (1-btD)*I_don_de + btA*I_acc_de;
I_acc_bt = (1-btA)*I_acc_de + btD*I_don_de;

% add photon emission noise, which is Poisson-noise
if ~isgaussnoise % no Poisson noise for pure Gaussian noise
    I_don_bt = random('poiss', I_don_bt);
    I_acc_bt = random('poiss', I_acc_bt);
end

% add noisy fluorescent background trace
% I_bg = I_bt + bg 
if isbgdec % exp decay of background, to check
    timeaxis = (1:L)';
    bg_trace_don = expBackground('all',bgDec_dir{1},timeaxis,...
        img_bg(xy(2),xy(1)),bgamp,bgcst);
    bg_trace_acc = expBackground('all',bgDec_dir{2},timeaxis,...
        img_bg(xy(4),xy(3)),bgamp,bgcst);

else % constant background pattern (constant, TIRF profile, patterned)  
    bg_trace_don = repmat(img_bg(xy(2),xy(1)),L,1);
    bg_trace_acc = repmat(img_bg(xy(4),xy(3)),L,1);
end
if ~isgaussnoise % no Poisson noise for pure Gaussian noise
    Idon_pc = I_don_bt + random('poiss',bg_trace_don);
    Iacc_pc = I_acc_bt + random('poiss',bg_trace_acc);
else
    Idon_pc = I_don_bt + bg_trace_don;
    Iacc_pc = I_acc_bt + bg_trace_acc;
end

% add camera noise
[Idon_ic,err] = addCameraNoise(Idon_pc,prm);
if isempty(Idon_ic)
    Iacc_ic = [];
    return;
end
[Iacc_ic,err] = addCameraNoise(Iacc_pc,prm);
if isempty(Iacc_ic)
    Idon_ic = [];
    return;
end

% convert to proper intensity units
if strcmp(opun, 'photon')
    [mu_y_dark,K,eta] = getCamParam(noisetype,noiseprm);
    Idon_ic = arb2phtn(Idon_ic, mu_y_dark, K, eta);
    Iacc_ic = arb2phtn(Iacc_ic, mu_y_dark, K, eta);
end
