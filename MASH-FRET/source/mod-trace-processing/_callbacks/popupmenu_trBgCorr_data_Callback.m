function popupmenu_trBgCorr_data_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;

p.proj{proj}.TP.fix{3}(6) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

ud_ttBg(h_fig);
