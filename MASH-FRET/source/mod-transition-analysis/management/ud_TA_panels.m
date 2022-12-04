function ud_TA_panels(h_fig)
% ud_TA_panels(h_fig)
%
% Update properties of controls in all panels of module Transition analysis
%
% h_fig: handle to main figure

% retrieve interface parameters
h = guidata(h_fig);
p = h.param;

% expand current panel
if ~isempty(p.proj)
    pan = p.TDP.curr_pan(p.curr_proj);
    if pan>0
        expandPanel(getHandlePanelExpandButton({'TA',pan},h_fig));
    end
end

ud_TA_visuArea(h_fig);
ud_TA_dataSelect(h_fig);
ud_TDPplot(h_fig);
ud_TDPmdlSlct(h_fig);
ud_kinFit(h_fig);
ud_kinMdl(h_fig)