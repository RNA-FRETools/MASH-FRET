function togglebutton_TDPkmean_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    p.proj{proj}.prm{tpe}.clst_start{1}(1) = 1;
    h.param.TDP = p;
    set(h.zMenu_target, 'Enable', 'on');
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'TDP');
end