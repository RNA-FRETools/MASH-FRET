function popupmenu_TP_states_method_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = get(obj, 'Value');
    p.proj{proj}.curr{mol}{4}{1}(1) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_DTA(h.figure_MASH);
end