function pushbutton_dismissRange_Callback(obj,evd,h_fig)

h = guidata(h_fig);

range = get(h.tm.listbox_ranges,'value');
str_range = get(h.tm.listbox_ranges,'string');
if strcmp(str_range{range},'no range')
    return;
end

dat3 = get(h.tm.axes_histSort,'userdata');

dat3.range(range,:) = [];
dat3.rangeTags(range,:) = [];

set(h.tm.axes_histSort,'userdata',dat3);

ud_panRanges(h_fig);
plotData_autoSort(h_fig);

