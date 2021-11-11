function ud_VP_panels(h_fig)
% ud_VP_panels(h_fig)
%
% Update properties of controls in all panels of module Video processing
%
% h_fig: handle to main figure

% retrieve interface parameters
h = guidata(h_fig);
p = h.param;

% expand current panel
if ~isempty(p.proj)
    pan = p.movPr.curr_pan(p.curr_proj);
    if pan>0
        expandPanel(getHandlePanelExpandButton({'VP',pan},h_fig));
    end
end

ud_VP_visuArea(h_fig);
ud_VP_plotPan(h_fig);
ud_VP_edExpVidPan(h_fig);
ud_VP_molCoordPan(h_fig);
ud_VP_intIntegrPan(h_fig);