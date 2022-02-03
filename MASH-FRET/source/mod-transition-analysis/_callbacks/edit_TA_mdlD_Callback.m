function edit_TA_mdlD_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

ud_kinMdl(h_fig);