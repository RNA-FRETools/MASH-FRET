% added by FS, 17.3.2018
function checkbox_gam_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.proj{h.param.curr_proj}.TP.exp.traces{2}(6) = val;
guidata(h_fig, h);
ud_optExpTr('dt', h_fig);


