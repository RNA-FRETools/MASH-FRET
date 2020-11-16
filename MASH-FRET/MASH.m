function h_fig = MASH(varargin)

% add source folders to MATLAB search path
disp('set MATLAB search path...')
codePath = fileparts(mfilename('fullpath'));
addpath(genpath(codePath));

% set MATLAB's character encoding
feature('DefaultCharacterSet','windows-1252');

% get MATLAB version
disp('get MASH-FRET version...')
version_str = getMASHversion(codePath);

% define figure name from MASH-FRET version
figName = sprintf('%s %s','MASH-FRET', version_str);

% build MASH-FRET graphical interface
disp('build GUI...')
h_fig = buildMASHfig(figName);

% initialize main figure
disp('initialize GUI..')
initMASH(h_fig);

% make main figure visible
set(h_fig,'visible','on');

