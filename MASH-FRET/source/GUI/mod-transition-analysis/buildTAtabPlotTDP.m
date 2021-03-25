function h = buildTAtabPlotTDP(h,p)
% h = buildTAtabPlotTDP(h,p)
%
% Builds tab "TDP" in Transition analysis' visualization tabbed panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uitab_TA_plot_TDP: handle to tab "TDP"

% defaults
hbut0 = 20;
htxt0 = 14;
hpop0 = 22;
wedit0 = 40;
lim0 = [-1000,1000];
lim1 = [0,10000];
xlbl0 = 'Value before transition';
ylbl0 = 'Value after transition';
clbl0 = 'normalized occurrence';
str7 = 'x=0 y=0';
str8 = 'cluster:';
str9 = {'Select cluster'};
str10 = 'Set color';
ttstr5 = wrapHtmlTooltipString('Open color picker to set <b>cluster color</b>.');
ttstr6 = wrapHtmlTooltipString('Select a transition cluster');

% parents
h_fig = h.figure_MASH;
h_tab = h.uitab_TA_plot_TDP;

% dimensions
postab = get(h_tab,'position');
wbut0 = getUItextWidth(str10,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wtxt0 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl);
waxes0 = postab(3)-2*p.mg;
haxes0 = postab(4)-p.mgpan-p.mg-hpop0-2*p.mg;

% GUI
x = p.mg;
y = p.mg+(hbut0-htxt0)/2;

h.text_TA_tdpCoord = uicontrol('style','text','parent',h_tab,'units',...
    p.posun,'position',[x,y,waxes0,htxt0],'fontunits',p.fntun,'fontsize',...
    p.fntsz1,'horizontalalignment','left','string',str7);

x = postab(3)-p.mg-wbut0;
y = y-(hbut0-htxt0)/2;

h.pushbutton_TA_setClstClr = uicontrol('style','pushbutton','parent',h_tab,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hbut0],'string',str10,'tooltipstring',ttstr5,'callback',...
    {@pushbutton_TA_setClstClr_Callback,h_fig});

x = x-p.mg-wedit0;
y = y-(hpop0-hbut0)/2;

h.popupmenu_TA_setClstClr = uicontrol('style','popupmenu','parent',h_tab,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hpop0],'string',str9,'tooltipstring',ttstr6,'callback',...
    {@popupmenu_TA_setClstClr_Callback,h_fig});

x = x-p.mg-wtxt0;
y = y+(hpop0-hbut0)/2;

h.text_TA_setClstClr = uicontrol('style','text','parent',h_tab,'units',...
    p.posun,'position',[x,y,wtxt0,htxt0],'fontunits',p.fntun,'fontsize',...
    p.fntsz1,'horizontalalignment','left','string',str8);

x = p.mg;
y = postab(4)-p.mgtab-haxes0;

h.axes_TDPplot1 = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'xlim',lim0,'ylim',...
    lim0,'clim',lim1,'nextplot','replacechildren','xaxislocation','top',...
    'yaxislocation','right','userdata',{[],false},'buttondownfcn',...
    {@axes_TDPplot1_ButtonDownFcn,h_fig});
h_axes = h.axes_TDPplot1;
xlabel(h_axes,xlbl0);
ylabel(h_axes,ylbl0);

h.colorbar_TA = colorbar(h_axes,'units',p.posun);
ylabel(h.colorbar_TA,clbl0);
pos_cb = get(h.colorbar_TA,'position');

tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0-pos_cb(3)-p.mg/2,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

