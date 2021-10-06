function popupmenu_TDPdataType_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;

val = get(obj, 'Value');
if val==p.TDP.curr_type(proj)
    return
end

str_tpe = get(obj,'String');
setContPan(cat(2,'Data "',str_tpe{val},'" selected.'), 'success', h_fig);

p.TDP.curr_type(proj) = val;
h.param = p;
guidata(h_fig, h);

% update TDP and plot
updateFields(h_fig,'TDP');

