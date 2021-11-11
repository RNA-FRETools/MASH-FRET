function dat = ele2phtn(dat,K,eta)
% Convert electron counts to photon counts

% Created the 18th of March 2019 by Mélodie Hadzic

dat = round(dat/(K*eta)); 