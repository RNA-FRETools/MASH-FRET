function pushbutton_BA_show_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

p = h.param.ttPr;
if ~isempty(p.proj)
    coord = dispDark_BA(g.figure_bgopt);
    m = g.curr_m;
    l = g.curr_l;
    c = g.curr_c;
    g.param{1}{m}(l,c,4) = coord(1);
    g.param{1}{m}(l,c,5) = coord(2);
end
guidata(g.figure_bgopt, g);
ud_BAfields(g.figure_bgopt);


