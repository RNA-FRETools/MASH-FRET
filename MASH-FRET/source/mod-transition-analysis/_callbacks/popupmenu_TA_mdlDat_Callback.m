function popupmenu_TA_mdlDat_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

ud_kinMdl(h_fig);
updateTAplots(h_fig,'mdl');