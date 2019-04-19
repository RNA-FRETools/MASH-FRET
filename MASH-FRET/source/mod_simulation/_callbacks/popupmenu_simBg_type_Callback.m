function popupmenu_simBg_type_Callback(obj, evd, h)
h.param.sim.bgType = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');