function switchPan(obj,evd,h_fig)

 h = guidata(h_fig);

green = [0.76 0.87 0.78];
grey = [240/255 240/255 240/255];

set(obj, 'BackgroundColor', green);

switch obj
    case h.togglebutton_S
        set(h.togglebutton_VP, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TP, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_HA, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TA, 'Value', 0, 'BackgroundColor', grey);
        set(h.uipanel_VP, 'Visible', 'off');
        set(h.uipanel_TP, 'Visible', 'off');
        set(h.uipanel_HA, 'Visible', 'off');
        set(h.uipanel_TA, 'Visible', 'off');
        set(h.uipanel_S, 'Visible', 'on');
        
        cmaps = get(h.popupmenu_colorMap, 'String');
        cmap = cmaps{h.param.movPr.cmap};
        colormap(cmap);
        setContPan('Module "Simulation" selected.','none',h.figure_MASH);
        
    case h.togglebutton_VP
        set(h.togglebutton_S, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TP, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_HA, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TA, 'Value', 0, 'BackgroundColor', grey);
        set(h.uipanel_S, 'Visible', 'off');
        set(h.uipanel_TP, 'Visible', 'off');
        set(h.uipanel_HA, 'Visible', 'off');
        set(h.uipanel_TA, 'Visible', 'off');
        set(h.uipanel_VP, 'Visible', 'on');
        
        cmaps = get(h.popupmenu_colorMap, 'String');
        cmap = cmaps{h.param.movPr.cmap};
        colormap(cmap);
        setContPan('Module "Video processing" selected.','none',...
            h.figure_MASH);
        
    case h.togglebutton_TP
        set(h.togglebutton_S, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_VP, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_HA, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TA, 'Value', 0, 'BackgroundColor', grey);
        set(h.uipanel_S, 'Visible', 'off');
        set(h.uipanel_VP, 'Visible', 'off');
        set(h.uipanel_HA, 'Visible', 'off');
        set(h.uipanel_TA, 'Visible', 'off');
        set(h.uipanel_TP, 'Visible', 'on');
        setContPan('Module "Trace processing" selected.','none',...
            h.figure_MASH);
        
    case h.togglebutton_HA
        set(h.togglebutton_S, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_VP, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TP, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TA, 'Value', 0, 'BackgroundColor', grey);
        set(h.uipanel_S, 'Visible', 'off');
        set(h.uipanel_VP, 'Visible', 'off');
        set(h.uipanel_TP, 'Visible', 'off');
        set(h.uipanel_TA, 'Visible', 'off');
        set(h.uipanel_HA, 'Visible', 'on');
        setContPan('Module "Histogram analysis" selected.','none',...
            h.figure_MASH);
        
    case h.togglebutton_TA
        set(h.togglebutton_S, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_VP, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TP, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_HA, 'Value', 0, 'BackgroundColor', grey);
        set(h.uipanel_S, 'Visible', 'off');
        set(h.uipanel_VP, 'Visible', 'off');
        set(h.uipanel_TP, 'Visible', 'off');
        set(h.uipanel_HA, 'Visible', 'off');
        set(h.uipanel_TA, 'Visible', 'on');
        setContPan('Module "Transition analysis" selected.','none',...
            h.figure_MASH);

        colormap(h.param.TDP.cmap);
end