function routinetest_TP_photobleaching(h_fig,p,prefix)
% routinetest_TP_photobleaching(h_fig,p,prefix)
%
% Tests photobleaching detection
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

setDefault_TP(h_fig,p);

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

pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
