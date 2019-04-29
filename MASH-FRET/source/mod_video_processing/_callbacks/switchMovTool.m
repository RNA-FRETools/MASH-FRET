function switchMovTool(obj, evd, h)
switch obj
    case h.togglebutton_target
        set(h.togglebutton_zoom, 'Value', 0);

    case h.togglebutton_zoom
        set(h.togglebutton_target, 'Value', 0);
end
updateFields(h.figure_MASH, 'imgAxes');