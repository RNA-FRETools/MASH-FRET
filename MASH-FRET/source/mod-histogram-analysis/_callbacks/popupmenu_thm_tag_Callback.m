function popupmenu_thm_tag_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

tag1 = get(obj,'value');
proj = p.curr_proj;
tag0 = p.thm.curr_tag(proj);
if tag1==tag0
    return
end

tag_str = get(obj,'String');
if tag1==1
    setContPan('Select all molecules','success',h_fig);
else
    setContPan(cat(2,'Select molecule subgroup: ',...
        removeHtml(tag_str{tag1})),'success',h_fig);
end

p.thm.curr_tag(proj) = tag1;
h.param = p;
guidata(h_fig, h);

cla(h.axes_hist1);
cla(h.axes_hist2);

updateFields(h_fig, 'thm');

