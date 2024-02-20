function h = buildPanelTPsampling(h,p)
% h = buildPanelTPsampling(h,p)
%
% Builds panel "Sampling" in module "Trace processing"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP_sampling: handle to panel "Sampling"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.fntclr2: text color in special pushbuttons
%   p.tbl: reference table listing character's pixel dimensions

% created by MH, 19.2.2024

% default
hedit0 = 20;
htxt0 = 13;
str0 = 'Sampling time:';
str1 = 's';
ttstr0 = wrapHtmlTooltipString('Trajectory <b>sampling time</b> in seconds.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_sampling;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl);
wedit0 = pospan(3)-2*p.mg-wtxt0-wtxt1;

x = p.mg;
y = pospan(4)-p.mgpan-hedit0+(hedit0-htxt0)/2;

h.text_TP_sampling_time = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str0,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_TP_sampling_time = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TP_sampling_time_Callback,h_fig},...
    'tooltipstring',ttstr0);

x = x+wedit0;
y = y+(hedit0-htxt0)/2;

h.text_TP_sampling_s = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt1,htxt0],'string',str1,'horizontalalignment','left');

