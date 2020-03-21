function h = buildPanelTPphotobleaching(h,p)
% h = buildPanelTPphotobleaching(h,p);
%
% Builds panel "Photobleaching" in "Trace processing" module
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP_photobleaching: handle to the panel "Photobleaching"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.fntclr2: text color in special pushbuttons
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 13;
hpop0 = 22;
wedit0 = 40;
fact = 5;
str0 = 'method';
str1 = 'stop';
str2 = {'Manual','Threshold'};
str3 = 'Clip';
str4 = 'data';
str5 = 'Select the data to process';
str6 = 'all';
ttstr0 = wrapHtmlTooltipString('Select a photobleaching <b>detection method</b>.');
ttstr1 = wrapHtmlTooltipString('<b>Cutoff time/frame:</b> position on the x-axis where photobleaching was detected; the cutoff is shown by a cyan vertical bar in top and bottom plots.');
ttstr2 = wrapHtmlTooltipString('<b>Clip traces</b> to cutoff time/frame: when activated, data points beyond the cutoff position are ignored.');
ttstr3 = wrapHtmlTooltipString('<b>Select data</b> to analyze for photobleaching detection.');
ttstr4 = wrapHtmlTooltipString('Apply current photobleaching settings to all molecules.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_photobleaching;

% dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wbut0 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpop1 = pospan(3)-2*p.mg-4*p.mg/fact-3*wedit0-wbut0;
wpop0 = wpop1+p.mg/fact+wedit0;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TP_pbMethod = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str0);

x = x+wpop0+p.mg/fact;

h.text_photobl_stop = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str1);

x = p.mg;
y = y-hpop0;

h.popupmenu_debleachtype = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str2,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_debleachtype_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_photobl_stop = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_photobl_stop_Callback,h_fig},...
    'tooltipstring',ttstr1);

x = x+wedit0+p.mg/fact;

h.checkbox_cutOff = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str3,'tooltipstring',ttstr2,'callback',...
    {@checkbox_cutOff_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-htxt0;

h.text_bleachChan = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,htxt0],'string',str4);

y = y-hpop0;

h.popupmenu_bleachChan = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,hpop0],'string',str5,'tooltipstring',ttstr3,'callback',...
    {@popupmenu_bleachChan_Callback,h_fig});

x = x+wpop1+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_photoblParam_01 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_photoblParam_01_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_photoblParam_02 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_photoblParam_02_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_photoblParam_03 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_photoblParam_03_Callback,h_fig});

x = pospan(3)-p.mg-wbut0;

h.pushbutton_applyAll_debl = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str6,'callback',...
    {@pushbutton_applyAll_debl_Callback,h_fig},'tooltipstring',ttstr4,...
    'foregroundcolor',p.fntclr2);

