function h_fig = MASH(varargin)

% add source folders to MATLAB search path
codePath = fileparts(mfilename('fullpath'));
addpath(genpath(codePath));

% get MATLAB version
version_str = getMASHversion(codePath);

% define figure name from MASH-FRET version
figName = sprintf('%s %s','MASH-FRET', version_str);

% build MASH-FRET graphical interface
h_fig = buildMASHfig(figName);

% initialize main figure
initMASH(h_fig);

% make main figure visible
set(h_fig,'visible','on');

