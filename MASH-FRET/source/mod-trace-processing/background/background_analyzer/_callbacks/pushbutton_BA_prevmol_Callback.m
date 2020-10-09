function pushbutton_BA_prevmol_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

curr_m = g.curr_m;
if (curr_m-1)>0
    g.curr_m = curr_m-1;
    guidata(g.figure_bgopt, g);
    ud_BAfields(g.figure_bgopt);
    plot_bgRes(g.figure_bgopt);
end


