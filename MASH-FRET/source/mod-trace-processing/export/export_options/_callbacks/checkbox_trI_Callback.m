function checkbox_trI_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.proj{h.param.curr_proj}.TP.exp.traces{2}(1) = val;
guidata(h_fig, h);
ud_optExpTr('tr', h_fig);


