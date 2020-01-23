function pushbutton_reduce_Callback(obj, evd, h_fig)

h = guidata(h_fig);

dat = get(obj, 'UserData');

dat_next.arrow = flipdim(dat.arrow,1);
dat_next.pos_all = get(h.tm.uipanel_overall, 'Position');
dat_next.pos_single = get(h.tm.uipanel_overview, 'Position');
dat_next.tooltip = get(h.tm.pushbutton_reduce, 'TooltipString');
dat_next.open = abs(dat.open - 1);
dat_next.visible = get(h.tm.popupmenu_axes1, 'Visible');

set(obj, 'CData', dat.arrow, 'TooltipString', dat.tooltip, ...
    'UserData', dat_next);
set(get(h.tm.uipanel_overall, 'Children'), 'Visible', dat.visible);
set(h.tm.uipanel_overall, 'Position', dat.pos_all);
set(h.tm.uipanel_overview, 'Position', dat.pos_single);

if dat_next.open
    plotData_overall(h_fig);

else
    dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
    dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
    cla(h.tm.axes_ovrAll_1);
    cla(h.tm.axes_ovrAll_2);
    set(h.tm.axes_ovrAll_1, 'UserData', dat1, 'GridLineStyle', ':');
    set(h.tm.axes_ovrAll_2, 'UserData', dat2, 'GridLineStyle', ':');
end
