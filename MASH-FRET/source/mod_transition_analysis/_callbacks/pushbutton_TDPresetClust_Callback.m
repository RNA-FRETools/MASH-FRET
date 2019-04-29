function pushbutton_TDPresetClust_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    p.proj{proj}.prm{tpe}.clst_res = cell(1,4);
    p.proj{proj}.prm{tpe}.kin_res = cell(1,5);
    h.param.TDP = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'TDP');
end