function ud_extendedPanel(h_but,h_fig)
% ud_extendedPanel(h_but,h_fig)
%
% Set extendable panel component properties to proper values
%
% h_but: row vector of handles to extend/collapse buttons
% h_fig: handle to main figure

h = guidata(h_fig);

for b = h_but
    switch b.UserData{1}.Parent
        case h.uipanel_S_scroll
            ud_S_panels(h_fig);
        case h.uipanel_VP_scroll
            ud_VP_panels(h_fig);
        case h.uipanel_TP_scroll
            ud_TP_panels(h_fig);
        case h.uipanel_HA_scroll
            ud_HA_panels(h_fig);
        case h.uipanel_TA_scroll
            ud_TA_panels(h_fig);
        otherwise
            disp('ud_extendedPanel: unknown extendable panel.');
    end
end
