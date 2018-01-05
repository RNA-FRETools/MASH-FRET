function [mix]=get_gmm_mix(x,start_guess)
%   function [mix]=get_gmm_mix(x,ncentres,D)
%
%   get_gmm_mix initializes the gaussian centers that will be used in the
%   continuous hidden markov model analysis. The centers are first
%   initialized using a hard k-means algorithm, then they are further 
%   initialized using a soft k-means algorithm (EM algorithm). The time 
%   dimension of the data is collapsed for this initialization and the data
%   is analyzed as a gaussian mixture model. The functions called in this
%   function, gmm, gmminit, gmmem are all from netlab.
% 
%   mix is a structure defined as follows
%	  type = 'gmm'
%	  nin = the dimension of the space
%	  ncentres = number of mixture components
%	  covartype = string for type of variance model
%	  priors = mixing coefficients
%	  centres = means of Gaussians: stored as rows of a matrix
%	  covars = covariances of Gaussians
%     note: x must be TxD, where T = number of time steps and D = dimension
%     of data
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

[ncentres D] = size(start_guess);

% PARAMETERS for gmminit
options = [0,1e-4,1e-4,1e-6,0,0,0,0,0,0,0,0,0,0,0,1e-8,0.1,0];

%turn off messages
options(1) = -1;
% OPTIONS(3) is a measure of the precision required of the error
% function at the solution.  If the absolute difference between the
% error functions between two successive steps is less than OPTIONS(3),
% then this condition is satisfied. Both this and the previous
% condition must be satisfied for termination.
options(3) = 0.1; 
% maximum number of EM iterations
options(14) = 10;
% OPTIONS(5) is set to 1 if a covariance matrix is reset to its
% original value when any of its singular values are too small (less
% than MIN_COVAR which has the value eps).   With the default value of
% 0 no action is taken.
options(5)=1;

% Make blank mix structure
if D==1
    mix = gmm(D, ncentres, 'spherical'); 
else
    mix = gmm(D, ncentres, 'full'); 
end

% Set mix.centres to starting guess
mix.centres = start_guess;
 
% initialize with hard K-means algorithm
mix = vbfret_gmminit(mix, x, options);

% initialize with soft K-means (EM)
[mix, options, errlog] =  gmmem(mix, x, options);

if D==1
    mix.covars=reshape(mix.covars,[1 1 ncentres]);
end