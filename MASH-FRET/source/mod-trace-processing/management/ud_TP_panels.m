function ud_TP_panels(h_fig)
% ud_TP_panels(h_fig)
%
% Update properties of controls in all panels of module Trace processing
%
% h_fig: handle to main figure

% retrieve interface parameters
h = guidata(h_fig);
p = h.param;

% expand current panel
if ~isempty(p.proj)
    pan = p.ttPr.curr_pan(p.curr_proj);
    if pan>0
        expandPanel(getHandlePanelExpandButton({'TP',pan},h_fig));
    end
end

ud_trSetTbl(h_fig);
ud_plot(h_fig);
ud_subImg(h_fig);
ud_ttBg(h_fig);
ud_sampling(h_fig);
ud_cross(h_fig);
ud_denoising(h_fig);
ud_bleach(h_fig);
ud_factors(h_fig);
ud_DTA(h_fig);
ud_TP_currMol(h_fig);