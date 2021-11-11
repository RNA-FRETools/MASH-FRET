function ud_HA_panels(h_fig)
% ud_HA_panels(h_fig)
%
% Update properties of controls in all panels of module Histogram analysis
%
% h_fig: handle to main figure

% retrieve interface parameters
h = guidata(h_fig);
p = h.param;

% expand current panel
if ~isempty(p.proj)
    pan = p.thm.curr_pan(p.curr_proj);
    if pan>0
        expandPanel(getHandlePanelExpandButton({'HA',pan},h_fig));
    end
end

ud_HA_dataSelect(h_fig);
ud_thmPlot(h_fig);
ud_HA_stateConfig(h_fig);
ud_HA_statePop(h_fig);