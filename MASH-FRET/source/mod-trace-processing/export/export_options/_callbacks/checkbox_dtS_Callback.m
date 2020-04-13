function checkbox_dtS_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.dt{2}(3) = val;
guidata(h_fig, h);
ud_optExpTr('dt', h_fig);


