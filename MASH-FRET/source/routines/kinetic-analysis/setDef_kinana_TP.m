function setDef_kinana_TP(p,h_fig)
% setDef_kinana_TP(p,h_fig)
%
% Set MASH-FRET's interface to default values
%
% p: structure containing default parameters
% h_fig: handle to main figure

% get interface parameters
h = guidata(h_fig);
proj = h.param.proj{h.param.curr_proj};

% set default units
h_but = getHandlePanelExpandButton(h.uipanel_TP_plot,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end
set_TP_xyAxis(p.fixX0,p.x0,h_fig);

% set default background parameters
h_but = getHandlePanelExpandButton(h.uipanel_TP_backgroundCorrection,...
    h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end
nDat = numel(get(h.popupmenu_trBgCorr_data,'string'));
for dat = 1:nDat
    set(h.popupmenu_trBgCorr_data,'value',dat);
    popupmenu_trBgCorr_data_Callback(h.popupmenu_trBgCorr_data,[],h_fig);
    set_TP_background(p.bgMeth,p.bgPrm(p.bgMeth,:),p.bgApply,h_fig);
end
pushbutton_applyAll_ttBg_Callback(h.pushbutton_applyAll_ttBg,[],h_fig);

% set default cross-talks parameters
h_but = getHandlePanelExpandButton(h.uipanel_TP_crossTalks,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end
set_TP_crossTalks(p.bt,p.de,proj.chanExc,proj.excitations,h_fig);

% set default denoising parameters
h_but = getHandlePanelExpandButton(h.uipanel_TP_denoising,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end
set_TP_denoising(p.denMeth,p.denPrm,p.denApply,h_fig);
pushbutton_applyAll_den_Callback(h.pushbutton_applyAll_den,[],h_fig);

% set default photobleaching parameters
h_but = getHandlePanelExpandButton(h.uipanel_TP_photobleaching,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end
set_TP_photobleaching(p.pbMeth,p.pbDat,p.pbPrm,p.pbApply,h_fig);
pushbutton_applyAll_debl_Callback(h.pushbutton_applyAll_debl,[],h_fig);

% set default factor corrections parameters
h_but = getHandlePanelExpandButton(h.uipanel_TP_factorCorrections,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end
nFRET = numel(get(h.popupmenu_gammaFRET,'string'))-1;
for pair = 1:nFRET
    set(h.popupmenu_gammaFRET,'value',pair+1);
    popupmenu_gammaFRET_Callback(h.popupmenu_gammaFRET,[],h_fig);
    set_TP_corrFactor(p.factMeth,p.fact,p.factPrm,h_fig);
end
pushbutton_applyAll_corr_Callback(h.pushbutton_applyAll_corr,[],h_fig);

% set default find states parameters
h_but = getHandlePanelExpandButton(h.uipanel_TP_findStates,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end
set_TP_findStates(p.fsMeth,p.fsDat,p.fsPrm,p.fsThresh,p.nChan,p.nL,h_fig);
pushbutton_applyAll_DTA_Callback(h.pushbutton_applyAll_DTA,[],h_fig);
