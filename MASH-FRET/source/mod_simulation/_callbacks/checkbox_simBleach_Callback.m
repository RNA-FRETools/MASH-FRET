function checkbox_simBleach_Callback(obj, evd, h)
h.param.sim.bleach = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');