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
fact = 5;
str0 = {'Select a state value'};
ttstr0 = wrapHtmlTooltipString('Select a <b>state value</b> to calculate the dwell time histogram for');

% parents
h_fig = h.figure_MASH;
h_tab = h.uitab_TA_dwelltimes;

% dimensions
postab = get(h_tab,'position');
wpop0 = (postab(3)-2*p.mg-p.mg/fact)/2;
waxes0 = postab(3)-2*p.mg;
haxes0 = postab(4)-3*p.mg-hpop0;

% GUI
x = p.mg;
y = postab(4)-p.mg-hpop0;

h.popupmenu_TA_mdlDtState = uicontrol('style','popupmenu','parent',h_tab,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_TA_mdlDat_Callback,h_fig});

y = y-p.mg-haxes0;

h.axes_TA_mdlDt = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'nextplot',...
    'replacechildren','box','on','xtick',[],'ytick',[]);
