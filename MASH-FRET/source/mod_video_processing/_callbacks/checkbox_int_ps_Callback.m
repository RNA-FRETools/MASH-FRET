function checkbox_int_ps_Callback(obj, evd, h)
h.param.movPr.perSec = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'imgAxes');