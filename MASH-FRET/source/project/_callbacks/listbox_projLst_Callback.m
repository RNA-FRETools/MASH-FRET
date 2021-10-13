function listbox_projLst_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if isempty(p.proj)
    return
end
val = get(obj, 'Value');
if ~(numel(val)==1 && val~=p.curr_proj)
    return
end

p.curr_proj = val;
h.param = p;
guidata(h_fig, h);

proj_name = get(obj,'string');
str_proj = cat(2,'Project selected: "',proj_name{val},'"');
if ~isempty(p.proj{val}.proj_file)
    str_proj = cat(2,str_proj,'(',p.proj{val}.proj_file,')');
end
setContPan(str_proj,'none',h_fig);

% update TP project parameters and molecule list
ud_TTprojPrm(h_fig);
ud_trSetTbl(h_fig);

% clear HA's axes
cla(h.axes_hist1);
cla(h.axes_hist2);

% switch to proper module
switchPan(eval(['h.togglebutton_',p.curr_mod{p.curr_proj}]),[],h_fig);

% update TDP and plot
pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);

% update GUI
updateFields(h_fig);
