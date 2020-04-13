function popupmenu_SF_Callback(obj, evd, h_fig)

% collect interface parameters
val = get(obj, 'Value');
h = guidata(h_fig);
p = h.param.movPr;

p.SF_method = val;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_sfPan(h_fig);