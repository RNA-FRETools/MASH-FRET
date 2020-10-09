function popupmenu_simBg_type_Callback(obj, evd, h_fig)
h = guidata(h_fig);
h.param.sim.bgType = get(obj, 'Value');
guidata(h_fig, h);
updateFields(h_fig, 'sim');