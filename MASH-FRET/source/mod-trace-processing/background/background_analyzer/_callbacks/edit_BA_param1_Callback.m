function edit_BA_param1_Callback(obj, evd, h_fig, n)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
val = str2num(get(obj, 'String'));
if n==0
    g.param{1}{m}(l,c,2) = val;
else
    g.param{2}{1}(l,c,n) = val;
end
% update g structure
guidata(g.figure_bgopt, g);
ud_BAfields(g.figure_bgopt);


