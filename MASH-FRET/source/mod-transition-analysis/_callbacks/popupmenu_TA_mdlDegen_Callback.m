function popupmenu_TA_mdlDegen_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

ud_kinMdl(h_fig);