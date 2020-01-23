function edit_lim_low_Callback(obj,evd,h_fig,row)

% Last update: by MH, 21.1.2020
% >> calculate histogram at plot & adapt to new data format
%
% update: by RB, 4.1.2018
% >> adapted for FRET-S-histograms
% >> hist2 rather slow replaced by hist2D

h = guidata(h_fig);

dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
plot2x = get(h.tm.popupmenu_axes2x, 'Value');
plot2y = get(h.tm.popupmenu_axes2y, 'Value')-1;
lim_low = str2num(get(obj,'String'));

if row==1
    plot2 = plot2x;
else
    plot2 = plot2y;
end

if lim_low >= dat1.lim(plot2,2)
    setContPan('Lower bound must be lower than higher bound.','error',...
        h_fig);
    return
end

dat1.lim(plot2,1) = lim_low;

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
plotData_overall(h_fig);
    
