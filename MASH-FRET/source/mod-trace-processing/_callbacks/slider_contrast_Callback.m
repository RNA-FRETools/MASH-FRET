function slider_contrast_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;

if ~(p.proj{p.curr_proj}.is_coord && p.proj{p.curr_proj}.is_movie)
    return
end

val = round(100*get(obj, 'Value'))/100;
set(obj, 'Value', val);

p.proj{p.curr_proj}.TP.fix{1}(4) = val*2 - 1;

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'subImg');
