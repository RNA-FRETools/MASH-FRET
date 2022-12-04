function popupmenu_TDPlike_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);

val = get(obj, 'Value');

p.proj{proj}.TA.curr{tag,tpe}.clst_start{1}(10) = val;

h.param = p;
guidata(h_fig, h);

ud_TDPmdlSlct(h_fig);