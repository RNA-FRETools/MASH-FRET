function popupmenu_trType_Callback(obj, evd, h_fig)
h = guidata(h_fig);
h.param.movPr.trsf_type = get(obj, 'Value');
guidata(h_fig, h);