function pushbutton_BA_allMol_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nMol = size(p.proj{proj}.intensities,2)/nChan;
curr_m = g.curr_m;

for m = 1:nMol
    g.param{1}{m} = g.param{1}{curr_m};
end
guidata(g.figure_bgopt,g);


