function listbox_TDPprojList_Callback(obj, evd, h)
p = h.param.TDP;
if size(p.proj,2) > 1
    val = get(obj, 'Value');
    p.curr_proj = val(1);
    h.param.TDP = p;
    guidata(h.figure_MASH, h);
    cla(h.axes_TDPplot1);
    updateFields(h.figure_MASH, 'TDP');
end