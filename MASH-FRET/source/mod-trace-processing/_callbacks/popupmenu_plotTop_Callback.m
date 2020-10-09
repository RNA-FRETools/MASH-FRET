function popupmenu_plotTop_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    p.proj{p.curr_proj}.fix{2}(2) = val;
    h.param.ttPr = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'ttPr');
end