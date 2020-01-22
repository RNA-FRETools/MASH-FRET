function edit_ylow_Callback(obj,evd,h_fig)

% Last update: by MH, 21.1.2020
% >> calculate histogram at plot & adapt to new data format

h = guidata(h_fig);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
ind = get(h.tm.popupmenu_selectYdata,'value')-1;
j = get(h.tm.popupmenu_selectYval,'value')-1;

% no y-data: abort
if ind==0
    return
end

if j==0
    ylim_sup = dat1.lim(ind,2);
else
    ylim_sup = dat3.lim(ind,2,j);
end

ylim_low = str2num(get(obj,'String'));

if ylim_low >= ylim_sup
    setContPan('Lower bound must be lower than higher bound.','error',...
        h_fig);
    return
end

if j==0
    dat1.lim(ind,1) = ylim_low;
else
    dat3.lim(ind,1,j) = ylim_low;
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);
