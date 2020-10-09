function checkbox_molValid_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.mol_valid = val;
guidata(h_fig, h);
ud_optExpTr('all', h_fig);


