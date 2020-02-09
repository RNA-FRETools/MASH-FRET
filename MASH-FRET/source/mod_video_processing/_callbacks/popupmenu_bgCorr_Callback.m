function popupmenu_bgCorr_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.movPr;

p.movBg_method = get(obj, 'Value');

% save modifications
h.param.movPr = p;
guidata(h.figure_MASH, h);

