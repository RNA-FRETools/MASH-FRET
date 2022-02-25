function switchMovTool(obj, evd, h_fig)

% update by MH, 19.12.2019: do not update image plot after change in order to preserve axis limits (preserving zoom for instance)

h = guidata(h_fig);
switch obj
    case h.togglebutton_target
        set(h.togglebutton_zoom, 'Value', 0);
        set(0, 'CurrentFigure', h_fig);
        zoom off;
        if isfield(h,'imageMov') && all(ishandle(h.imageMov))
            set(h.imageMov, 'ButtonDownFcn', {@pointITT, h_fig});
        end
        if isfield(h,'axes_VP_vid') && all(ishandle(h.axes_VP_vid))
            set(h.axes_VP_vid, 'ButtonDownFcn', {@pointITT, h_fig});
        end

    case h.togglebutton_zoom
        set(h.togglebutton_target, 'Value', 0);
        if isfield(h,'imageMov') && all(ishandle(h.imageMov))
            set(h.imageMov, 'ButtonDownFcn', {});
        end
        if isfield(h,'axes_VP_vid') && all(ishandle(h.axes_VP_vid))
            set(h.axes_VP_vid, 'ButtonDownFcn', {});
        end
        set(0, 'CurrentFigure', h_fig);
        zoom on;
end
