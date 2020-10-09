function popupmenu_SF_Callback(obj, evd, h_fig)
h = guidata(h_fig);
h.param.movPr.SF_method = get(obj, 'Value');
guidata(h_fig, h);
ud_SFpanel(h_fig);