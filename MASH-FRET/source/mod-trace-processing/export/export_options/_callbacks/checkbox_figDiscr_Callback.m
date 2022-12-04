function checkbox_figDiscr_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.proj{h.param.curr_proj}.TP.exp.fig{1}(6) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


