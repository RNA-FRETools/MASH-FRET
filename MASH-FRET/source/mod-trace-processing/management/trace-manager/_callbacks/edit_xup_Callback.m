function edit_xup_Callback(obj,evd,h_fig)

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
    xlim_low = dat1.lim(indx,1);
else
    xlim_low = dat3.lim(indx,1,jx);
end

xlim_sup = str2num(get(obj,'String'));

if ~(numel(xlim_sup)==1 && ~isnan(xlim_sup) && ~isinf(xlim_sup) && ...
        xlim_sup>xlim_low)
    setContPan('Higher bound must be higher than lower bound.','error',...
        h_fig);
    return
end

if jx==0 || isTDP
    dat1.lim(indx,2) = xlim_sup;
else
    dat3.lim(indx,2,jx) = xlim_sup;
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);

