function edit_lim_up_Callback(obj,evd,h_fig,row)

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
lim_up = str2num(get(obj,'String'));

if row==1
    plot2 = plot2x;
else
    plot2 = plot2y;
end

if lim_up <= dat1.lim(plot2,1)
    setContPan('Higher bound must be higher than lower bound.','error',...
        h_fig);
    return
end

dat1.lim(plot2,2) = lim_up;

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
plotData_overall(h_fig);
    
