function ok = edit_ylow_Callback(obj,evd,h_fig)

% Last update: by MH, 21.1.2020
% >> calculate histogram at plot & adapt to new data format

% defaults
ok = 0;

h = guidata(h_fig);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
indx = get(h.tm.popupmenu_selectXdata,'value');
jx = get(h.tm.popupmenu_selectXval,'value')-1;
indy = get(h.tm.popupmenu_selectYdata,'value')-1;
jy = get(h.tm.popupmenu_selectYval,'value')-1;
isTDP = (indx==indy & jx==9 & jy==9);

% no y-data: abort
if indy==0 || isTDP
    return
end

if jy==0
    ylim_sup = dat1.lim(indy,2);
else
    ylim_sup = dat3.lim(indy,2,jy);
end

ylim_low = str2num(get(obj,'String'));

if ~(numel(ylim_low)==1 && ~isnan(ylim_low) && ~isinf(ylim_low) && ...
        ylim_low<ylim_sup)
    setContPan('Lower bound must be lower than higher bound.','error',...
        h_fig);
    return
end

if jy==0
    dat1.lim(indy,1) = ylim_low;
else
    dat3.lim(indy,1,jy) = ylim_low;
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);

ok = 1;
