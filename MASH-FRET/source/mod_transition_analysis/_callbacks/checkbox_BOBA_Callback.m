function checkbox_BOBA_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
    p.proj{proj}.prm{tpe}.kin_start{trs,1}(4) = get(obj, 'Value');
    h.param.TDP = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'TDP');
end