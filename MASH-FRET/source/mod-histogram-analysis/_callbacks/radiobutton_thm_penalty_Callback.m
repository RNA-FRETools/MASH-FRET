function radiobutton_thm_penalty_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    tag = p.curr_tag(proj);
    prm = p.proj{proj}.prm{tag,tpe};
    prm.thm_start{4}(1,1) = get(obj, 'Value');
    p.proj{proj}.prm{tag,tpe} = prm;
    h.param.thm = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'thm');
end