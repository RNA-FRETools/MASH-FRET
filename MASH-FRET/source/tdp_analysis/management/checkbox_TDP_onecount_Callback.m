function checkbox_TDP_onecount_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    p.proj{proj}.prm{tpe}.plot{1}(4,1) = get(obj, 'Value');
    h.param.TDP = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'TDP');
end