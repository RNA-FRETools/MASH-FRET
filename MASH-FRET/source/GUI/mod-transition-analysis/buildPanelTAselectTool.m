function h = buildPanelTAselectTool(h,p)
% h = buildPanelTAselectTool(h,p);
%
% Builds toggle panel for tool selection in "Transition analysis" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_selectTool: handle to toggle panel for tool selection
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.tbl: reference table listing character pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% Created by MH, 24.1.2020

% defaults
hedit0 = 20;
fact = 5;
file_icon1 = 'icon_zoom.png';
file_icon2 = 'icon_crosshair.png';
file_icon3 = 'icon_clear.png';
str0 = char(9668);
ttstr0 = wrapHtmlTooltipString('Switch to <b>cluster selection</b> mode');
ttstr1 = wrapHtmlTooltipString('<b>Clear</b> current selection');
ttstr2 = wrapHtmlTooltipString('Switch to <b>zoom</b> mode');
ttstr3 = wrapHtmlTooltipString('Close');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_selectTool;

% dimensions
pospan = get(h_pan,'position');
hpan = p.mg/2+hedit0+p.mg/2;
wbut0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpan = p.mg/2+3*hedit0+2*p.mg/fact+p.mg/2+wbut0+p.mg/2;

% set panel dimensions
set(h_pan,'position',[pospan(1:2),wpan,hpan]);

% images
img1 = imread(file_icon1);
img2 = imread(file_icon2);
img3 = imread(file_icon3);

% GUI
x = p.mg/2;
y = p.mg/2;

h.tooglebutton_TDPselectZoom = uicontrol('style','togglebutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,hedit0,hedit0],'tooltipstring',ttstr2,'callback',...
    {@tooglebutton_TDPselect_Callback,h_fig,1},'cdata',img1);

x = x+hedit0+p.mg/fact;

h.tooglebutton_TDPselectCross = uicontrol('style','togglebutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,hedit0,hedit0],'tooltipstring',ttstr0,'callback',...
    {@tooglebutton_TDPselect_Callback,h_fig,2},'cdata',img2);

x = x+hedit0+p.mg/fact;

h.pushbutton_TDPselectClear = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,hedit0,hedit0],'tooltipstring',ttstr1,'callback',...
    {@tooglebutton_TDPselect_Callback,h_fig,3},'cdata',img3);

x = x+hedit0+p.mg/2;

h.pushbutton_TDPmanStart = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut0,hedit0],'string',str0,'tooltipstring',ttstr3,...
    'callback',{@tooglebutton_TDPmanStart_Callback,h_fig,'close'});


