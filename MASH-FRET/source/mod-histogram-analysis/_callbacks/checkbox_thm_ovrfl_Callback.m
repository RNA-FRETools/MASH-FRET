function checkbox_thm_ovrfl_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
curr = p.proj{proj}.HA.curr{tag,tpe};

curr.plot{1}(4) = get(obj, 'Value');
curr.plot{2} = [];

p.proj{proj}.HA.curr{tag,tpe} = curr;

h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');
