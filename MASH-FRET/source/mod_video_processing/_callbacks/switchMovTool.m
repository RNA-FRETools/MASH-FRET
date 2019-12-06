function switchMovTool(obj, evd, h_fig)
h = guidata(h_fig);
switch obj
    case h.togglebutton_target
        set(h.togglebutton_zoom, 'Value', 0);

    case h.togglebutton_zoom
        set(h.togglebutton_target, 'Value', 0);
end
updateFields(h_fig, 'imgAxes');