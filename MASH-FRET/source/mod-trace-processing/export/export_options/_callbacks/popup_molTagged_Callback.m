% added by FS, 24.4.2018
function popup_molTagged_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.proj{h.param.curr_proj}.TP.exp.mol_TagVal = val;
guidata(h_fig, h);
ud_optExpTr('all', h_fig);

