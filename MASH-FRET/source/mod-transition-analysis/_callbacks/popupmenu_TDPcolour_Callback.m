function popupmenu_TDPcolour_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = get(obj, 'Value');
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
trans = p.proj{proj}.curr{tag,tpe}.kin_start{2}(2);

p.proj{proj}.prm{tag,tpe}.clst_start{3}(trans,:) = p.colList(val,:);

h.param.TDP = p;
guidata(h_fig, h);

updateFields(h_fig, 'TDP');
