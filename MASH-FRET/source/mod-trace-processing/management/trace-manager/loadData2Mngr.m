function ok = loadData2Mngr(h_fig)

% build GUI
buildTraceManager(h_fig);

% load data from MASH
ok = loadDataFromMASH(h_fig);
if ~ok
    return;
end

% assign data-specific plot colors and axis labels
setDataPlotPrm(h_fig);

% concatenate data and assign axis limits
ok = concatenateData(h_fig);
if ~ok
    return;
end

% plot data in panel "Overall plot" and "Molecule selection"
plotData_overall(h_fig)
plotDataTm(h_fig);

% plot data in panel "Auto sorting"
plotData_autoSort(h_fig);

% plot data in panel "Video view"
plotData_videoView(h_fig);
    
