function checkbox_TDPnorm_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);

p.proj{proj}.TA.curr{tag,tpe}.plot{1}(3,3) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'TDP');
