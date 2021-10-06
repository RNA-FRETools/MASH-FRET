function popupmenu_thm_tpe_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

proj = p.curr_proj;
tpe1 = get(obj, 'Value');
tpe0 = p.thm.curr_tpe;
if tpe1==tpe0
    return
end

tpe_str = get(obj,'String');
setContPan(cat(2,'Select data: ',tpe_str{tpe1}),'success',h_fig);

p.thm.curr_tpe(proj) = tpe1;
h.param = p;
guidata(h_fig, h);

cla(h.axes_hist1);
cla(h.axes_hist2);

updateFields(h_fig, 'thm');

