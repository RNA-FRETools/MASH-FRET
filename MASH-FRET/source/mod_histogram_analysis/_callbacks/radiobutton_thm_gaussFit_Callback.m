function radiobutton_thm_gaussFit_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    tag = p.curr_tag(proj);
    p.proj{proj}.prm{tag,tpe}.thm_start{1}(1) = 1;
    h.param.thm = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'thm');
end