function popupmenu_TP_states_method_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    meth = get(obj, 'Value');
    p.proj{proj}.curr{mol}{4}{1}(1) = meth;
    h.param.ttPr = p;
    guidata(h_fig, h);

    if meth==3 % 2D-vbFRET discretize bottom traces only
        set(h.popupmenu_TP_states_applyTo,'value',1);
        popupmenu_TP_states_applyTo_Callback(h.popupmenu_TP_states_applyTo,...
            [],h_fig)
    end
    
    ud_DTA(h_fig);
end