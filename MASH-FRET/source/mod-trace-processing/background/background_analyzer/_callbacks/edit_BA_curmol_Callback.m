function edit_BA_curmol_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

val = str2num(get(obj, 'String'));
g.curr_m = val;
% update g structure
guidata(g.figure_bgopt, g);
ud_BAfields(g.figure_bgopt);
plot_bgRes(g.figure_bgopt)


