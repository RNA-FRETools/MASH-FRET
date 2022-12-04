function routinetest_TP_photobleaching(h_fig,p,prefix)
% routinetest_TP_photobleaching(h_fig,p,prefix)
%
% Tests photobleaching detection
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

% open default project
disp(cat(2,prefix,'import file ',p.mash_files{p.nL,p.nChan}));
pushbutton_openProj_Callback({p.annexpth,p.mash_files{p.nL,p.nChan}},...
    [],h_fig);

% set default parameters
setDefault_TP(h_fig,p);

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_TP_photobleaching,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

% test trace splitting
disp(cat(2,prefix,'test trace splitting...'));
set_TP_photobleaching(1,p.pbDat,p.pbPrm,false,h_fig);
pushbutton_TP_pbSplit_Callback([],[],h_fig);

% test manual settings
disp(cat(2,prefix,'test "Manual" photobleaching settings...'));
set_TP_photobleaching(1,p.pbDat,p.pbPrm,true,h_fig);
pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);

% test threshold-based detection on simple intensity trace
disp(cat(2,prefix,'test "Threshold" photobleaching settings...'));
set(h.popupmenu_debleachtype,'value',2);
popupmenu_debleachtype_Callback(h.popupmenu_debleachtype,[],h_fig);
nDat = numel(get(h.popupmenu_bleachChan,'string'));
set_TP_photobleaching(2,nDat-2,p.pbPrm,true,h_fig);
pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);

% test threshold-based detection on "All intensities"
set_TP_photobleaching(2,nDat-1,p.pbPrm,true,h_fig);
pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);

% test threshold-based detection on "Summed intensities"
set_TP_photobleaching(2,nDat,p.pbPrm,true,h_fig);
pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);

pushbutton_applyAll_debl_Callback(h.pushbutton_applyAll_debl,[],h_fig);
pushbutton_TP_updateAll_Callback(h.pushbutton_TP_updateAll,[],h_fig);

pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);
