function popupmenu_thm_gaussNb_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

updateFields(h_fig, 'thm');