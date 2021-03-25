function checkbox_bgExp_Callback(obj, evd, h_fig)

h = guidata(h_fig);
h.param.sim.bgDec = get(obj, 'Value');
guidata(h_fig, h);

ud_S_expSetupPan(h_fig);