function listbox_projLst_Callback(obj, evd, h_fig)
h = guidata(h_fig);
pTP = h.param.ttPr;
if isempty(pTP.proj)
    return
end
val = get(obj, 'Value');
if ~(numel(val)==1 && val~=pTP.curr_proj)
    return
end

pTP.curr_proj = val;
pHA.curr_proj = val;
pTA.curr_proj = val;
h.param.ttPr = pTP;
h.param.thm = pHA;
h.param.TDP = pTA;
guidata(h_fig, h);

proj_name = get(obj,'string');
str_proj = cat(2,'Project selected: "',proj_name{val},'" (',...
    pTP.proj{val}.proj_file,')');
setContPan(str_proj,'none',h_fig);

% update TP project parameters and molecule list
ud_TTprojPrm(h_fig);
ud_trSetTbl(h_fig);

% clear HA's axes
cla(h.axes_hist1);
cla(h.axes_hist2);

% update TDP and plot
pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);

% update GUI
updateFields(h_fig, 'ttPr');
updateFields(h_fig, 'thm');
