function checkbox_thm_BS_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    tag = p.curr_tag(proj);
    p.proj{proj}.prm{tag,tpe}.thm_start{1}(2) = get(obj, 'Value');
    p.proj{proj}.prm{tag,tpe}.thm_res(1,1:3) = {[] [] []};
    p.proj{proj}.prm{tag,tpe}.thm_res(2,1:3) = {[] [] []};
    h.param.thm = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'thm');
end