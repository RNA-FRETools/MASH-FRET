function checkbox_bgExp_Callback(obj, evd, h)
h.param.sim.bgDec = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');