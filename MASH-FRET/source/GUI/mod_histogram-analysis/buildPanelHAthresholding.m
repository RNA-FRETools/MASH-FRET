function h = buildPanelHAthresholding(h,p)
% h = buildPanelHAthresholding(h,p)
%
% Builds "Thresholding" panel in module "Histogram analysis"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_HA_thresholding: handle to panel "Thresholding"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbox: box's pixel width in checkboxes
%   p.tbl: reference table listing character pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 6.11.2019

% default
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
fact = 5;
str0 = 'threshold nb.:';
str1 = 'Start';
str2 = 'value';
str3 = {'Select a threshold'};
str4 = 'relative pop.:';
str5 = 'sigma';
str6 = {'Select a state'};
str7 = 'color:';
ttstr0 = wrapHtmlTooltipString('<b>Number of thresholds</b> used to separate and integrate histogram peaks.');
ttstr1 = wrapHtmlTooltipString('<b>Start peak integration</b> with thresholding.');
ttstr2 = wrapHtmlTooltipString('<b>Threshold value:</b> thresholds appear as vertical black bars on top and bottom plots; threshold values can be automatically calculated and imported from an inferred state configuration in panel "State configurations".');
ttstr3 = wrapHtmlTooltipString('<b>Select a threshold</b> to set its value.');
ttstr4 = wrapHtmlTooltipString('<b>Select a state</b> to show the corresponding relative population, bootstrapping results and associated plot color.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_HA_thresholding;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl);
wbut0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wedit0 = (pospan(3)-2*p.mg-2*p.mg/fact-wtxt0)/2;
mgbut = pospan(3)-2*p.mg-2*p.mg/fact-wtxt0-wedit0-wbut0;
mgres = pospan(4)-p.mgpan-p.mg-p.mg/2-p.mg/fact-2*hedit0-2*hpop0-2*htxt0;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hedit0+(hedit0-htxt0)/2;

h.text_thm_threshNb = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str0,'horizontalalignment','left');

x = x+wtxt0+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.edit_thm_threshNb = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr0,'callback',...
    {@edit_thm_threshNb_Callback,h_fig});

y = y-p.mg/2-htxt0;

h.text_thm_threshVal = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str2);

y = y-hpop0+(hpop0-hedit0)/2;

h.edit_thm_threshVal = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr2,'callback',...
    {@edit_thm_threshVal_Callback,h_fig});

x = x+wedit0+mgbut;

h.pushbutton_thm_threshStart = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut0,hedit0],'string',str1,'tooltipstring',ttstr1,...
    'callback',{@pushbutton_thm_threshStart_Callback,h_fig});

x = p.mg;
y = y-(hpop0-hedit0)/2;

h.popupmenu_thm_thresh = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hpop0],'string',str3,'tooltipstring',ttstr3,'callback',...
    {@popupmenu_thm_thresh_Callback,h_fig});

y = y-mgres-htxt0;

h.text_thm_relOccThr = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str4);

x = x+wtxt0+p.mg/fact;

h.text_thm_pop = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wedit0,htxt0],'string',str2);

x = x+wedit0+p.mg/fact;

h.text_thm_popSigma = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wedit0,htxt0],'string',str5);

x = p.mg;
y = y-hpop0;

h.popupmenu_thm_pop = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hpop0],'string',str6,'tooltipstring',ttstr4,'callback',...
    {@popupmenu_thm_pop_Callback,h_fig});

x = x+wtxt0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_thm_pop = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'enable','inactive');

x = x+wedit0+p.mg/fact;

h.edit_thm_popSigma = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

y = y-(hpop0-hedit0)/2-p.mg/fact-hedit0;

h.edit_thm_threshclr = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = x-p.mg/fact-wedit0;
y = y+(hedit0-htxt0)/2;

h.text_thm_threshclr = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str7,'horizontalalignment','right');

