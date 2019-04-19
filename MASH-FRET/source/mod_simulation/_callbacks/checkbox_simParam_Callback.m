function checkbox_simParam_Callback(obj, evd, h)
h.param.sim.export_param = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');