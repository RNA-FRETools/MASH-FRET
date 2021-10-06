function pushbutton_TDPcmap_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

axes(h.axes_TDPplot1);
colormapeditor;
