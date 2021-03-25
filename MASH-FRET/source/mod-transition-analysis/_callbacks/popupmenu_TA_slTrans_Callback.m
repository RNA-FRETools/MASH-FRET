function popupmenu_TA_slTrans_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

ud_kinFit(h_fig);
updateTAplots(h_fig,'kin');