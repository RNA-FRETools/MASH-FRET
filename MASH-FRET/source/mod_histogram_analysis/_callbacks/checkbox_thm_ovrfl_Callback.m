function checkbox_thm_ovrfl_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    prm.plot{1}(4) = get(obj, 'Value');
    prm.plot{2} = [];
    p.proj{proj}.prm{tpe} = prm;
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'thm');
end