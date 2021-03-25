function popupmenu_TA_setClstClr_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

ud_TDPmdlSlct(h_fig);