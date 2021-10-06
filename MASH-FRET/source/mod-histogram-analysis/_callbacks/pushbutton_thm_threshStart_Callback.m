function pushbutton_thm_threshStart_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

thresh_ana(h_fig);
updateFields(h_fig, 'thm');
