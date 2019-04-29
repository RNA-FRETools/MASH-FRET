function radiobutton_thm_thresh_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    p.proj{proj}.prm{tpe}.thm_start{1}(1) = 2;
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'thm');
end