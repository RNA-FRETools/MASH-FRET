function checkbox_trS_Callback(obj, evd, h_fig)

h = guidata(h_fig);

h.param.proj{h.param.curr_proj}.TP.exp.traces{2}(3) = get(obj, 'Value');

guidata(h_fig, h);

ud_optExpTr('tr', h_fig);


