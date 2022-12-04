function checkbox_kin_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.proj{h.param.curr_proj}.TP.exp.dt{2}(4) = val;
guidata(h_fig, h);
ud_optExpTr('dt', h_fig);


