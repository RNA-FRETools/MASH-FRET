function edit_xup_Callback(obj,evd,h_fig)

% Last update: by MH, 21.1.2020
% >> calculate histogram at plot & adapt to new data format

h = guidata(h_fig);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
ind = get(h.tm.popupmenu_selectXdata,'value');
j = get(h.tm.popupmenu_selectXval,'value')-1;

if j==0
    xlim_low = dat1.lim(ind,1);
else
    xlim_low = dat3.lim(ind,1,j);
end

xlim_sup = str2num(get(obj,'String'));

if xlim_sup<=xlim_low
    setContPan('Higher bound must be higher than lower bound.','error',...
        h_fig);
    return
end

if j==0
    dat1.lim(ind,2) = xlim_sup;
else
    dat3.lim(ind,2,j) = xlim_sup;
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);

