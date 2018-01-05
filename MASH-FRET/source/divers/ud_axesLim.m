function ud_axesLim(obj, evd, h_fig)

h = guidata(h_fig);
h_axes_zoom = evd.Axes;
limX_zoom = get(evd.Axes, 'Xlim');
limY_zoom = get(evd.Axes, 'Ylim');

switch h_axes_zoom
    
    case h.axes_top
        set(h.axes_bottom, 'XLim', limX_zoom);
        set(h.axes_topRight, 'YLim', limY_zoom);
        
    case h.axes_bottom
        set(h.axes_top, 'XLim', limX_zoom);
        set(h.axes_bottomRight, 'YLim', limY_zoom);
        
    case h.axes_topRight
        set(h.axes_top, 'YLim', limY_zoom);
        set(h.axes_bottomRight, 'XLim', limX_zoom);
        
    case h.axes_bottomRight
        set(h.axes_bottom, 'YLim', limY_zoom);
        set(h.axes_topRight, 'XLim', limX_zoom);
        
    otherwise
        return;
end
