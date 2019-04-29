function checkbox_SFall_Callback(obj, evd, h)
h.param.movPr.SF_all = get(obj, 'Value');
guidata(h.figure_MASH, h);