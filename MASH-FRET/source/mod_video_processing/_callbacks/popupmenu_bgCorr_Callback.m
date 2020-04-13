function popupmenu_bgCorr_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

p.movBg_method = get(obj, 'Value');

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_edExpVidPan(h_fig);

