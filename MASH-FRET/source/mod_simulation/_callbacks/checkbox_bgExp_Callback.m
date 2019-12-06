function checkbox_bgExp_Callback(obj, evd, h_fig)
h = guidata(h_fig);
h.param.sim.bgDec = get(obj, 'Value');
guidata(h_fig, h);
updateFields(h_fig, 'sim');