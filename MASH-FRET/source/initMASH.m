function initMASH(h_fig)
% Set default parameters with file 'default_param.ini'
% Create help buttons
% Normalize all dimensions
% Position window on screen
% Open action panel
% Make all axes invisible
% Recover and set root foler
% Reset file overwriting parameters
% Create context menu (from right click) with zoom, pan, export graph and target centroids (in k-mean clustering) options.
% Actualize properties of all uicontrols according to default parameters
%
% Requires external functions: updateActPan, setProp, actionPanel,
%                              setParam, updateFields, ud_zoom, exportAxes,
%                              ud_axesLim, setInfoIcons, switchPan

% Last update, 29.11.2019 by MH: (1) cancel font size setting (done when building figure programmatically) (2) reformat code and comments for mor clarity
% update, 22.5.2014 by MH

% default
ohfig = 0.75; % figures' outer height (normalized units)
def_ask = true; % ask user before overwriting files

% initialization of parameters
if ~setParam(h_fig)
    close all force;
    return
end

% add help buttons (parameters must be initialized)
h = guidata(h_fig);
h_mainPan = [h.uipanel_TA_transitionDensityPlot,...
    h.uipanel_TA_stateConfiguration,h.uipanel_TA_stateLifetimes,...
    h.uipanel_TA_kineticModel,h.uipanel_HA_histogramAndPlot,...
    h.uipanel_HA_stateConfiguration,h.uipanel_HA_statePopulations,...
    h.uipanel_TP_denoising,h.uipanel_TP_photobleaching,...
    h.uipanel_TP_subImages,h.uipanel_TP_plot ...
    h.uipanel_TP_backgroundCorrection,h.uipanel_TP_crossTalks ...
    h.uipanel_TP_findStates,h.uipanel_TP_factorCorrections,...
    h.uipanel_TP_sampleManagement,h.uipanel_VP_plot,...
    h.uipanel_VP_experimentSettings,h.uipanel_VP_editAndExportVideo,...
    h.uipanel_VP_moleculeCoordinates,h.uipanel_VP_intensityIntegration,...
    h.uipanel_S_videoParameters,h.uipanel_S_molecules,...
    h.uipanel_S_experimentalSetup,h.uipanel_S_exportOptions];
h.pushbutton_help = setInfoIcons([h_mainPan,h.axes_example_hist,...
    h.pushbutton_loadMov,h.pushbutton_traceImpOpt,h.axes_topRight,...
    h.pushbutton_thm_impASCII,h.axes_hist1,h.pushbutton_TDPimpOpt],...
    h_fig,h.param.movPr.infos_icon_file,h.charDimTable);

% normalize units of all controls (help buttons must be created)
setProp([h_fig; get(h_fig, 'Children')], 'Units', 'normalized');

% position MASH figure
opos = get(h_fig,'outerposition');
owfig = opos(3)*ohfig/opos(4);
oxfig = (1-owfig)/2;
oyfig = 1-ohfig;
set(h_fig,'OuterPosition',[oxfig,oyfig,owfig,ohfig]);

% build and add control panel figure (the main figure must be positionned)
h.figure_actPan = actionPanel(h_fig);

% set all axes invisible
h_axes = [h.axes_example_hist,h.axes_example,h.axes_example_mov,...
    h.cb_example_mov,h.axes_movie,h.colorbar,h.axes_top,h.axes_topRight,...
    h.axes_bottom,h.axes_bottomRight,h.axes_hist1,h.axes_hist2,...
    h.axes_thm_BIC,h.axes_TDPplot1,h.colorbar_TA,h.axes_tdp_BIC,...
    h.axes_TDPplot2];
set(h_axes,'visible','off');

% recover root folder from default parameters and add to handle structure
h.folderRoot = h.param.movPr.folderRoot;
cd(h.folderRoot);
set(h.edit_rootFolder, 'String', h.folderRoot);

% add default overwriting settings
h.param.OpFiles.overwrite_ask = def_ask;
h.param.OpFiles.overwrite = ~def_ask;

% add action muting option
h.mute_actions = false;

% build zoom context menu
h = buildContextmenu_zoom(h);

% build project context menu
h = buildContextmenu_proj(h);

% save handle structure
guidata(h_fig, h);

% build and configure pointer manager
iptPointerManager(h_fig,'enable');
pb.enterFcn = [];
pb.traverseFcn = @axes_TDPplot1_traverseFcn;
pb.exitFcn = @axes_TDPplot1_exitFcn;
iptSetPointerBehavior(h.axes_TDPplot1,pb);

% actualize control properties
updateFields(h_fig);

% show module Video processing
switchPan(h.togglebutton_VP, [], h_fig);

