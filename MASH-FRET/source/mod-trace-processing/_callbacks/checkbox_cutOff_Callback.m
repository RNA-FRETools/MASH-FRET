function checkbox_cutOff_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);

p.proj{proj}.TP.curr{mol}{2}{1}(1) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'ttPr');