function popupmenu_topChan_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.proj{h.param.curr_proj}.TP.exp.fig{2}{1}(3) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


