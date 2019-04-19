function checkbox_dt_Callback(obj, evd, h)
h.param.sim.export_dt = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');