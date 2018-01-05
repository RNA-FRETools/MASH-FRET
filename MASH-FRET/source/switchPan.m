function switchPan(obj, evd, h)

green = [0.76 0.87 0.78];
grey = [240/255 240/255 240/255];

set(obj, 'BackgroundColor', green);

switch obj
    case h.togglebutton_simMov
        set(h.togglebutton_movProc, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TTproc, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_thermo, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TDPana, 'Value', 0, 'BackgroundColor', grey);
        set(h.uipanel_movProc, 'Visible', 'off');
        set(h.uipanel_TTproc, 'Visible', 'off');
        set(h.uipanel_thm, 'Visible', 'off');
        set(h.uipanel_TDPana, 'Visible', 'off');
        set(h.uipanel_simMov, 'Visible', 'on');
        set(h.zMenu_target, 'Enable', 'off', 'Checked', 'off');
        
        cmaps = get(h.popupmenu_colorMap, 'String');
        cmap = cmaps{h.param.movPr.cmap};
        colormap(cmap);
        
    case h.togglebutton_movProc
        set(h.togglebutton_simMov, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TTproc, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_thermo, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TDPana, 'Value', 0, 'BackgroundColor', grey);
        set(h.uipanel_simMov, 'Visible', 'off');
        set(h.uipanel_TTproc, 'Visible', 'off');
        set(h.uipanel_thm, 'Visible', 'off');
        set(h.uipanel_TDPana, 'Visible', 'off');
        set(h.uipanel_movProc, 'Visible', 'on');
        set(h.zMenu_target, 'Enable', 'off', 'Checked', 'off');
        
        cmaps = get(h.popupmenu_colorMap, 'String');
        cmap = cmaps{h.param.movPr.cmap};
        colormap(cmap);
        
    case h.togglebutton_TTproc
        set(h.togglebutton_simMov, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_movProc, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_thermo, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TDPana, 'Value', 0, 'BackgroundColor', grey);
        set(h.uipanel_simMov, 'Visible', 'off');
        set(h.uipanel_movProc, 'Visible', 'off');
        set(h.uipanel_thm, 'Visible', 'off');
        set(h.uipanel_TDPana, 'Visible', 'off');
        set(h.uipanel_TTproc, 'Visible', 'on');
        set(h.zMenu_target, 'Enable', 'off', 'Checked', 'off');
        
    case h.togglebutton_thermo
        set(h.togglebutton_simMov, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_movProc, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TTproc, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TDPana, 'Value', 0, 'BackgroundColor', grey);
        set(h.uipanel_simMov, 'Visible', 'off');
        set(h.uipanel_movProc, 'Visible', 'off');
        set(h.uipanel_TTproc, 'Visible', 'off');
        set(h.uipanel_TDPana, 'Visible', 'off');
        set(h.uipanel_thm, 'Visible', 'on');
        set(h.zMenu_target, 'Enable', 'off', 'Checked', 'off');
        
    case h.togglebutton_TDPana
        set(h.togglebutton_simMov, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_movProc, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_TTproc, 'Value', 0, 'BackgroundColor', grey);
        set(h.togglebutton_thermo, 'Value', 0, 'BackgroundColor', grey);
        set(h.uipanel_simMov, 'Visible', 'off');
        set(h.uipanel_movProc, 'Visible', 'off');
        set(h.uipanel_TTproc, 'Visible', 'off');
        set(h.uipanel_thm, 'Visible', 'off');
        set(h.uipanel_TDPana, 'Visible', 'on');
        set(h.zMenu_target, 'Enable', 'on');

        colormap(h.param.TDP.cmap);
end