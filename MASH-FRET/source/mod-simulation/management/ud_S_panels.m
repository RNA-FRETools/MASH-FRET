function ud_S_panels(h_fig)
% ud_S_panels(h_fig)
%
% Update properties of controls in all panels of module Simulation
%
% h_fig: handle to main figure

% retrieve interface parameters
h = guidata(h_fig);
p = h.param;

% expand current panel
if ~isempty(p.proj)
    pan = p.sim.curr_pan(p.curr_proj);
    if pan>0
        expandPanel(getHandlePanelExpandButton({'S',pan},h_fig));
    end
end

% refresh panels
ud_S_vidParamPan(h_fig);
ud_S_moleculesPan(h_fig);
ud_S_expSetupPan(h_fig);
ud_S_expOptPan(h_fig);