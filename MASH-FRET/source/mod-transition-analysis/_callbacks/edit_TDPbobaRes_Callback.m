function edit_TDPbobaRes_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

ud_TDPmdlSlct(h_fig);