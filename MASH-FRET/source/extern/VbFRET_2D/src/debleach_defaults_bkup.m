function [debleach] = debleach_defaults_bkup()
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% creates a handle, debleach, containing all default settings for how to
% truncate traces due to photobleaching.

%1 = 1D transformed 
%2 = Single channel 
%3 = Summed channel
debleach.type = 1;

%truncate data when first data point is greater than 1 or 0 by this much:
debleach.cutoff_1D = 0.1;

%truncate data when channel 1 or channel 2 first falls below:
debleach.cutoff_either = 1;

%truncate data when channel 1 or channel 2 first falls below:
debleach.cutoff_sum = 300;

%smooth data 0 = no, 1 = yes
debleach.smooth = 0;

%how many time steps will the data be smoothed over
debleach.smooth_steps = 2;

%make non-zero if you want delete extra data points before the first
%identified photobleached data point.
debleach.xtra = 2;

%minimum trace length that is allowed to be analyzed
debleach.min_length = 25;