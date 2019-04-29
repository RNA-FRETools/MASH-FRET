function popupmenu_trBgCorr_data_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    p.proj{proj}.fix{3}(6) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_ttBg(h.figure_MASH);
end