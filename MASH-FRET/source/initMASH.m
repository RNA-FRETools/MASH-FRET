function initMASH(obj, h, figName)
% Normalize all dimensions
% Set font sizes
% Position window on screen
% Set default parameters with file 'default_param.ini'
% Actualize properties of uicontrols according to parameters
% Create context menu (from right click) with zoom, pan, export graph and
% target centroids (in k-mean clustering) options.

% Requires external functions: updateActPan, setProp, actionPanel,
%                              setParam, updateFields, ud_zoom, exportAxes,
%                              ud_axesLim, switchPan

% Last update: 22nd of May 2014 by Mélodie C.A.S. Hadzic

set(obj, 'Name', figName);

setProp([obj; get(obj, 'Children')], 'Units', 'normalized');

setProp(get(obj, 'Children'), 'FontUnits', 'pixel');
setProp(get(obj, 'Children'), 'FontSize', 11);

set([h.uipanel_TA_transitionDensitiesAndPlot, ...
    h.uipanel_TA_stateConfiguration, ...
    h.uipanel_TA_stateTransitionRates, h.uipanel_TA_clusters, ...
    h.uipanel_TA_results, h.uipanel_TA_transitions, ...
    h.uipanel_TA_fittingParameters, h.uipanel_HA_histogramAndPlot, ...
    h.uipanel_HA_stateConfiguration, h.uipanel_HA_statePopulations, ...
    h.uipanel_HA_method, h.uipanel_HA_thresholding, ...
    h.uipanel_HA_gaussianFitting, h.uipanel_HA_fittingParameters, ...
    h.uipanel_TP_denoising, h.uipanel_TP_photobleaching, ...
    h.uipanel_TP_subImages, h.uipanel_TP_plot, ...
    h.uipanel_TP_backgroundCorrection, h.uipanel_TP_findStates, ...
    h.uipanel_TP_factorCorrections, h.uipanel_TP_sampleManagement, ...
    h.uipanel_VP_plot, h.uipanel_VP_experimentSettings, ...
    h.uipanel_VP_editAndExportVideo, h.uipanel_VP_moleculeCoordinates, ...
    h.uipanel_VP_spotfinder, h.uipanel_VP_coordinatesTransformation, ...
    h.uipanel_VP_intensityIntegration, ...
    h.uipanel_S_videoParameters, h.uipanel_S_molecules, ...
    h.uipanel_S_experimentalSetup, h.uipanel_S_exportOptions, ...
    h.uipanel_S_photophysics, h.uipanel_S_cameraSnrCharacteristics, ...
    h.uipanel_S_thermodynamicModel],'FontUnits','pixels','FontSize',12);

set([h.axes_TDPplot1, h.axes_TDPplot2, h.axes_top, h.axes_topRight, ...
    h.axes_bottom, h.axes_bottomRight], ...
    'FontUnits', 'pixels', 'FontSize', 11);

set(obj, 'OuterPosition', [0, 0.05 + 0.95/3.5, 2/3, 0.95/1.4]);

box off;
axis off;
hold off;

h.figure_actPan = actionPanel(obj);

% Update handles structure

guidata(obj, h);

% Initialization of parameters
ok = setParam(obj);

if ~ok
    close all force;
    return;
end

updateFields(obj);

h = guidata(obj);
h.folderRoot = h.param.movPr.folderRoot;

cd(h.folderRoot);

h.param.OpFiles.overwrite_ask = 1;
h.param.OpFiles.overwrite = 0;
h.output = obj;

h.TTpan = pan(obj);
h.TTzoom = zoom(obj);
set(h.TTpan, 'Enable', 'off');
set(h.TTzoom, 'Enable', 'off');

h_ZMenu = uicontextmenu('Parent', obj);

uimenu('Parent', h_ZMenu, 'Label', 'Reset to original view', ...
    'Callback', {@ud_zoom, 'reset', obj});

h.zMenu_zoom = uimenu('Parent', h_ZMenu, 'Label', 'Zoom tool', ...
    'Callback', {@ud_zoom, 'zoom', obj}, 'Checked', 'on');

h.zMenu_pan = uimenu('Parent', h_ZMenu, 'Label', 'Pan tool', ...
    'Callback', {@ud_zoom, 'pan', obj}, 'Checked', 'off');

h.zMenu_exp = uimenu('Parent', h_ZMenu, 'Label', 'Export graph', ...
    'Callback', {@exportAxes, obj});

h.zMenu_target = uimenu('Parent', h_ZMenu, 'Label', 'Target centroids', ...
    'Callback', {@ud_zoom, 'target', obj}, 'Checked', 'off', 'Enable', ...
    'off');

set(h.TTzoom, 'ActionPostCallback', {@ud_axesLim, obj}, ...
    'RightClickAction', 'PostContextMenu', 'UIContextMenu', h_ZMenu);

set(h.TTpan, 'ActionPostCallback', {@ud_axesLim, obj}, ...
    'UIContextMenu', h_ZMenu);

set(h.TTzoom, 'Enable', 'on');

guidata(obj,h);

switchPan(h.togglebutton_VP, [], h);

set(h.edit_rootFolder, 'String', h.folderRoot);

