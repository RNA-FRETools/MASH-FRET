function popupmenu_TDPstate_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
val = get(obj, 'Value');

nStates = p.proj{proj}.curr{tag,tpe}.clst_start{1}(3);
if val > nStates
    set(obj, 'Value', 1);
end

ud_TDPmdlSlct(h_fig);