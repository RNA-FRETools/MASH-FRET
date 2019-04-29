function popupmenu_gammaFRET_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj = p.curr_proj;
    p.proj{proj}.fix{3}(8) = val-1;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_cross(h.figure_MASH);
end