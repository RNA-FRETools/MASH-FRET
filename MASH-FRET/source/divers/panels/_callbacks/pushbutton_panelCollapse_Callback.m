function pushbutton_panelCollapse_Callback(obj,evd,h_fig)
% pushbutton_panelCollapse_Callback(obj,[],h_fig)
%
% obj: handle to one panel expand/collapse button
% h_fig: handle to main figure

switch obj.String
    case char(9660) % bottom-pointing triangle
        expandPanel(obj);
        ud_extendedPanel(obj,h_fig);
    case char(9650) % top-pointing triangle
        collapsePanel(obj);
        ud_extendedPanel(obj,h_fig);
    otherwise
        disp('pushbutton_panelCollapse_Callback: unknown button string')
        return
end