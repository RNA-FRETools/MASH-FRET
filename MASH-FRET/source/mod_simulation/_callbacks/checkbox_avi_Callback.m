function checkbox_avi_Callback(obj, evd, h)
h.param.sim.export_avi = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');