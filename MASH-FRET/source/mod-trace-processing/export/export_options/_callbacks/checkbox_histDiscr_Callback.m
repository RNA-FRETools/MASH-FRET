function checkbox_histDiscr_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.proj{h.param.curr_proj}.TP.exp.hist{1}(2) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


