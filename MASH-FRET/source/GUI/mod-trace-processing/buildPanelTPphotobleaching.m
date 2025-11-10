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
str1 = 'cutoff';
str2 = {'Manual','Threshold'};
str4 = 'Stats';
str5 = 'data';
str6 = 'Select the data to process';
str7 = 'all';
ttstr0 = wrapHtmlTooltipString('Select a photobleaching <b>detection method</b>: <b>Manual</b> when the photobleaching cutoff is defined by the user (blinking detection is not available), <b>Threshold</b> when the photobleaching cutoff and blink-off events are automatically detected on discretized trajectories using a relative intensity threshold.');
ttstr1 = wrapHtmlTooltipString('<b>Global cutoff time point:</b> time point at which the first photobleaching event was detected; the cutoff is shown by a solid vertical bar in trajectory. The "Clip" option in panel Plot uses this time point to rescale the time axis.');
ttstr3 = wrapHtmlTooltipString('<b>Bleaching and blinking statistics</b>: opens a tool to visualize and fit survival or blinking time distributions.');
ttstr4 = wrapHtmlTooltipString('<b>Select an emitter</b> to configure <b>Threshold</b> photobleaching/blinking detection for.');
ttstr5 = wrapHtmlTooltipString('Apply current photobleaching/blinking settings to all molecules.');
ttstr6 = wrapHtmlTooltipString('<b>Emitter''s cutoff time point</b>: time point at which photobleaching was detected for this particular emitter; the cutoff is shown by a dotted vertical bar in trajectory plots.');
ttstr7 = wrapHtmlTooltipString('<b>Data threshold</b>: data value (relative to max. signal value) below which the discretized trajectory is considered to be in the <b>"off" state</b>. The "off" state is represented with a gray-background in the trajectory plots. <b>Photobleaching</b> cutoff is determined when the discretized data dwells 100%% of the remaining time in the "off" state.');
ttstr8 = wrapHtmlTooltipString('<b>Minimum bleaching time</b>: minimum duration for the last "off" dwell time to be considered as photobleaching instead of blinking.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_photobleaching;

% dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut1 = getUItextWidth(str7,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpop2 = pospan(3)-2*p.mg-4*p.mg/fact-3*wedit0-wbut1;
wpop0 = getUItextWidth(str2{2},p.fntun,p.fntsz1,'normal',p.tbl)+p.warr;
wedit1 = pospan(3)-2*p.mg-2*p.mg/fact-wpop0-wbut0;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TP_pbMethod = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str0);

x = x+wpop0+p.mg/fact;

h.text_photobl_stop = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,htxt0],'string',str1);

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
    [x,y,wedit1,hedit0],'callback',{@edit_photobl_stop_Callback,h_fig},...
    'tooltipstring',ttstr1);

x = x+wedit1+p.mg/fact;

h.pushbutton_TP_pbStats = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str4,'tooltipstring',ttstr3,'callback',...
    {@pushbutton_TP_pbStats_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-htxt0;

h.text_bleachChan = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop2,htxt0],'string',str5);

y = y-hpop0;

h.popupmenu_bleachChan = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop2,hpop0],'string',str6,'tooltipstring',ttstr4,'callback',...
    {@popupmenu_bleachChan_Callback,h_fig});

x = x+wpop2+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_photoblParam_01 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr7,'callback',...
    {@edit_photoblParam_01_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_photoblParam_02 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr8,'callback',...
    {@edit_photoblParam_02_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_photoblParam_03 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_photoblParam_03_Callback,h_fig},...
    'tooltipstring',ttstr6);

x = pospan(3)-p.mg-wbut1;

h.pushbutton_applyAll_debl = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut1,hedit0],'string',str7,'callback',...
    {@pushbutton_applyAll_debl_Callback,h_fig},'tooltipstring',ttstr5,...
    'foregroundcolor',p.fntclr2);

