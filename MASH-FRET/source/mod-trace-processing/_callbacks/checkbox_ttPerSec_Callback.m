function checkbox_ttPerSec_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    p.proj{p.curr_proj}.fix{2}(4) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end