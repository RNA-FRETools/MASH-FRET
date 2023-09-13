function popupmenu_TDPtag_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tag = p.TDP.curr_tag(proj);

val = get(obj,'Value');

if val==tag
    return
end

if val>1
    str_tag = get(obj,'String');
    setContPan(cat(2,'Select molecule subgroup "',...
        removeHtml(str_tag{val}),'".'),'success',h_fig);
else
    setContPan('Select all molecule.','success',h_fig);
end

p.TDP.curr_tag(proj) = val;
h.param = p;
guidata(h_fig, h);

% update plots and GUI
updateFields(h_fig, 'TDP');
