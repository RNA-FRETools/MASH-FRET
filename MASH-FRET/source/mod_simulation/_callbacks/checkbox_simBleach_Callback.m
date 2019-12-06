function checkbox_simBleach_Callback(obj, evd, h_fig)
h = guidata(h_fig);
h.param.sim.bleach = get(obj, 'Value');
guidata(h_fig, h);
updateFields(h_fig, 'sim');