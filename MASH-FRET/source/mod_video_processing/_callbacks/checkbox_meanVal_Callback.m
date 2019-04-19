function checkbox_meanVal_Callback(obj, evd, h)
val = get(obj, 'Value');
h.param.movPr.itg_ave = val;
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'movPr');