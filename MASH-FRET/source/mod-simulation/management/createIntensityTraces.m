function [Idon_ic,Iacc_ic,err] = createIntensityTraces(Idon,Iacc,coord,img_bg,p)
% Create donor and acceptor intensity-time traces from the corresponding 
% intensity state sequences and fluorescent background image: add cross 
% talks, background, shot noise and camera noise.
%
% Idon: [L-by-1] donor intensity state sequence
% Iacc: [L-by-1] acceptor intensity state sequence
% coord: [1-by-4] molecule coordinates
% img_bg: fluorescent background image
% p: structure containing simulation parameters that must have fields:
%   p.rate: frame rate (s-1)
%   p.noiseType: camera noise distribution ('poiss','norm','user','none','hirsch')
%   p.camNoise: [1-by-6] distribution parameters
%   p.sat: saturation pixel value calculated from camera bit rate
%   p.totInt: total emitted intensity (a.u.)
%   p.btD: bleedthrough coefficients D -> A
%   p.btA: bleedthrough coefficients A -> D, usually zero
%   p.deD: direct excitation coefficients D, usually zero
%   p.deA: direct excitation coefficients A
%   p.z0Dec: defocusing exponential amplitude
%   p.zDec: defocusing exponential time decay constant
%   p.bgDec: exponentially decreasing BG (0/1)
%   p.ampDec: exponential amplitude
%   p.cstDec: exponential time decay constant
%
% Idon_ic: [L-by-1] camera-detected donor intensity-time trace
% Iacc_ic: [L-by-1] camera-detected acceptor intensity-time trace

% Last update: 29.11.2019 by MH
% >> move script that create intensity-time traces from plotExample.m to 
%  this separate file; this allows to call the same script from 
%  plotExample.m and exportResults.m, preventing unilateral modifications
% >> move script that generate dynamic background to the separate function 
%  expBackground.m, and script that add camera noise to addCameraNoise.m; 
%  this allows to call the same script from here and createVideoFrame.m, 
%  preventing unilateral modifications
%
% update: 7th of March 2018 by Richard Börner
% >> Comments adapted for Boerner et al 2017

% defaults
bgDec_dir = {'decrease','decrease'};

% identify gaussian camera noise
isgaussnoise = strcmp(p.noiseType,'norm');

% get pixel indexes from double coordinates
xy = ceil(coord);

% get trace length
L = numel(Idon);

% direct excitation assuming I_Dem_Dex without FRET = I_Aem_Aex
% comment: this value can only be correct for ALEX type
% measurements. Therefore, direct excitation should only be
% simulated for ALEX type simulations.
% I_de = I + De*I_j
I_don_de = Idon + p.deD*p.totInt; % usally zero, there is no direct excitation of the Donor 
I_acc_de = Iacc + p.deA*p.totInt;

% bleedthrough (missing signal in each channel will be added in the other)
% I_bt = I_de - Bt*I_j_de
I_don_bt = (1-p.btD)*I_don_de + p.btA*I_acc_de;
I_acc_bt = (1-p.btA)*I_acc_de + p.btD*I_don_de;

% add photon emission noise, which is Poisson-noise
if ~isgaussnoise % no Poisson noise for pure Gaussian noise
    I_don_bt = random('poiss', I_don_bt);
    I_acc_bt = random('poiss', I_acc_bt);
end

% add noisy fluorescent background trace
% I_bg = I_bt + bg 
if p.bgDec % exp decay of background, to check
    timeaxis = (1:L)'/p.rate;
    bg_trace_don = expBackground('all',bgDec_dir{1},timeaxis,...
        img_bg(xy(2),xy(1)),p.ampDec,p.cstDec);
    bg_trace_acc = expBackground('all',bgDec_dir{2},timeaxis,...
        img_bg(xy(4),xy(3)),p.ampDec,p.cstDec);

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
[Idon_ic,err] = addCameraNoise(Idon_pc,p);
if isempty(Idon_ic)
    Iacc_ic = [];
    return;
end
[Iacc_ic,err] = addCameraNoise(Iacc_pc,p);
if isempty(Iacc_ic)
    Idon_ic = [];
    return;
end

% convert to proper intensity units
if strcmp(p.intOpUnits, 'photon')
    [mu_y_dark,K,eta] = getCamParam(p.noiseType,p.camNoise);
    Idon_ic = arb2phtn(Idon_ic, mu_y_dark, K, eta);
    Iacc_ic = arb2phtn(Iacc_ic, mu_y_dark, K, eta);
end
