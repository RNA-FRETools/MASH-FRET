function pushbutton_TDPcmap_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    axes(h.axes_TDPplot1);
    colormapeditor;
end