function pushbutton_TDPupdatePlot_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

% show process
setContPan('Refresh TDP...','process',h_fig);

% update plots and GUI
updateFields(h_fig, 'TDP');

% bring average image plot tab front
bringPlotTabFront('TAtdp',h_fig);

% show process
setContPan('TDP successfully refreshed!','process',h_fig);

