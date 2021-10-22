function checkbox_photobl_insec_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;

p.proj{proj}.TP.fix{2}(7) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'ttPr');
