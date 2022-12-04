function pushbutton_BA_nextmol_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nMol = size(p.proj{proj}.intensities,2)/nChan;
curr_m = g.curr_m;
if (curr_m+1)<=nMol
    g.curr_m = curr_m+1;
    guidata(g.figure_bgopt, g);
    ud_BAfields(g.figure_bgopt);
    plot_bgRes(g.figure_bgopt)
end


