function checkbox_refocus_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj) && p.proj{p.curr_proj}.is_coord && ...
        p.proj{p.curr_proj}.is_movie
    p.proj{p.curr_proj}.fix{1}(5) = get(obj, 'Value');
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end