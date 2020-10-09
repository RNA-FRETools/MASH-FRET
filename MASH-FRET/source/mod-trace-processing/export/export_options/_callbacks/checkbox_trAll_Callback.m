function checkbox_trAll_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{2}(4) = val;
guidata(h_fig, h);
ud_optExpTr('tr', h_fig);


