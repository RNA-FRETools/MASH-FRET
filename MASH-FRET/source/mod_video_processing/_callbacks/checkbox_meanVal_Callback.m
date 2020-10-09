function checkbox_meanVal_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);

h.param.movPr.itg_ave = get(obj, 'Value');

% save modifications
guidata(h_fig, h);

% set GUI to proper values
ud_VP_intIntegrPan(h_fig);