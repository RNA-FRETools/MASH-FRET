function pushbutton_thm_threshStart_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

% start thershold population analysis
thresh_ana(h_fig);

% bring histogram plot tab front
bringPlotTabFront('HAhist',h_fig);

% refresh interface
updateFields(h_fig, 'thm');
