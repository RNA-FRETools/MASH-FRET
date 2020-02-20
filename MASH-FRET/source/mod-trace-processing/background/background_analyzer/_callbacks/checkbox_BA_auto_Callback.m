function checkbox_BA_auto_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
g.param{1}{m}(l,c,6) = get(obj, 'Value');
% update g structure
guidata(g.figure_bgopt, g);
ud_BAfields(g.figure_bgopt);


