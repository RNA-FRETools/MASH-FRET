function pushbutton_update_Callback(obj, evd, h_fig)

% Last update: MH, 24.4.2019
% >> shorten callback by moving content in specific functions 
%    concatenateData, setDataPlotPrm and getStrPlot_overall: this also 
%    avoid re-defining popupmenu string, axis labels and colors everytime 
%    updating the data set
    
% refresh data set
ok = concatenateData(h_fig);
if ~ok
    return
end

% plot new data set in "Plot overall"
plotData_overall(h_fig);

% update panel and plot in "Automatic sorting"
ud_panRanges(h_fig);
plotData_autoSort(h_fig);

% lock settings off if no data is available
h = guidata(h_fig);
dat3 = get(h.tm.axes_histSort,'userdata');
if ~sum(dat3.slct)
    set([h.tm.edit_xlim_low,h.tm.edit_xlim_up,h.tm.edit_xnbiv],...
        'enable','off');
end
    
