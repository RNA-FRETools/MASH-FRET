function checkbox_SFgaussFit_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);

h.param.movPr.SF_gaussFit = get(obj, 'Value');

% save modifications
guidata(h_fig, h);

% set GUI to proper values
ud_VP_sfPan(h_fig);
