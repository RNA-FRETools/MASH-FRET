function h = buildTAtabPlotSim(h,p)
% h = buildTAtabPlotSim(h,p)
%
% Builds tab "Simulation" in Transition analysis' visualization tabbed panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uitab_TA_plot_sim: handle to tab "Simulation"

% defaults
hpop0 = 22;
htxt0 = 14;
lim0 = [0,10000];
xlim0 = [0.5,5.5];
ylim0 = [0,99999];
fntsz = 6;
xlbl0 = "time (sec)";
tick0 = 1:5;
ticklbl0 = repmat({'0.00'},[1,5]);
ticklbl1 = repmat({'0.00\newline0.99'},[1,5]);
ylbl0 = 'population';
ylbl1 = 'nb. of transitions';
str0 = 'state value';
str1 = {'Select a state value'};
ttstr0 = wrapHtmlTooltipString('Select a <b>state value</b> to calculate the dwell time histogram for');

% parents
h_fig = h.figure_MASH;
h_tab = h.uitab_TA_plot_sim;

% dimensions
postab = get(h_tab,'position');
wpop0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
waxes0 = postab(3)-2*p.mg;
haxes0 = 2*(postab(4)-p.mgtab-2*p.mg)/3;
waxes1 = (waxes0-p.mg)/2;
haxes1 = postab(4)-p.mgtab-2*p.mg-haxes0;

% GUI
x = p.mg;
y = p.mg;

h.axes_TA_mdlDt = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',fntsz,'position',[x,y,waxes0,haxes0],'xlim',lim0,'ylim',...
    lim0,'nextplot','replacechildren');
h_axes = h.axes_TA_mdlDt;
xlabel(h_axes,xlbl0);
tiaxes = get(h_axes,'tightinset');
posaxes0 = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes0);

x = posaxes0(1)+posaxes0(3)-p.mg-wpop0;
y = posaxes0(2)+2*p.mg;

h.popupmenu_TA_mdlDtState = uicontrol('style','popupmenu','parent',h_tab,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str1,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_TA_mdlDat_Callback,h_fig});

y = y+hpop0;
h.text_TA_mdlDtState = uicontrol('style','text','parent',h_tab,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str0,'backgroundcolor','white');

x = postab(3)-p.mg-waxes1;
y = postab(4)-p.mgtab-haxes1;

h.axes_TA_mdlTrans = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',fntsz,'position',[x,y,waxes1,haxes1],'xlim',xlim0,'ylim',...
    ylim0,'nextplot','replacechildren','xtick',tick0,'xticklabel',ticklbl1);
h_axes = h.axes_TA_mdlTrans;
ylabel(h_axes,ylbl1);
tiaxes = get(h_axes,'tightinset');
posaxes1 = getRealPosAxes([x,y,waxes1,haxes1],tiaxes,'traces');
posaxes1(3) = posaxes1(3)-...
    (posaxes1(1)+posaxes1(3)-(posaxes0(1)+posaxes0(3)));
set(h_axes,'position',posaxes1);

x = p.mg;

h.axes_TA_mdlPop = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',fntsz,'position',[x,y,waxes1,haxes1],'xlim',xlim0,'ylim',...
    ylim0,'nextplot','replacechildren','xtick',tick0,'xticklabel',ticklbl0);
h_axes = h.axes_TA_mdlPop;
ylabel(h_axes,ylbl0);
tiaxes = get(h_axes,'tightinset');
posaxes2 = getRealPosAxes([x,y,waxes1,haxes1],tiaxes,'traces');
posaxes2(3) = posaxes2(3)-(posaxes0(1)-posaxes2(1));
posaxes2(1) = posaxes0(1);
posaxes2(4) = posaxes1(4);
posaxes2(2) = posaxes1(2);
set(h_axes,'position',posaxes2);

