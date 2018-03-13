function dat = rand_PGN(varargin)
%
% Generate random numbers from a user-designed distribution
%
% "varargin" >> 1. [n-by-m] data matrice
%               2. 
%               3. 
%                  
%               4. 
%               5.
%               6.
%
% "dat" >> [n-by-m] random numbers
%
% Requires
%
% Created the 5th of December 2017 by Richard Börner for Börner et al.


if nargin < 6
    dat = zeros(1,N);

    g = 300;
    sig_d  = 0.067;
    mu_y_dark = 113;
    CIC = 0.067;
    s = 5.199;
    eta = 0.95;
    
else
    dat = varargin{1};
    
    g = varargin{2};
    sig_d  = varargin{3};
    mu_y_dark = varargin{4};
    CIC = varargin{5};
    s = varargin{6};
    eta = varargin{7};
    
end

dat_val = unique(dat(:));

for i = 1:numel(dat_val)

    mu = dat_val(i);
%     o = sig0 + a*(mu^expnt);
    o = sig0;
    
    if o > 0
        x = (mu-10*o):o/10:(mu+100*(o+2*tau));
     
        P = 0.5*(1+erf((x-mu)/(o*sqrt(2)))).*(A*exp(-(x-mu)/tau)) + ...
            (1-0.5*A*(1+erf((x-mu)/(o*sqrt(2))))).*exp(-((x-mu).^2)/(2*(o^2)));

        P = (1-A)*
        dat(dat==mu) = randsample(x, numel(dat(dat==mu)), true, P);
        

    else
        dat(dat==mu) = mu*ones(numel(dat(dat==mu)),1);
    end
    
%     Ptot = @(o,I0,q,c,f,nic,g) (1/sqrt(2*pi*o))*exp(-(I0*q+c)-((f*nic)^2)/(2*(o^2)))+(2/g)*chi2pdf(2*(I0*q+c),4.2*f*nic/g);
%     G = @(noe,nie,g) (noe^(nie-1))*exp(-noe/g)/(gamma(nie)*(g^nie));
%     P = @(nie,c) exp(-c)*(c^nie)/factorial(nie);
%     N = @(fnic,noe,r) normpdf(fnic,noe,r);
%     Pdark = @(nic,noe,nie,g,f,r) (P(nie,G(noe,nie,g))*N(f*nic,noe,r))*(f*nic);
end
