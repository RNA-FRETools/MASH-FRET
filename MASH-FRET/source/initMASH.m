function initMASH(h_fig, figName)
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

% Last update: 29.11.2019 by MH
% >> cancel font size setting (done when building figure programmatically)
% >> reformat code and comments for mor clarity
%
% Update: 22nd of May 2014 by Mélodie C.A.S. Hadzic

% default
ohfig = 0.75; % figures' outer height (normalized units)
def_ask = true; % ask user before overwriting files

% cancelled by MH, 29.11.2019
% setProp(get(h_fig, 'Children'), 'FontUnits', 'pixel');
% setProp(get(h_fig, 'Children'), 'FontSize', 11);
%
% set([h_mainPan,h.uipanel_TA_clusters,h.uipanel_TA_results,...
%     h.uipanel_TA_transitions,h.uipanel_TA_fittingParameters,...
%     h.uipanel_HA_method,h.uipanel_HA_thresholding,...
%     h.uipanel_HA_gaussianFitting,h.uipanel_HA_fittingParameters,...
%     h.uipanel_VP_spotfinder,h.uipanel_VP_coordinatesTransformation,...
%     h.uipanel_S_photophysics,h.uipanel_S_cameraSnrCharacteristics,...
%     h.uipanel_S_thermodynamicModel],'FontUnits','pixels','FontSize',12);
%
% set([h.axes_TDPplot1,h.axes_TDPplot2,h.axes_top,h.axes_topRight, ...
%     h.axes_bottom,h.axes_bottomRight],'FontUnits','pixels','FontSize',11);

% initialization of parameters
if ~setParam(h_fig)
    close all force;
    return
end

% add help buttons (parameters must be initialized)
h = guidata(h_fig);
h_mainPan = [h.uipanel_TA_transitionDensityPlot,...
    h.uipanel_TA_stateConfiguration,h.uipanel_TA_stateTransitionRates,...
    h.uipanel_HA_histogramAndPlot,h.uipanel_HA_stateConfiguration,...
    h.uipanel_HA_statePopulations,h.uipanel_TP_denoising,...
    h.uipanel_TP_photobleaching,h.uipanel_TP_subImages,h.uipanel_TP_plot...
    h.uipanel_TP_backgroundCorrection,h.uipanel_TP_findStates, ...
    h.uipanel_TP_factorCorrections,h.uipanel_TP_sampleManagement, ...
    h.uipanel_VP_plot,h.uipanel_VP_experimentSettings,...
    h.uipanel_VP_editAndExportVideo,h.uipanel_VP_moleculeCoordinates,... 
    h.uipanel_VP_intensityIntegration,h.uipanel_S_videoParameters, ...
    h.uipanel_S_molecules,h.uipanel_S_experimentalSetup,...
    h.uipanel_S_exportOptions];
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
set(h_fig, 'Name', figName,'OuterPosition',[oxfig,oyfig,owfig,ohfig]);

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

% add zoom and pan objects
h.TTpan = pan(h_fig);
h.TTzoom = zoom(h_fig);
set(h.TTpan, 'Enable', 'off');
set(h.TTzoom, 'Enable', 'off');

% build and add context menus
h_ZMenu = uicontextmenu('Parent', h_fig);
uimenu('Parent', h_ZMenu, 'Label', 'Reset to original view', ...
    'Callback', {@ud_zoom, 'reset', h_fig});
h.zMenu_zoom = uimenu('Parent', h_ZMenu, 'Label', 'Zoom tool', ...
    'Callback', {@ud_zoom, 'zoom', h_fig}, 'Checked', 'on');
h.zMenu_pan = uimenu('Parent', h_ZMenu, 'Label', 'Pan tool', ...
    'Callback', {@ud_zoom, 'pan', h_fig}, 'Checked', 'off');
h.zMenu_exp = uimenu('Parent', h_ZMenu, 'Label', 'Export graph', ...
    'Callback', {@exportAxes, h_fig});
h.zMenu_target = uimenu('Parent', h_ZMenu, 'Label', 'Target centroids', ...
    'Callback', {@ud_zoom, 'target', h_fig}, 'Checked', 'off', 'Enable', ...
    'off');
set(h.TTzoom, 'ActionPostCallback', {@ud_axesLim, h_fig}, ...
    'RightClickAction', 'PostContextMenu', 'UIContextMenu', h_ZMenu);
set(h.TTpan, 'ActionPostCallback', {@ud_axesLim, h_fig}, ...
    'UIContextMenu', h_ZMenu);
set(h.TTzoom, 'Enable', 'on');

% save handle structure
guidata(h_fig, h);

% actualize control properties
updateFields(h_fig);

% changed by MH, 29.11.2019
% switchPan(h.togglebutton_VP, [], h);
switchPan(h.togglebutton_VP, [], h_fig);

