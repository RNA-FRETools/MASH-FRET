function checkbox_expCoord_Callback(obj, evd, h)
h.param.sim.export_coord = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');