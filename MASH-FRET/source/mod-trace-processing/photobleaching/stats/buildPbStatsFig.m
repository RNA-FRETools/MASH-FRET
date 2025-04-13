function fig = buildPbStatsFig(fig0)
% fig = buildPbStatsFig(fig0)
%
% Builds Photobleaching/blinking stats window and returns figure handle.
%
% fig0: handle to main MASH figure
% fig: handle to Photobleaching/blinking stats figure

% defaults
fignm = 'Photobleaching/blinking stats';
wfig = 800;
hfig = 600;
ttl0 = 'Survival stats';
sttl0 = '(photobleaching)';
ttl1 = 'Blinking stats';
xlbl0 = 'survival times';
ylbl0 = 'normalized count';
xlbl1 = 'blink-off dwell times';
str0a = 'emitter:';
str0b = 'axis scale';
str1 = {'linear-linear','linear-log','log-linear','log-log'};
str3 = 'Export';
ttstr0a = wrapHtmlTooltipString('<b>Select an emitter</b> to calculate photobleaching/blinking statistics for.');
ttstr0b = wrapHtmlTooltipString('<b>Axis scale</b> used to calculate and plot survival time histograms: <b>linear-linear</b> (x and y axis in linear scale), <b>log-linear</b> (x axis in log scale and y axis in linear scale), <b>linear-log</b> (x axis in linear scale and y axis in log scale), and <b>log-log</b> (x and y axis in log scale).');
ttstr2 = wrapHtmlTooltipString('<b>Export fitting results</b>: survival time histogram and fitting parameters will be written to text files.');
ttstr3 = wrapHtmlTooltipString('<b>Axis scale</b> used to calculate and plot blink-off time histograms: <b>linear-linear</b> (x and y axis in linear scale), <b>log-linear</b> (x axis in log scale and y axis in linear scale), <b>linear-log</b> (x axis in linear scale and y axis in log scale) and <b>log-log</b> (x and y axis in log scale).');
ttstr5 = wrapHtmlTooltipString('<b>Export fitting results</b>: blink-off time histogram and fitting parameters will be written to text files.');

% retrieve dimension parameters
h0 = guidata(fig0);
p = h0.dimprm;
str0c = h0.popupmenu_bleachChan.String;

% calculate dimensions and positions
pos0 = getPixPos(fig0);
xfig = pos0(1,1)+(pos0(1,3)-wfig)/2;
yfig = pos0(1,2)+(pos0(1,4)-hfig)/2;
wtxt0 = getUItextWidth(str0a,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = getUItextWidth(str0b,p.fntun,p.fntsz1,'normal',p.tbl);
wpop1 = getUItextWidth(str1{1},p.fntun,p.fntsz1,'normal',p.tbl)+p.warr;
wbut1 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpop1 = max([wpop1,wtxt1,wbut1]);
wax = (wfig-3*p.mg)/2;
hax = hfig-2*p.mg;
wpop0 = wax/5;

% build GUI
fig = figure('units',p.posun,'numbertitle','off','menubar','none',...
    'position',[xfig,yfig,wfig,hfig],'visible','on','name',fignm);
h.fig_pbstats = fig;
set(fig,'closerequestfcn',{@fig_pbStats_CloseRequestFcn,fig0});

x = p.mg;
y = hfig-p.mg-p.hpop0+(p.hpop0-p.htxt0)/2;

h.text_emitter = uicontrol('style','text','parent',fig,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0a,'position',...
    [x,y,wtxt0,p.htxt0]);

x = x+wtxt0+p.mg;
y = y-(p.hpop0-p.htxt0)/2;

h.popup_emitter = uicontrol('style','popupmenu','parent',fig,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpop0,p.hpop0],...
    'string',str0c,'tooltipstring',ttstr0a,'callback',...
    {@popup_emitter_Callback,fig});

x = p.mg;
y = p.mg;

h.axes_bleachstats = axes('parent',fig,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,wax,hax],'nextplot',...
    'replacechildren');
ax = h.axes_bleachstats;
xlabel(ax,xlbl0);
ylabel(ax,ylbl0);
title(ax,ttl0,'fontweight','bold');
subtitle(ax,sttl0);
tiaxes = get(ax,'tightinset');
posax0 = getRealPosAxes([x,y,wax,hax],tiaxes,'traces');
ax.Position = posax0;

x = posax0(1)+posax0(3)-p.mg-wpop1;
y = posax0(2)+posax0(4)-p.mg-p.htxt0;

h.text_bleachscale = uicontrol('style','text','parent',fig,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0b,'position',...
    [x,y,wpop1,p.htxt0],'backgroundcolor',ax.Color);

y = y-p.hpop0;

h.popup_bleachscale = uicontrol('style','popupmenu','parent',fig,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,p.hpop0],'string',str1,'tooltipstring',ttstr0b,'callback',...
    {@ud_pbstats,fig,'bleach'});

y = y-p.mg-p.hedit0;

h.push_bleachexport = uicontrol('style','pushbutton','parent',fig,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,p.hedit0],'string',str3,'tooltipstring',ttstr2,'callback',...
    {@export_pbstats,fig,'bleach'});

x = p.mg+wax+p.mg;
y = p.mg;

h.axes_blinkstats = axes('parent',fig,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,wax,hax],'nextplot',...
    'replacechildren');
ax = h.axes_blinkstats;
xlabel(ax,xlbl1);
ylabel(ax,ylbl0);
title(ax,ttl1,'fontweight','bold');
tiaxes = get(ax,'tightinset');
posax1 = getRealPosAxes([x,y,wax,hax],tiaxes,'traces');
posax1([2,4]) = posax0([2,4]);
ax.Position = posax1;

x = posax1(1)+posax1(3)-p.mg-wpop1;
y = posax1(2)+posax1(4)-p.mg-p.htxt0;

h.text_blinkscale = uicontrol('style','text','parent',fig,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0b,'position',...
    [x,y,wpop1,p.htxt0],'backgroundcolor',ax.Color);

y = y-p.hpop0;

h.popup_blinkscale = uicontrol('style','popupmenu','parent',fig,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,p.hpop0],'string',str1,'tooltipstring',ttstr3,'callback',...
    {@ud_pbstats,fig,'blink'});

y = y-p.mg-p.hedit0;

h.push_blinkexport = uicontrol('style','pushbutton','parent',fig,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,p.hedit0],'string',str3,'tooltipstring',ttstr5,'callback',...
    {@export_pbstats,fig,'blink'});

% save handles to figure's data
h.fig_MASH = fig0;
guidata(fig,h);
