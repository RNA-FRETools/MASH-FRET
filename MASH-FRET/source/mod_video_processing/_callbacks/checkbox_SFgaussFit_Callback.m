function checkbox_SFgaussFit_Callback(obj, evd, h_fig)
h = guidata(h_fig);
h.param.movPr.SF_gaussFit = get(obj, 'Value');
guidata(h_fig, h);
ud_SFpanel(h_fig);