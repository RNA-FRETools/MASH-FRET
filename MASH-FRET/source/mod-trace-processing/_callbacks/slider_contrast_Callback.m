function slider_contrast_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj) && p.proj{p.curr_proj}.is_coord && ...
        p.proj{p.curr_proj}.is_movie
    val = round(100*get(obj, 'Value'))/100;
    set(obj, 'Value', val);
    p.proj{p.curr_proj}.fix{1}(4) = val*2 - 1;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'subImg');
end