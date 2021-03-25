function h = buildTAtabPlotDt(h,p)
% h = buildTAtabPlotDt(h,p)
%
% Builds tab "Dwell times" in Transition analysis' visualization tabbed panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uitab_TA_plot_dt: handle to tab "Dwell times"

% defaults
hbut0 = 20;
lim0 = [0,10000];
xlbl0 = 'dwell-times (s)';
ylbl0 = 'normalized (1 - cum(P))';
axttl0 = 'Kinetic analysis from dwell-times';
str0 = 'y-log scale';
ttstr0 = wrapHtmlTooltipString('Show histogram''s y-axis in a <b>logarithmic scale</b>.');

% parents
h_fig = h.figure_MASH;
h_tab = h.uitab_TA_plot_dt;

% dimensions
postab = get(h_tab,'position');
waxes0 = postab(3)-2*p.mg;
haxes0 = postab(4)-p.mgpan-2*p.mg;
wbut0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;

% GUI
x = p.mg;
y = p.mg;

h.axes_TDPplot2 = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'xlim',lim0,'ylim',...
    lim0, 'nextplot', 'replacechildren');
h_axes = h.axes_TDPplot2;
xlabel(h_axes,xlbl0);
ylabel(h_axes,ylbl0);
title(h_axes,axttl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

x = posaxes(1)+posaxes(3)-p.mg-wbut0;
y = posaxes(2)+posaxes(4)-p.mg-hbut0;

h.pushbutton_TDPfit_log = uicontrol('style','pushbutton','parent',h_tab,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hbut0],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@pushbutton_TDPfit_log_Callback,h_fig});

