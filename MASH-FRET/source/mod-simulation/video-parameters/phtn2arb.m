function dat = phtn2arb(dat,offset,K,eta)
% Convert photon counts to image counts

% Created the 23rd of April 2014 by M�lodie C.A.S Hadzic
% Last update: 12th of March 2019 by M�lodie Hadzic
% >> obligates to give offset, K and eta values in input
%
% update: 147th of March 2018 by Richard B�rner
% >> Comments adapted for Boerner et al 2017

dat = offset + dat*eta*K; 


