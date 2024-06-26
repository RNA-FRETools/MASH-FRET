function setDefault_TA(h_fig,p)
% setDefault_TA(h_fig,p)
%
% Set Transition analysis module to default values and update interface parameters
%
% h_fig: handle to main figure
% p: structure that must contain default parameters as generated by getDefault_TA


% get interface parameters
h = guidata(h_fig);

% empty project list
nProj = numel(h.listbox_proj.String);
for proj = nProj:-1:1
    set(h.listbox_proj,'value',proj);
    listbox_projLst_Callback(h.listbox_proj,[],h_fig);
    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig,true);
end

% import default project
pushbutton_openProj_Callback({p.annexpth,p.mash_file},[],h_fig);

% switch to trace processing module
switchPan(h.togglebutton_TA,[],h_fig);

% select data
set(h.popupmenu_TDPdataType,'value',p.tdpDat);
popupmenu_TDPdataType_Callback(h.popupmenu_TDPdataType,[],h_fig);

