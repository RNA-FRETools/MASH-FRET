function checkbox_meanVal_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.movPr.itg_ave = val;
guidata(h_fig, h);
updateFields(h_fig, 'movPr');