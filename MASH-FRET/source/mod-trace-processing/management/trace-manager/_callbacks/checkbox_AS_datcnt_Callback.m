function checkbox_AS_datcnt_Callback(obj,evd,h_fig)

set(obj,'userdata',get(obj,'value'));

plotData_autoSort(h_fig);
ud_panRanges(h_fig);