function edit_TA_slPopSig_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

ud_kinFit(h_fig);