function popupmenu_TDP_expNum_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
trs = p.proj{proj}.curr{tag,tpe}.kin_start{2}(2);

p.proj{proj}.curr{tag,tpe}.kin_start{1}{trs,1}(3) = get(obj, 'Value');

h.param.TDP = p;
guidata(h_fig, h);

ud_kinFit(h_fig);
