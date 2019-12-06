function radiobutton_thm_thresh_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    p.proj{proj}.prm{tpe}.thm_start{1}(1) = 2;
    h.param.thm = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'thm');
end