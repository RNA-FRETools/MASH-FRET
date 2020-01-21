function pushbutton_update_Callback(obj, evd, h_fig)

% Last update: MH, 24.4.2019
% >> shorten callback by moving content in specific functions 
%    concatenateData, setDataPlotPrm and getStrPlot_overall: this also 
%    avoid re-defining popupmenu string, axis labels and colors everytime 
%    updating the data set
    
% refresh data set
ok = concatenateData(h_fig);
if ~ok
    return;
end

% plot new data set in "Plot overall"
plotData_overall(h_fig);

% update panel and plot in "Automatic sorting"
ud_panRanges(h_fig);
plotData_autoSort(h_fig);

% display new histogram limits and bins
h = guidata(h_fig);
dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');

if ~sum(dat3.slct)
    set([h.tm.edit_xlim_low,h.tm.edit_xlim_up,h.tm.edit_xnbiv],...
        'enable','off');
else
    plot2 = get(h.tm.popupmenu_axes2,'value');
    set(h.tm.edit_xlim_low,'string',dat1.lim{plot2}(1,1),'enable',...
        'on');
    set(h.tm.edit_xlim_up,'string',dat1.lim{plot2}(1,2),'enable','on');
    set(h.tm.edit_xnbiv,'string',dat1.niv(plot2,1),'enable','on');
end
    
