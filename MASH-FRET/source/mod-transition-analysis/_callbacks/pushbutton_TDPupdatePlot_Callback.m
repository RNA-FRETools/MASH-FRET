function pushbutton_TDPupdatePlot_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

% update plots and GUI
updateFields(h_fig, 'TDP');

