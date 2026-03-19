function [n_ic,err] = addCameraNoise(I,prm)
% [dat_noisy,err] = addCameraNoise(dat,prm)
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
% prm: simulation parameters
% dat_noisy: data vector or matrix containing camera-detected image counts
% err: potential error message

% update 29.11.2019 by MH: move script that add camera noise from plotExample.m to this separate file; this allows to call the same script from createVideoFrame.m and createIntensityTraces, preventing unilateral modifications
% update 7.3.2018 by Richard Börner: (1) Comments adapted for Boerner et al 2017 (2) Noise models adapted for Boerner et al 2017. (3) Simulation default parameters adapted for Boerner et al 2017.

% initialize returned arguments
n_ic = [];
err = '';

% collect parameters
noisetype = prm.gen_dat{1}{2}{4};
noiseprm = prm.gen_dat{1}{2}{5};
sat = prm.gen_dat{1}{2}{5}(2,6);

% collect camera parameters
switch noisetype
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
noisePrm = noiseprm(noiseCamInd,:);

[b,K,q] = getCamParam(noisetype,noiseprm);

switch noisetype

    case 'poiss' % Poisson or P-model from Börner et al. 2017
        
        % EDIT MH: if I understood correctly, the Poisson noise regards only the
        % production of photoelectrons, therefore, the offset_ic should not be
        % taken into account for the generation of Poisson noise.
        % add noise for photoelectrons (no offset_ic here)
        % (PC-->EC)
        n_pc = random('poiss', q*I);
        
        % convert to EC (conversion yields basically wrong ec or ic as the 
        % conversion factor photons to imagecounts is only valid for N, 
        % NExpN and PGN model)
        % EDIT MH: add offset_ic for conversion to IC
        % add camera offset_ic
        % (EC-->IC)
        n_ic = K*n_pc + b;

    case 'norm' % Gaussian, Normal or N-model from Börner et al. 2017
        % PC are not Poisson distributed here.
        % model parameters
        % EDIT MH: Here the offset_ic participates to the generation of noise 
        % (according to PONE)
        sig_pc_d = noisePrm(2);
        sig_ic_q = noisePrm(4);
        
        % (PC-->IC)
        mu_ic = phtn2arb(I,b,K,q);
        
        % calculate noise width in EC, Gaussian width
        % ASSUMPTION (no units conversion, just value assignment)
        % (EC) 
        sig_pc = sqrt(q*I); 
        
        % (EC-->IC)
        sig_ic = sqrt((K*sig_pc_d)^2 + (sig_ic_q^2) + (K*sig_pc).^2);
        
        % add Gaussian noise
        % (IC)
        n_ic = random('norm', mu_ic, sig_ic);
        
    case 'user' % User defined or NExpN-model from Börner et al. 2017
        
        % model parameters
        % EDIT MH: Here the offset_ic participates to the generation of noise 
        % (according to PONE)
        A = noisePrm(2); % CIC contribution
        sig_ic = noisePrm(4); % read-out noise width
        tau_ic = noisePrm(6); % CIC decay

        % convert to IC (PC-->IC)
        n_ic = phtn2arb(I, b, K, q);

        % calculate noise distribution and add noise (IC)
        n_ic = rand_NexpN(n_ic, A, tau_ic, sig_ic);
        
    case 'none' % None, no camera noise but possible camera offset_ic value

        % no noise but offset_ic in IC (accroding to PONE) 
        % (PC-->IC)
        n_ic = phtn2arb(I, b, K, q);
        
    case 'hirsch' % Hirsch or PGN- Model from Hirsch et al. 2011
       
        % model parameters (notation as in Hirsh et. al. 2011)
        % I light intensity (pc)
        % b bias offset (ic)
        % q detector quantum efficiency (ec/pc)
        r = noisePrm(2); % readout noise (ec) s_d
        c = noisePrm(4); % spurious charge (ec) CIC
        g = noisePrm(5); % EM register gain (ec/pc)
        f = noisePrm(6); % analog-to-digital factor (ec/ic) s
        
        % Poisson noise of photo-electrons + poisson noise of supurious charge 
        % (PC-->EC)
        n_ie = random('poiss', q*I+c); % nb. of input e- in the EM register
        
        % Gamma amplification noise, composition 
        % (EC)
        n_oe = random('gamma', n_ie, g); % nb. of output e- from the EM register
        
        % Gausian read-out noise, composition 
        % (EC-->IC)
        n_ic = random('norm', n_oe/f + b, r*K);
        
end

% Correction of out-of-range values.
% Due to noise calculated values out of the detection range 0 <= 0I <= bitrate. 
n_ic(n_ic<0) = 0;
n_ic(n_ic>sat) = sat;
