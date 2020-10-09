function checkbox_BA_allmol_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

g.param{3}(3) = get(obj, 'Value');
% update g structure
guidata(g.figure_bgopt, g);
ud_BAfields(g.figure_bgopt);


