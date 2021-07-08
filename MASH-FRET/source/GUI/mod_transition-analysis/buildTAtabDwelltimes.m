function h = buildTAtabDwelltimes(h,p)
% h = buildTAtabDwelltimes(h,p)
%
% Builds tab "Dwell times" in "Kinetic model" panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uitab_TA_dwelltimes: handle to tab "Dwell times"

% defaults
hpop0 = 22;
htxt0 = 14;
lim0 = [0,10000];
xlbl0 = "time (sec)";
fntsz = 6;
str0 = 'state value';
str1 = {'Select a state value'};
ttstr0 = wrapHtmlTooltipString('Select a <b>state value</b> to calculate the dwell time histogram for');

% parents
h_fig = h.figure_MASH;
h_tab = h.uitab_TA_dwelltimes;

% dimensions
postab = get(h_tab,'position');
wpop0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
waxes0 = postab(3)-2*p.mg;
haxes0 = postab(4)-2*p.mg;

% GUI
x = p.mg;
y = p.mg;

h.axes_TA_mdlDt = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',fntsz,'position',[x,y,waxes0,haxes0],'xlim',lim0,'ylim',...
    lim0,'nextplot','replacechildren');
h_axes = h.axes_TA_mdlDt;
xlabel(h_axes,xlbl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

x = posaxes(1)+posaxes(3)-p.mg-wpop0;
y = posaxes(2)+2*p.mg;

h.popupmenu_TA_mdlDtState = uicontrol('style','popupmenu','parent',h_tab,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str1,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_TA_mdlDat_Callback,h_fig});

y = y+hpop0;
h.text_TA_mdlDtState = uicontrol('style','text','parent',h_tab,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str0,'backgroundcolor','white');
