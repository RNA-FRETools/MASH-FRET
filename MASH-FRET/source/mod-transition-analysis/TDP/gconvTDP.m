function TDP = gconvTDP(TDP,lim,bin)

% defaults
var_ref = 0.0005; % variance adapted for a binning of 0.01
bin_ref = 0.01;

% re-scale variance for intensity data (large numbers)
var = var_ref;
if lim(2)>2
    var = (bin*sqrt(var_ref)/bin_ref)^2;
end

% Gaussian filter
TDP = convGauss(TDP, [var,var], [lim;lim]);