function dat = rand_gNexp(varargin)
% function dat = gaussNexp_dtrb(varargin)
%
% Generate random numbers from a user-designed distribution
%
% "varargin" >> 1. [n-by-m] data matrice
%               2. Exponential weight "A"
%               3. Gaussian width exponent "expnt"
%                  sigma = I_0^exp_sigma
%               4. Exponential decay constant "tau"
%
% "dat" >> [n-by-m] random numbers

% Created the 23rd of April 2014 by Mélodie C.A.S Hadzic
% Last update: the 4th of June 2014 by Mélodie C.A.S Hadzic

if nargin < 6
    N = 4000;
    dat = zeros(1,N);
    A = 0.03;
    expnt = 0.405;
    tau = 54;
    a = 0;
    sig0 = 16;
else
    dat = varargin{1}; % I_therm + I_tot + bg
    A = varargin{2};
    expnt = varargin{3};
    tau = varargin{4};
    a = varargin{5};
    sig0 = varargin{6}; % sig_bg
end

dat_val = unique(dat(:));

for i = 1:numel(dat_val)

    mu = dat_val(i);
%     o = sig0 + a*(mu^expnt);
    o = sig0;
    
    if o > 0
        x = (mu-10*o):o/10:(mu+100*(o+2*tau));
%         filt = erf((x-mu)/sqrt(2)*o);
%         filt(filt<0) = 0;
%         
%         P = A*filt.*exp(-(x-mu)/tau) + (1-filt*A).*exp(-((x-mu).^2)/(2*o^2));
        
        P = 0.5*(1+erf((x-mu)/(o*sqrt(2)))).*(A*exp(-(x-mu)/tau)) + ...
            (1-0.5*A*(1+erf((x-mu)/(o*sqrt(2))))).*exp(-((x-mu).^2)/(2*(o^2)));

        dat(dat==mu) = randsample(x, numel(dat(dat==mu)), true, P);
        
%         figure; axes;
%         plot(x,P);
%         pouet = 0;
    else
        dat(dat==mu) = mu*ones(numel(dat(dat==mu)),1);
    end
    
%     Ptot = @(o,I0,q,c,f,nic,g) (1/sqrt(2*pi*o))*exp(-(I0*q+c)-((f*nic)^2)/(2*(o^2)))+(2/g)*chi2pdf(2*(I0*q+c),4.2*f*nic/g);
%     G = @(noe,nie,g) (noe^(nie-1))*exp(-noe/g)/(gamma(nie)*(g^nie));
%     P = @(nie,c) exp(-c)*(c^nie)/factorial(nie);
%     N = @(fnic,noe,r) normpdf(fnic,noe,r);
%     Pdark = @(nic,noe,nie,g,f,r) (P(nie,G(noe,nie,g))*N(f*nic,noe,r))*(f*nic);
end


