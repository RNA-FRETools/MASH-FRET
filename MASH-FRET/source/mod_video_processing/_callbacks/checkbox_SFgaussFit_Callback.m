function checkbox_SFgaussFit_Callback(obj, evd, h)
h.param.movPr.SF_gaussFit = get(obj, 'Value');
guidata(h.figure_MASH, h);
ud_SFpanel(h.figure_MASH);