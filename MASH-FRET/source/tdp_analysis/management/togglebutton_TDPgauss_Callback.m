function togglebutton_TDPgauss_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    p.proj{proj}.prm{tpe}.clst_start{1}(1) = 2;
    h.param.TDP = p;
    guidata(h.figure_MASH, h);
    set(h.zMenu_target, 'Enable', 'off');
    ud_zoom([], [], 'zoom', h.figure_MASH)
    updateFields(h.figure_MASH, 'TDP');
end