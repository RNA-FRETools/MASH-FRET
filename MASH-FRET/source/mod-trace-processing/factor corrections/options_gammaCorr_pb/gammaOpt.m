function gammaOpt(h_fig)
% options for photobleaching based gamma correction

% last update: MH, 15.1.2020 (separate process from MASH's main plot, add axes for traces and data list for photoblaching detection)
% update: FS, 12.1.2018

% display action
setContPan(['Openning options for photobleaching-based gamma factor ',...
    'calculations...'],'process',h_fig);

% build figure
h_fig2 = buildGammaOpt(h_fig);

% set defaults option parameters
setDefPrm_gammaOpt(h_fig,h_fig2);

% update calculations and panel
ud_pbGamma(h_fig,h_fig2);

% display action
setContPan(['Options for photobleaching-based gamma factor calculations ',...
    'are now opened!'],'success',h_fig);