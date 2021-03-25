function popupmenu_TDPdataType_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
val = get(obj, 'Value');
if val==p.curr_type(proj)
    return
end

str_tpe = get(obj,'String');
setContPan(cat(2,'Data "',str_tpe{val},'" selected.'), 'success', h_fig);

p.curr_type(proj) = val;
h.param.TDP = p;
guidata(h_fig, h);

% update TDP and plot
pushbutton_TDPupdatePlot_Callback(obj, evd, h_fig);

