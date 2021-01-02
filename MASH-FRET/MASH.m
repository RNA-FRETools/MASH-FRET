function varargout = MASH(varargin)

% add source folders to MATLAB search path
disp('set MATLAB search path...')
codePath = fileparts(mfilename('fullpath'));
addpath(genpath(codePath));

% set MATLAB's character encoding
feature('DefaultCharacterSet','windows-1252');

% compile C functions
disp('checking mex files...');
checkMASHmex

disp('build GUI...')
% get MASH version
version_str = getMASHversion(codePath);

% define figure name from MASH-FRET version
figName = sprintf('%s %s','MASH-FRET', version_str);

% build MASH-FRET graphical interface
h_fig = buildMASHfig(figName);

% initialize main figure
disp('initialize GUI..')
initMASH(h_fig);

% make main figure visible
set(h_fig,'visible','on');

if nargout==1
    varargout = h_fig;
end

disp('MASH-FRET is ready !')

