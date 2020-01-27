function pushbutton_TDPfit_log_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

act = get(obj, 'String');
if strcmp(act, 'y-log scale')
    set(obj, 'String', 'y-linear scale');
    set(h.axes_TDPplot2, 'YScale', 'log');
elseif strcmp(act, 'y-linear scale')
    set(obj, 'String', 'y-log scale');
    set(h.axes_TDPplot2, 'YScale', 'linear');
end