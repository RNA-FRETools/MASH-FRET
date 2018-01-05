function sd = w1_noise(w1)
%% Estimate the standard deviation of noise from wavelet at scale = 1
% assum noise is Gaussian distribution, std of noise can be best estimated
% from w1 by counting.
% x ~ N(0, sig), then median of x is close to 0, and 34.1% away from median
% is about sig
% for abs(x), 68.2% away from the min is about the sig
y = abs(w1);
y = sort(y);
sd = y(round(0.682*numel(w1)));
% even for poisson distribution, as long as lambda >= 1, the median is
% almost = lambda. So, still can use counting method.
end