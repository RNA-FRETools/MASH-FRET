function edit_xlow_Callback(obj,evd,h_fig)

% Last update: by MH, 21.1.2020
% >> calculate histogram at plot & adapt to new data format

h = guidata(h_fig);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
indx = get(h.tm.popupmenu_selectXdata,'value');
jx = get(h.tm.popupmenu_selectXval,'value')-1;
indy = get(h.tm.popupmenu_selectYdata,'value')-1;
jy = get(h.tm.popupmenu_selectYval,'value')-1;
isTDP = (indx==indy & jx==9 & jy==9);

if jx==0 || isTDP
    xlim_sup = dat1.lim(indx,2);
else
    xlim_sup = dat3.lim(indx,2);
end

xlim_low = str2num(get(obj,'String'));

if ~(numel(xlim_low)==1 && ~isnan(xlim_low) && ~isinf(xlim_low) && ...
        xlim_low<xlim_sup)
    setContPan('Lower bound must be lower than higher bound.','error',...
        h_fig);
    return
end

if jx==0 || isTDP
    dat1.lim(indx,1) = xlim_low;
else
    dat3.lim(indx,1,jx) = xlim_low;
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);

