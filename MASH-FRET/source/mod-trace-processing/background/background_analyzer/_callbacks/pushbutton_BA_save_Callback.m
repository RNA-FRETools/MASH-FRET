function pushbutton_BA_save_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

% update g structure
saveBgOpt(g.figure_bgopt);


