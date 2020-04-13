function checkbox_movie_Callback(obj, evd, h_fig)

h = guidata(h_fig);
h.param.sim.export_movie = get(obj, 'Value');
guidata(h_fig, h);

ud_S_expOptPan(h_fig);