function dat = rand_NexpN(varargin)

% old function dat = rand_gNexp(varargin) 
% old function dat = gaussNexp_dtrb(varargin)
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

% Last update: 2.4.2019 by MH
% >> reduce input data precision to 1 ic in order to save calculation time
%
% update: 7th of March 2018 by Richard Börner for Boerner et al.
% >> Comments adapted for Boerner et al 2017
%
% update: the 4th of June 2014 by Mélodie C.A.S Hadzic
%
% Created the 23rd of April 2014 by Mélodie C.A.S Hadzic

if nargin < 4
    N = 4000;
    dat = zeros(1,N);
    A = 0.03;
    tau = 54;
    sig0 = 16;
else
    dat = varargin{1};
    A = varargin{2};
    tau = varargin{3};
    sig0 = varargin{4};
end

% added by MH, 2.4.2019
% reduce input data precision to integers: computation time from 4h to 20min
dat = round(dat);

dat_val = unique(dat(:));

for i = 1:numel(dat_val)
    
    % in ec
    mu = dat_val(i);
   
    o = sig0;
    
    if o > 0
        
        % cancelled by MH, 2.4.2019
%         % to reduce calculation time, use the same distribution if values
%         % differ less than 1 ec.
%         if i==1 || (i>1 && (mu-mu_ref)>1)

            x = (mu-10*o):o/10:(mu+100*(o+2*tau));

            % first model, old
    %           P = 0.5*(1+erf((x-mu)/(o*sqrt(2)))).*(A*exp(-(x-mu)/tau)) + ...
    %             (1-0.5*A*(1+erf((x-mu)/(o*sqrt(2))))).*exp(-((x-mu).^2)/(2*(o^2)));
            % second model, Boerner et al. PONE 2018
                P = (1-A)*(1/(sqrt(2*pi)*o))*exp(-((x-mu).^2)/(2*(o^2))) + ... 
                  0.5*A*exp((o^2)/(2*(tau^2))-(x-mu)./tau).*(1-erf(o/(sqrt(2)*tau)-(x-mu)./(sqrt(2)*o)));
              P = P(P>1E-6);
              x = x(P>1E-6);
              
              % cancelled by MH, 2.4.2019
%               mu_ref = mu;
%         end
        dat(dat==mu) = randsample(x, numel(dat(dat==mu)), true, P);
        
    else
        dat(dat==mu) = mu*ones(numel(dat(dat==mu)),1);
    end
    
end


