function popupmenu_TA_mdlDat_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

ud_kinMdl(h_fig);
updateTAplots(h_fig,'mdl');