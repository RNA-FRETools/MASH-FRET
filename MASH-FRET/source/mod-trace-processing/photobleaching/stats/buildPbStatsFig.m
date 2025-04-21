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
xlbl2 = 'blink-on dwell times';
sttl1 = '(off times)';
sttl2 = '(on-times)';
str0a = 'Emitter:';
str0b = 'axis scale';
str1 = {'linear-linear','linear-log','log-linear','log-log'};
str3 = 'Export';
ttstr0a = wrapHtmlTooltipString('<b>Select an emitter</b> to calculate photobleaching/blinking statistics for.');
ttstr0b = wrapHtmlTooltipString('<b>Axis scale</b> used to plot survival and blinking time histograms: <b>linear-linear</b> (x and y axis in linear scale), <b>log-linear</b> (x axis in log scale and y axis in linear scale), <b>linear-log</b> (x axis in linear scale and y axis in log scale), and <b>log-log</b> (x and y axis in log scale).');
ttstr2 = wrapHtmlTooltipString('<b>Export fitting results</b>: survival and blinking time histogram together with fitting parameters will be written to text files.');

% retrieve dimension parameters
h0 = guidata(fig0);
p = h0.dimprm;
str0c = h0.popupmenu_bleachChan.String;
nEm = numel(str0c);


% calculate dimensions and positions
pos0 = getPixPos(fig0);
xfig = pos0(1,1)+(pos0(1,3)-wfig)/2;
yfig = pos0(1,2)+(pos0(1,4)-hfig)/2;
wtxt0 = getUItextWidth(str0a,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = getUItextWidth(str0b,p.fntun,p.fntsz1,'normal',p.tbl);
wpop1 = getUItextWidth(maxlengthstr(str1),p.fntun,p.fntsz1,'normal',p.tbl)+p.warr;
wbut1 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpop1 = max([wpop1,wtxt1]);
wax0 = (wfig-3*p.mg)/2;
wax1 = (wax0-p.mg)/2;
hax0 = hfig-3*p.mg-p.htxt0-p.hpop0;
hax1 = (hax0-p.mg)/2;
wpop0 = max([wtxt0,getUItextWidth(maxlengthstr(removeHtml(str1)),p.fntun,...
    p.fntsz1,'normal',p.tbl)+p.warr;]);

% build GUI
fig = figure('units',p.posun,'numbertitle','off','menubar','none',...
    'position',[xfig,yfig,wfig,hfig],'visible','on','name',fignm);
h.fig_pbstats = fig;
set(fig,'closerequestfcn',{@fig_pbStats_CloseRequestFcn,fig0});

x = p.mg;
y = hfig-p.mg;

h.text_emitter = uicontrol('style','text','parent',fig,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0a,'position',...
    [x,y,wpop0,p.htxt0]);

y = y-p.hpop0;

h.popup_emitter = uicontrol('style','popupmenu','parent',fig,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpop0,p.hpop0],...
    'string',str0c,'tooltipstring',ttstr0a,'callback',...
    {@popup_emitter_Callback,fig});

x = x+wpop0+p.mg;
y = y+p.hpop0;

h.text_scale = uicontrol('style','text','parent',fig,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0b,'position',...
    [x,y,wpop1,p.htxt0]);

y = y-p.hpop0;

h.popup_scale = uicontrol('style','popupmenu','parent',fig,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,p.hpop0],'string',str1,'value',2,'tooltipstring',ttstr0b,...
    'callback',{@ud_pbstats,fig,'all'});

x = x+wpop1+p.mg;
y = y+(p.hpop0-p.hedit0)/2;

h.push_export = uicontrol('style','pushbutton','parent',fig,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,p.hedit0],'string',str3,'tooltipstring',ttstr2,'callback',...
    {@export_pbstats,fig,'all'});

x = p.mg;
y = p.mg;

h.axes_bleachstats = axes('parent',fig,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,wax0,hax0],'nextplot',...
    'replacechildren','userdata',cell(1,nEm));
ax0 = h.axes_bleachstats;
xlabel(ax0,xlbl0);
ylabel(ax0,ylbl0);
title(ax0,ttl0,'fontweight','bold');
subtitle(ax0,sttl0);
tiaxes = get(ax0,'tightinset');
posax0 = getRealPosAxes([x,y,wax0,hax0],tiaxes,'traces');
ax0.Position = posax0;

x0 = p.mg+wax0+p.mg;
y0 = hfig-2*p.mg-p.htxt0-p.hpop0-hax1;

h.axes_blinkoff = axes('parent',fig,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x0,y0,wax1,hax1],'nextplot',...
    'replacechildren','userdata',cell(1,nEm));
ax1 = h.axes_blinkoff;

x1 = p.mg+wax0+p.mg+wax1+p.mg;

h.axes_blinkon = axes('parent',fig,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x1,y0,wax1,hax1],'nextplot',...
    'replacechildren','userdata',cell(1,nEm));
ax2 = h.axes_blinkon;

y1 = y0-p.mg-hax1;

h.axes_blinkschm = axes('parent',fig,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x0,y1,wax0,hax1],'nextplot',...
    'replacechildren','xtick',[],'ytick',[],'color',fig.Color,'xlim',[0,1],...
    'ylim',[0,1]);
ax3 = h.axes_blinkschm;

xlabel(ax1,xlbl1);
xlabel(ax2,xlbl2);
ylabel([ax1,ax2],ylbl0);
title([ax1,ax2],ttl1,'fontweight','bold');
subtitle(ax1,sttl1);
subtitle(ax2,sttl2);
box([ax0,ax1,ax2,ax3],'on');

ax1.Position = getRealPosAxes([x0,y0,wax1,hax1],ax1.TightInset,'traces');
ax2.Position = getRealPosAxes([x1,y0,wax1,hax1],ax2.TightInset,'traces');
dimax3 = y+hax1-ax0.Position(2);
ax3.Position = [ax1.Position(1)+...
    (ax2.Position(1)+ax2.Position(3)-ax1.Position(1)-dimax3)/2,...
    ax0.Position(2),dimax3,dimax3];

% convert units to normalized
setProp(fig,'units','normalized');

% save handles to figure's data
h.fig_MASH = fig0;
guidata(fig,h);
