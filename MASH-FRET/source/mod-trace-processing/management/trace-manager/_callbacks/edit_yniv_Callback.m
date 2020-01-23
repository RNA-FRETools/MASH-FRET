function edit_yniv_Callback(obj,evd,h_fig)

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

niv = str2num(get(obj,'string'));

if ~(numel(niv)==1 && ~isnan(niv) && ~isinf(niv))
    setContPan('Number of bins must be a numeric.','error',h_fig);
    return
end

if j==0
    dat1.niv(ind) = niv;
else
    dat3.niv(j,ind) = niv;
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);

