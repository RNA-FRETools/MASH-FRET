function checkbox_ttPerSec_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.TP.fix{2}(4) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'ttPr');
