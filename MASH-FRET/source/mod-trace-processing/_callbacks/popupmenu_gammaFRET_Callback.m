function popupmenu_gammaFRET_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;

p.proj{proj}.TP.fix{3}(8) = get(obj, 'Value')-1;

h.param = p;
guidata(h_fig, h);

ud_factors(h_fig)