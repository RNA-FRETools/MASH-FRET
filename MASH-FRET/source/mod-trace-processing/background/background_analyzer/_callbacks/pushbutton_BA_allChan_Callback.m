function pushbutton_BA_allChan_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
curr_m = g.curr_m;
curr_l = g.curr_l;
curr_c = g.curr_c;
for l = 1:nExc
    for c = 1:nChan
        g.param{1}{curr_m}(l,c,:) = g.param{1}{curr_m}(curr_l,curr_c,:);
        g.param{2}{1}(l,c,:) = g.param{2}{1}(curr_l,curr_c,:);
        g.param{2}{2}(l,c,:) = g.param{2}{2}(curr_l,curr_c,:);
        g.param{2}{3}(l,c,:) = g.param{2}{3}(curr_l,curr_c,:);
    end
end
guidata(g.figure_bgopt,g);


