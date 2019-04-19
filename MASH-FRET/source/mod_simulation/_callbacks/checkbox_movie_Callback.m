function checkbox_movie_Callback(obj, evd, h)
h.param.sim.export_movie = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');