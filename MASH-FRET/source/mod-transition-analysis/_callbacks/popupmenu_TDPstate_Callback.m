function popupmenu_TDPstate_Callback(obj, evd, h_fig)

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

nStates = curr.clst_start{1}(3);
if val > nStates
    set(obj, 'Value', 1);
end

ud_TDPmdlSlct(h_fig);