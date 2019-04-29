function popupmenu_SF_Callback(obj, evd, h)
h.param.movPr.SF_method = get(obj, 'Value');
guidata(h.figure_MASH, h);
ud_SFpanel(h.figure_MASH);