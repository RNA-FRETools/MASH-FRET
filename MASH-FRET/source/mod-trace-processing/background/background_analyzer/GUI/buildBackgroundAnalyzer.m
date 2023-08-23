function h_fig2 = buildBackgroundAnalyzer(h_fig)
% h_fig2 = buildBackgroundAnalyzer(h_fig)
%
% Build GUI of Background analyzer
%
% h_fig: handle to main figure
% h_fig2: handle to Background analyzer figure

% defaults
posun = 'pixels'; % position and dimension units
fntun = 'points'; % font units
fntsz = 8; % common font size
mg = 10; % common margin
mgpan = 20; % top margin inside a panel (includes title)
htxt = 14;
hedit = 20;
hpop = 22;
hbut = 22;
hcb = 20;
wedit = 40;
wbox = 15; % box width in checkboxes
wbrd = 6; % width of pushbutton borders
warr = 20; % width of downwards arrow in popupmenu
fntclr2 = 'blue'; % text color in special pushbuttons
ttl0 = 'Method settings';
ttl1 = 'Parameter screening';
xlbl = 'Parameter 1';
ylbl = 'BG intensity (counts/sec/pix)';
axttl = 'Sub-image dim. = 50 pixels';
axlim = [-10000 10000];
str0 = 'XXXXX at 999nm';
str1 = 'Most frequent value';
str2 = 'auto';
str3 = 'Show';
str4 = 'apply to all moelcules';

% collect inetrface parameters
h = guidata(h_fig);
tbl = h.charDimTable;

% build structure with layout parameters
p = struct('posun',posun,'fntun',fntun,'fntsz',fntsz,'fntclr2',fntclr2,...
    'mg',mg,'mgpan',mgpan,'htxt',htxt,'hedit',hedit,'hpop',hpop,'hbut',...
    hbut,'hcb',hcb,'wedit',wedit,'wbox',wbox,'wbrd',wbrd,'warr',warr);
p.tbl = tbl;

% dimensions
posfig = getPixPos(h_fig);
wpop0 = getUItextWidth(str0,fntun,fntsz,'normal',tbl) + warr;
wpop1 = getUItextWidth(str1,fntun,fntsz,'normal',tbl) + warr;
wcb0 = getUItextWidth(str2,fntun,fntsz,'normal',tbl) + wbox;
wbut0 = getUItextWidth(str3,fntun,fntsz,'normal',tbl) + wbrd;
wcb1 = getUItextWidth(str4,fntun,fntsz,'normal',tbl) + wbox;
wpan0 = mg+wpop0+mg+wpop1+mg+4*(wedit+mg)+wcb0+mg+wbut0+mg;
hpan0 = mgpan+htxt+hpop+hcb+mg+htxt+hbut+mg;
wpan1 = mg+wcb1+mg;
hpan1 = mgpan+hcb+mg+htxt+10*(hedit+mg/2)+mg/2+hcb+mg+hbut+mg;
haxes = hpan1;
waxes = wpan0-wpan1-mg;
wfig = mg+wpan0+mg;
hfig = mg+hpan0+mg+hpan1+mg;

q = struct();

x = posfig(1)+(posfig(3)-wfig)/2;
y = posfig(2)+(posfig(4)-hfig)/2;

q.figure_bgopt = figure('name','Background analyzer','visible','off',...
    'numbertitle','off','menubar','none','units',posun,'position',...
    [x,y,wfig,hfig],'closerequestfcn',...
    {@figure_bgopt_CloseRequestFcn,h_fig});
h_fig2 = q.figure_bgopt;

x = mg;
y = hfig-mg-hpan0;

q.uipanel_determine_bg = uipanel('parent',h_fig2,'title',ttl0,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wpan0,hpan0],...
    'fontweight','bold');
q = build_BA_panelMethodSettings(q,p,h_fig);

y = mg;

q.uipanel_opt = uipanel('parent',h_fig2,'title',ttl1,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wpan1,hpan1],...
    'fontweight','bold');
q = build_BA_panelParameterScreening(q,p,h_fig);

x = x+wpan1+mg;

q.axes_plot_bgint = axes('parent',h_fig2,'units',posun,'fontunits',fntun,...
    'fontsize',fntsz,'nextplot','replacechildren','xlim',axlim,'ylim',...
    axlim);
h_axes = q.axes_plot_bgint;
title(h_axes,axttl);
xlabel(h_axes,xlbl);
ylabel(h_axes,ylbl);
pos = getRealPosAxes([x,y,waxes,haxes],get(h_axes,'tightinset'),'traces');
set(h_axes,'position',pos);
set(h_axes,'visible','off');

q.figure_MASH = h_fig;

guidata(h_fig2,q);

setProp(h_fig2,'units','normalized');

