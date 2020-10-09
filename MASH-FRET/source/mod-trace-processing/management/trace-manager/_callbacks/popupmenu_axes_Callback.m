function popupmenu_axes_Callback(obj, evd, h_fig)

h = guidata(h_fig);

dat3 = get(h.tm.axes_histSort,'userdata');
if ~sum(dat3.slct)
    return
end

if obj==h.tm.popupmenu_axes1 || obj==h.tm.popupmenu_AS_plot1
    plot1 = get(obj,'value');
    set([h.tm.popupmenu_axes1,h.tm.popupmenu_AS_plot1],'value',plot1);
end

plotData_overall(h_fig);

if obj==h.tm.popupmenu_axes1 || obj==h.tm.popupmenu_AS_plot1
    % refresh subpopulations & plot on concatenated traces
    ud_panRanges(h_fig);
end
    
