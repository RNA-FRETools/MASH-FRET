function checkbox_procTraces_Callback(obj, evd, h)
h.param.sim.export_procTraces = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');