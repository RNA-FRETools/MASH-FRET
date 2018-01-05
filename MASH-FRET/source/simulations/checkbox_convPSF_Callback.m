function checkbox_convPSF_Callback(obj, evd, h)
h.param.sim.PSF = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');