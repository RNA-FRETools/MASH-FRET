function h = buildPanelTAclusters(h,p)
% h = buildPanelTAclusters(h,p);
%
% Builds panel "Clusters" in "Transition analysis" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_clusters: handle to panel "Clutsters"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.wttsr: pixel width of tooltip box
%   p.tbl: reference table listing character pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% Created by MH, 8.11.2019

% defaults
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
fact = 5;
str0 = '\default';
str1 = '+';
str2 = 'cluster';
str3 = 'cluster chape';
str4 = {'spherical','ellipsoid straight','ellipsoid diagonal','free'};
str5 = 'value';
str6 = 'radius';
ttstr0 = wrapStrToWidth('Make cluster centers <u>evenly spaced</u> (<b>starting guess</b>).',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('Choose a <b>selection tool</b> for setting manually cluster centers and associated tolerance radii (<b>starting guess</b>).',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Start clustering</b> with current method settings.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_clusters;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = pospan(3)-2*p.mg;
wedit0 = (pospan(3)-2*p.mg-p.mg/fact)/2;
wbut1 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut0 = wtxt0-wbut1-p.mg/fact;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TDPstate = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str3);

y = y-hedit0;

h.popupmenu_TDPstate = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hpop0],'callback',{@popupmenu_TDPstate_Callback,h_fig},...
    'string',str4);

y = y-p.mg/2-htxt0;

h.text_TDPiniVal = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str5);

x = x+wedit0+p.mg/fact;

h.text_TDPradius = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str6);

x = p.mg;
y = y-hedit0;

h.edit_TDPiniVal = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_TDPiniVal_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TDPradius = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_TDPradius_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-hedit0;

h.pushbutton_TDPautoStart = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@pushbutton_TDPautoStart_Callback,h_fig});

x = x+wbut0+p.mg/fact;

h.tooglebutton_TDPmanStart = uicontrol('style','togglebutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut1,hedit0],'string',str1,'tooltipstring',ttstr1,...
    'callback',{@tooglebutton_TDPmanStart_Callback,h_fig,'open'},...
    'userdata',0);

x = p.mg;
y = y-p.mg/2-hedit0;

h.pushbutton_TDPupdateClust = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wtxt0,hedit0],'string',str2,'tooltipstring',ttstr2,...
    'callback',{@pushbutton_TDPupdateClust_Callback,h_fig});


