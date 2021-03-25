function popupmenu_TDPlike_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
val = get(obj, 'Value');

p.proj{proj}.curr{tag,tpe}.clst_start{1}(10) = val;

h.param.TDP = p;
guidata(h_fig, h);


ud_TDPmdlSlct(h_fig);