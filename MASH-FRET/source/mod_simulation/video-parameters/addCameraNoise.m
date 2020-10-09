function [dat_noisy,err] = addCameraNoise(dat,p)
% [dat_noisy,err] = addCameraNoise(dat,p)
%
% Add camera noise to input data vector or matrix (photon count coming from the fluorophors and background). 
% Unless Gaussian camera noise is to be applied, in which case the shot noise is included in the model, input data must be Poisson-distributed. 
%
% Probability distribution for different noise contributions:
% Ptot = @(o,I0,q,c,f,nic,g) (1/sqrt(2*pi*o))*exp(-(I0*q+c)-((f*nic)^2)/(2*(o^2)))+(2/g)*chi2pdf(2*(I0*q+c),4.2*f*nic/g);
% G = @(noe,nie,g) (noe^(nie-1))*exp(-noe/g)/(gamma(nie)*(g^nie));
% P = @(nie,c) exp(-c)*(c^nie)/factorial(nie);
% N = @(fnic,noe,r) normpdf(fnic,noe,r);
% Pdark = @(nic,noe,nie,g,f,r) (P(nie,G(noe,nie,g))*N(f*nic,noe,r))*(f*nic);
%
% dat: data vector or matrix containing photon counts
% p: structure containing simulation parameters that must have fields:
%   p.noiseType: camera noise distribution ('poiss','norm','user','none','hirsch')
%   p.camNoise: [1-by-6] distribution parameters
%   p.sat: saturation pixel value calculated from camera bit rate
%
% dat_noisy: data vector or matrix containing camera-detected image counts
% err: potential error message

% Last update: 29.11.2019 by MH
% >> move script that add camera noise from plotExample.m to this separate 
%  file; this allows to call the same script from createVideoFrame.m and 
%  createIntensityTraces, preventing unilateral modifications
%
% update: 7th of March 2018 by Richard Börner
% >> Comments adapted for Boerner et al 2017
% >> Noise models adapted for Boerner et al 2017.
% >> Simulation default parameters adapted for Boerner et al 2017.

% initialize returned arguments
dat_noisy = [];
err = '';

% collect camera parameters
switch p.noiseType
    case 'poiss'
        noiseCamInd = 1;
    case 'norm'
        noiseCamInd = 2;
    case 'user'
        noiseCamInd = 3;
    case 'none'
        noiseCamInd = 4;
    case 'hirsch'
        noiseCamInd = 5;
    otherwise
        err = 'Unknown camera noise distribution';
        return
end
noisePrm = p.camNoise(noiseCamInd,:);

[mu_y_dark,K,eta] = getCamParam(p.noiseType,p.camNoise);

switch p.noiseType

    case 'poiss' % Poisson or P-model from Börner et al. 2017
        
        % EDIT MH: if I understood correctly, the Poisson noise regards only the
        % production of photoelectrons, therefore, the mu_y_dark should not be
        % taken into account for the generation of Poisson noise.
        % add noise for photoelectrons (no mu_y_dark here)
        % (PC-->EC)
        dat_noisy = random('poiss', eta*dat);
        
        % convert to EC (conversion yields basically wrong ec or ic as the 
        % conversion factor photons to imagecounts is only valid for N, 
        % NExpN and PGN model)
        % EDIT MH: add mu_y_dark for conversion to IC
        % add camera mu_y_dark
        % (EC-->IC)
        dat_noisy = K*dat_noisy + mu_y_dark;

    case 'norm' % Gaussian, Normal or N-model from Börner et al. 2017
        % PC are not Poisson distributed here.
        % model parameters
        % EDIT MH: Here the mu_y_dark participates to the generation of noise 
        % (according to PONE)
        sig_d = noisePrm(2);
        sig_q = noisePrm(4);
        
        % (PC-->IC)
        mu_y = phtn2arb(dat,mu_y_dark,K,eta);
        
        % calculate noise width in EC, Gaussian width
        % ASSUMPTION (no units conversion, just value assignment)
        % (EC) 
        sig_pe = sqrt(eta*dat); 
        
        % (EC-->IC)
        sig_y = sqrt((K*sig_d)^2 + (sig_q^2) + (K*sig_pe).^2);
        
        % add Gaussian noise
        % (IC)
        dat_noisy = random('norm', mu_y, sig_y);
        
    case 'user' % User defined or NExpN-model from Börner et al. 2017
        
        % model parameters
        % EDIT MH: Here the mu_y_dark participates to the generation of noise 
        % (according to PONE)
        A = noisePrm(2); % CIC contribution
        sig0 = noisePrm(4); % read-out noise width
        tau = noisePrm(6); % CIC decay

        % convert to IC (PC-->IC)
        dat_noisy = phtn2arb(dat, mu_y_dark, K, eta);

        % calculate noise distribution and add noise (IC)
        dat_noisy = rand_NexpN(dat_noisy, A, tau, sig0);
        
    case 'none' % None, no camera noise but possible camera mu_y_dark value

        % no noise but mu_y_dark in IC (accroding to PONE) 
        % (PC-->IC)
        dat_noisy = phtn2arb(dat, mu_y_dark, K, eta);
        
    case 'hirsch' % Hirsch or PGN- Model from Hirsch et al. 2011
       
        % model parameters
        % EDIT MH: Here the mu_y_dark participates to the generation of noise 
        % (according to PONE)
        
        s_d = noisePrm(2); 
        CIC = noisePrm(4);
        g = noisePrm(5); % change 2018-08-03
        s = noisePrm(6);
        
        % Poisson noise of photo-electrons + CIC 
        % (PC-->EC)
        dat_noisy = random('poiss', eta*dat+CIC);
        
        % Gamma amplification noise, composition 
        % (EC)
        dat_noisy = random('gamma', dat_noisy, g);
        
        % Gausian read-out noise, composition 
        % (EC-->IC)
        dat_noisy = random('norm', dat_noisy/s + mu_y_dark, s_d*K);
        
end

% Correction of out-of-range values.
% Due to noise calculated values out of the detection range 0 <= 0I <= bitrate. 
dat_noisy(dat_noisy<0) = 0;
dat_noisy(dat_noisy>p.sat) = p.sat;
