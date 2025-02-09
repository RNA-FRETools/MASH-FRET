function edit_xniv_Callback(obj,evd,h_fig)

% Last update: by MH, 21.1.2020
% >> calculate histogram at plot & adapt to new data format

h = guidata(h_fig);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
datid = getASdataindex;
indx = get(h.tm.popupmenu_selectXdata,'value');
jx = datid(get(h.tm.popupmenu_selectXval,'value'));
indy = get(h.tm.popupmenu_selectYdata,'value')-1;
jy = datid(get(h.tm.popupmenu_selectYval,'value'));
isTDP = (indx==indy & jx==9 & jy==9);

niv = str2num(get(obj,'string'));

if ~(numel(niv)==1 && ~isnan(niv) && ~isinf(niv))
    setContPan('Number of bins must be a numeric.','error',h_fig);
    return
end

if jx==0 || isTDP
    dat1.niv(indx) = niv;
else
    dat3.niv(jx,indx) = niv;
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);

