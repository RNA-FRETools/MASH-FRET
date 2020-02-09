function pushbutton_remBgCorr_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;
n = get(h.listbox_bgCorr, 'Value');

p.bgCorr(n,:) = [];

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig, 'imgAxes');