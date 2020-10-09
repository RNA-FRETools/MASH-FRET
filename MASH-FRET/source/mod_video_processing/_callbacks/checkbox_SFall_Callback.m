function checkbox_SFall_Callback(obj, evd, h_fig)
h = guidata(h_fig);
h.param.movPr.SF_all = get(obj, 'Value');
guidata(h_fig, h);