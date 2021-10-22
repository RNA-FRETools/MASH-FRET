function popupmenu_subImg_exc_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;

if ~(p.proj{p.curr_proj}.is_coord && p.proj{p.curr_proj}.is_movie)
    return
end

p.proj{p.curr_proj}.TP.fix{1}(1) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'ttPr');