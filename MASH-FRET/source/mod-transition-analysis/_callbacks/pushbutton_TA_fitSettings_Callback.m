function pushbutton_TA_fitSettings_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

% show process
setContPan('Opening fit settings...','process',h_fig);

buildFitSettingsWin(h_fig);

% bring dwell time histogram plot tab front
bringPlotTabFront('TAdt',h_fig);

% show success
setContPan('Fit settings are ready!','process',h_fig);