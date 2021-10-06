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
def_ask = true; % ask user before overwriting files

% initialization of parameters
if ~setParam(h_fig)
    close all force;
    return
end

% add help buttons (parameters must be initialized)
h = guidata(h_fig);
h_Span = [h.uipanel_S_videoParameters,h.uipanel_S_molecules,...
    h.uipanel_S_experimentalSetup,h.uipanel_S_exportOptions];
h_VPpan = [h.uipanel_VP_editAndExportVideo,...
    h.uipanel_VP_moleculeCoordinates,h.uipanel_VP_intensityIntegration];
h_TPpan = [h.uipanel_TP_sampleManagement,...
    h.uipanel_TP_plot,h.uipanel_TP_subImages,...
    h.uipanel_TP_backgroundCorrection,h.uipanel_TP_crossTalks,...
    h.uipanel_TP_denoising,h.uipanel_TP_photobleaching,...
    h.uipanel_TP_factorCorrections,h.uipanel_TP_findStates];
h_HApan = [h.uipanel_HA_histogramAndPlot,h.uipanel_HA_stateConfiguration,...
    h.uipanel_HA_statePopulations];
h_TApan = [h.uipanel_TA_transitionDensityPlot,...
    h.uipanel_TA_stateConfiguration,h.uipanel_TA_dtHistograms,...
    h.uipanel_TA_kineticModel];
h_mainPan = [h_Span,h_VPpan,h_TPpan,h_HApan,h_TApan];
h.pushbutton_help = setInfoIcons([h_mainPan,h.axes_example_hist,...
    h.pushbutton_saveProj,h.axes_topRight,h.axes_hist1],h_fig,...
    h.param.infos_icon_file,h.charDimTable);

% normalize units of all controls (help buttons must be created)
setProp([h_fig; get(h_fig, 'Children')], 'Units', 'normalized');

% add panel collapse/expand buttons and collapse all expendanble panels (after units normalization)
h_butS = setPanCllpsButtons(h_Span,h_fig);
h_butVP = setPanCllpsButtons(h_VPpan,h_fig);
h_butTP = setPanCllpsButtons(h_TPpan,h_fig);
h_butHA = setPanCllpsButtons(h_HApan,h_fig);
h_butTA = setPanCllpsButtons(h_TApan,h_fig);
collapsePanel(h_butS);
collapsePanel(h_butVP);
collapsePanel(h_butTP);
collapsePanel(h_butHA);
collapsePanel(h_butTA);
h.pushbutton_panelCollapse = [h_butS,h_butVP,h_butTP,h_butHA,h_butTA];

% set all axes invisible
h_axes = [h.axes_example_hist,h.axes_example,h.axes_example_mov,...
    h.cb_example_mov,h.axes_movie,h.colorbar,h.axes_top,h.axes_topRight,...
    h.axes_bottom,h.axes_bottomRight,h.axes_hist1,h.axes_hist2,...
    h.axes_thm_BIC,h.axes_TDPplot1,h.colorbar_TA,h.axes_tdp_BIC,...
    h.axes_TDPplot2];
set(h_axes,'visible','off');

% recover root folder from default parameters and add to handle structure
cd(h.param.folderRoot);
set(h.edit_rootFolder, 'String', h.param.folderRoot);

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
h = guidata(h_fig);
mute_prev = h.mute_actions;
h.mute_actions = true;
guidata(h_fig, h);
switchPan(h.togglebutton_VP, [], h_fig);
h = guidata(h_fig);
h.mute_actions = mute_prev;
guidata(h_fig, h);
