function slider_brightness_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj) && p.proj{p.curr_proj}.is_coord && ...
        p.proj{p.curr_proj}.is_movie
    val = round(100*get(obj, 'Value'))/100;
    set(obj, 'Value', val);
    p.proj{p.curr_proj}.fix{1}(3) = val*2 - 1;
    h.param.ttPr = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'subImg');
end