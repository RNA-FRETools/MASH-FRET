function dat = arb2phtn(dat,offset,K,eta)

% Created the 23rd of April 2014 by Mélodie C.A.S Hadzic
% Last update: 12th of March 2019 by Mélodie Hadzic
% >> obligates to give offset, K and eta values in input
%
% update: 14th of March 2018 by Richard Börner
% >> Comments adapted for Boerner et al 2017

dat = (dat - offset)/(K*eta); 

