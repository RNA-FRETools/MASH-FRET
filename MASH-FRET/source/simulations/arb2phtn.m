function dat = arb2phtn(varargin)

% Created the 23rd of April 2014 by Mélodie C.A.S Hadzic
% Last update: 14th of March 2018 by Richard Börner
%
% Comments adapted for Boerner et al 2017

dat = varargin{1};

if size(varargin,2)==3
    K = varargin{2};
    eta = varargin{3};
elseif size(varargin,2)==2
    eta = varargin{2};
    K = 57.7;
else
    eta = 0.95;
    K = 57.7;
end

offset = 0; % offset implemented in camera noise model. Do not change!

dat = (dat - offset)/(K*eta); % offset implemented in camera noise model. Do not change!


