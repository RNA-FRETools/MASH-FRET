function radiobutton_BA_fix_param1_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

val = get(obj, 'Value');
g.param{3}(1) = val;
% update g structure
guidata(g.figure_bgopt, g);
ud_BAfields(g.figure_bgopt);


