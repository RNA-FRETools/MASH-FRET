function edit_yrangeUp_Callback(obj,evd,h_fig)

h = guidata(h_fig);
upval = str2num(get(obj,'string'));
lowval = str2num(get(h.tm.edit_yrangeLow,'string'));

if upval<lowval
    upval = lowval;
    disp('The upper bound can not be smaller than the lower bound.');
end

set(obj,'string',num2str(upval));

ud_panRanges(h_fig);
plotData_autoSort(h_fig);
