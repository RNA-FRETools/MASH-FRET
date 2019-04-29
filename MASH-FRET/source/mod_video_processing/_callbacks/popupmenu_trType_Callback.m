function popupmenu_trType_Callback(obj, evd, h)
h.param.movPr.trsf_type = get(obj, 'Value');
guidata(h.figure_MASH, h);