function popupmenu_ttPlotExc_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    labels = p.proj{p.curr_proj}.labels;
    str_top = getStrPop('plot_topChan', {labels val ...
        p.proj{p.curr_proj}.colours{1}});
    set(h.popupmenu_plotTop, 'String', str_top);
    p.proj{p.curr_proj}.fix{2}(1) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end