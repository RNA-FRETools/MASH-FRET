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
str3 = 'cluster shape';
str4 = 'state';
str5 = {'spherical','ellipsoid straight','ellipsoid diagonal','free'};
str6 = {'Select a state'};
str7 = 'likelihood';
str8 = 'value';
str9 = 'radius';
str10 = {'complete data','incomplete data'};

ttstr0 = wrapStrToWidth('Make cluster centers <u>evenly spaced</u> (<b>starting guess</b>).',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('Choose a <b>selection tool</b> for setting manually cluster centers and associated tolerance radii (<b>starting guess</b>).',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Start clustering</b> with current method settings.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('Select a state to configure',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Cluster x-radius</b>: used for <b>k-mean</b> or <b>manual</b> clustering',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('<b>Cluster x-center</b>: used for <b>k-mean</b> or <b>manual</b> clustering',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr6 = wrapStrToWidth('<b>Cluster y-center</b>: used for <b>k-mean</b> or <b>manual</b> clustering',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr7 = wrapStrToWidth('<b>Cluster y-radius</b>: used for <b>k-mean</b> or <b>manual</b> clustering',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr8 = wrapStrToWidth('<b>Cluster shape</b> for <b>GM</b> clustering',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr9 = wrapStrToWidth('<b>Likelihood calculation:</b> with complete data, each transition is associated to one and only cluster (subject to underestimation of model complexity), whereas with incomplete data, transitions have a non-null probability to belong to each cluster (subject to overestimation of model complexity).',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_clusters;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = pospan(3)-2*p.mg;
wedit0 = (pospan(3)-2*p.mg-2*p.mg/fact)/3;
wbut1 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut0 = wtxt0-wbut1-p.mg/fact;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TDPshape = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str3);

h.text_TDPstate = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str4,'visible','off');

x = x+wedit0+p.mg/fact;

h.text_TDPiniVal = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str8,'visible','off');

x = x+wedit0+p.mg/fact;

h.text_TDPradius = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str9,'visible','off');

x = p.mg;
y = y-hpop0;

h.popupmenu_TDPshape = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hpop0],'callback',{@popupmenu_TDPshape_Callback,h_fig},...
    'string',str5,'tooltipstring',ttstr8);

h.popupmenu_TDPstate = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hpop0],'callback',{@popupmenu_TDPstate_Callback,h_fig},...
    'string',str6,'tooltipstring',ttstr3,'visible','off');

y = y+(hpop0-hedit0)/2;
x = x+wedit0+p.mg/fact;

h.edit_TDPiniValX = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TDPiniVal_Callback,1,h_fig},...
    'tooltipstring',ttstr5,'visible','off');

x = x+wedit0+p.mg/fact;

h.edit_TDPradiusX = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TDPradius_Callback,1,h_fig},...
    'tooltipstring',ttstr4,'visible','off');

x = x-p.mg/fact-wedit0;
y = y-p.mg/fact-hedit0;

h.edit_TDPiniValY = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TDPiniVal_Callback,2,h_fig},...
    'tooltipstring',ttstr6,'visible','off');

x = x+wedit0+p.mg/fact;

h.edit_TDPradiusY = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TDPradius_Callback,2,h_fig},...
    'tooltipstring',ttstr7,'visible','off');

x = p.mg;
y = y+p.mg/fact+hedit0-(hpop0-hedit0)/2-p.mg/2-htxt0;

h.text_TDPlike = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str7);

y = y-hpop0;

h.popupmenu_TDPlike = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hpop0],'callback',{@popupmenu_TDPlike_Callback,h_fig},...
    'string',str10,'tooltipstring',ttstr9);

x = p.mg;
y = y-p.mg/fact-hedit0;

h.pushbutton_TDPautoStart = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@pushbutton_TDPautoStart_Callback,h_fig},'visible','off');

x = x+wbut0+p.mg/fact;

h.tooglebutton_TDPmanStart = uicontrol('style','togglebutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut1,hedit0],'string',str1,'tooltipstring',ttstr1,...
    'callback',{@tooglebutton_TDPmanStart_Callback,h_fig,'open'},...
    'userdata',0,'visible','off');

x = p.mg;
y = y-p.mg/2-hedit0;

h.pushbutton_TDPupdateClust = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wtxt0,hedit0],'string',str2,'tooltipstring',ttstr2,...
    'callback',{@pushbutton_TDPupdateClust_Callback,h_fig});


