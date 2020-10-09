function edit_nbiv_Callback(obj,evd,h_fig,col)

% Last update: by MH, 21.1.2020
% >> calculate histogram at plot & adapt to new data format
%
% update: by RB 5.1.2018
% >> adapted for FRET-S-histograms
% >> hist2 rather slow replaced by hist2D
    
h = guidata(h_fig);

dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
plot2x = get(h.tm.popupmenu_axes2x, 'Value');
plot2y = get(h.tm.popupmenu_axes2y, 'Value')-1;
nbiv = round(str2num(get(obj, 'String')));

if col==1
    plot2 = plot2x;
else
    plot2 = plot2y;
end

if ~isnumeric(nbiv) || nbiv < 1
    setContPan('Number of binning interval must be a number.','error',...
        h_fig);
    return
end

dat1.niv(plot2) = nbiv;

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
plotData_overall(h_fig);

