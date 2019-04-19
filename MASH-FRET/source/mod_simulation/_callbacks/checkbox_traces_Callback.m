function checkbox_traces_Callback(obj, evd, h)
h.param.sim.export_traces = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');