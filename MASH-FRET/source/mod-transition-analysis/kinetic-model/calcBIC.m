function BIC = calcBIC(mdl)
% BIC = calcBIC(mdl)
%
% Calculate bayesian information criterion from model parameters.
%
% mdl: model parameters and fit results structure with fields:
%   mdl.schm: [D+2-by-D+2] reaction scheme
%   mdl.N: total count in fitted histogram
%   mdl.logL: log-likelihood
% BIC: bayesian nformation criterion

nfp = sum(sum(mdl.schm))-1;
BIC = nfp*log(mdl.N)-2*mdl.logL;