function checkbox_int_ps_Callback(obj, evd, h_fig)
h = guidata(h_fig);
h.param.movPr.perSec = get(obj, 'Value');
guidata(h_fig, h);
updateFields(h_fig, 'imgAxes');