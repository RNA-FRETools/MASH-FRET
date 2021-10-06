function popupmenu_TDPcolour_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};

val = get(obj, 'Value');
trans = curr.kin_start{2}(2);

p.proj{proj}.TA.prm{tag,tpe}.clst_start{3}(trans,:) = p.colList(val,:);
p.proj{proj}.TA.curr{tag,tpe}.clst_start{3}(trans,:) = p.colList(val,:);

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'TDP');
