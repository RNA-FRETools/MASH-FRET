function radiobutton_thm_penalty_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    prm.thm_start{4}(1,1) = get(obj, 'Value');
    p.proj{proj}.prm{tpe} = prm;
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'thm');
end