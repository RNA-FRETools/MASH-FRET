function togglebutton_TDPshape_Callback(obj, evd, shape, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);

p.proj{proj}.TA.curr{tag,tpe}.clst_start{1}(2) = shape;

h.param = p;
guidata(h_fig, h);

updateFields(h_fig,'TDP');