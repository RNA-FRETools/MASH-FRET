function popupmenu_TP_states_method_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);

p.proj{proj}.curr{mol}{4}{1}(1) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

if meth==3 % 2D-vbFRET discretize bottom traces only
    set(h.popupmenu_TP_states_applyTo,'value',1);
    popupmenu_TP_states_applyTo_Callback(h.popupmenu_TP_states_applyTo,...
        [],h_fig)
end

ud_DTA(h_fig);
