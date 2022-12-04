function exp_bg = expBackground(frame,dir,timeaxis,bg,amp,cst)
% Generate background exponentially decaying or increasing in time.
%
% frame: frame index at which the background intensity should be calculated and returned (or 'all' to return background for all time axis)
% dir: background variation ('increasing' or 'decreasing')
% timeaxis: [1-by-L] time points in the trace (in time units)
% bg: initial background intensity (in counts)
% amp: multiplication factor for initial intensity
% cst: exponential time constant (in time units)
%
% exp_bg: exponentially decaying or increasing background

% Last update: 29.11.2019 by MCASH
% >> write script to this separate file to allow call from 
%    createIntensityTraces.m and createVideoFrame.m, preventing unilateral 
%    modifications

if strcmp(dir,'increase')
    exp_bg = amp*exp(-flip(timeaxis,1)/cst);
else
    exp_bg = amp*exp(-timeaxis/cst);
end

if strcmp(frame,'all')
    exp_bg = bg*(1+exp_bg);
else
    exp_bg = bg*(1+exp_bg(frame));
end
