function edit_yrangeLow_Callback(obj,evd,h_fig)

h = guidata(h_fig);
lowval = str2num(get(obj,'string'));
upval = str2num(get(h.tm.edit_yrangeUp,'string'));

if lowval>upval
    lowval = upval;
    disp('The lower bound can not be higher than the upper bound.');
end

set(obj,'string',num2str(lowval));

ud_panRanges(h_fig);
plotData_autoSort(h_fig);
