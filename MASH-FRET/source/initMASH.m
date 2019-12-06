function initMASH(h_fig, figName)
% Normalize all dimensions
% Position window on screen
% Open action panel
% Set default parameters with file 'default_param.ini'
% Create help buttons
% Actualize properties of uicontrols according to default parameters
% Create context menu (from right click) with zoom, pan, export graph and target centroids (in k-mean clustering) options.
%
% Requires external functions: updateActPan, setProp, actionPanel,
%                              setParam, updateFields, ud_zoom, exportAxes,
%                              ud_axesLim, setInfoIcons, switchPan

% Last update: 22nd of May 2014 by Mélodie C.A.S. Hadzic

h = guidata(h_fig);

set(h_fig, 'Name', figName);

% setProp(get(h_fig, 'Children'), 'FontUnits', 'pixel');
% setProp(get(h_fig, 'Children'), 'FontSize', 11);

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

box off;
axis off;
hold off;

% Initialization of parameters
ok = setParam(h_fig);

if ~ok
    close all force;
    return;
end

h = guidata(h_fig);
h.pushbutton_help = setInfoIcons([h_mainPan,h.axes_example_hist,...
    h.pushbutton_loadMov,h.pushbutton_traceImpOpt,h.axes_topRight,...
    h.pushbutton_thm_impASCII,h.axes_hist1,h.pushbutton_TDPimpOpt],...
    h.figure_MASH,h.param.movPr.infos_icon_file,h.charDimTable);
guidata(h.figure_MASH,h);

setProp([h_fig; get(h_fig, 'Children')], 'Units', 'normalized');
set(h_fig, 'OuterPosition', [0, 0.05 + 0.95/3.5, 2/3, 0.95/1.4]);

h.figure_actPan = actionPanel(h_fig);

% Update handles structure

guidata(h_fig, h);

updateFields(h_fig);
h = guidata(h_fig);

h.folderRoot = h.param.movPr.folderRoot;

cd(h.folderRoot);

h.param.OpFiles.overwrite_ask = 1;
h.param.OpFiles.overwrite = 0;
h.output = h_fig;

h.TTpan = pan(h_fig);
h.TTzoom = zoom(h_fig);
set(h.TTpan, 'Enable', 'off');
set(h.TTzoom, 'Enable', 'off');

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

guidata(h_fig,h);

updateActPan(cat(2,'--- WELCOME ----------------------------------------',...
    '--------------------'),h_fig);

switchPan(h.togglebutton_VP, [], h_fig);

set(h.edit_rootFolder, 'String', h.folderRoot);

