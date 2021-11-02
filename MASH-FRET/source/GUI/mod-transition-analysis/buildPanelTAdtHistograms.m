function h = buildPanelTAdtHistograms(h,p)
% h = buildPanelTAdtHistograms(h,p)
%
% Builds panel "Dwell time hisotgrams" in "Transition analysis" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_dtHistograms: handle to panel "Dwell time histograms"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.warr: width of downwards arrow in popupmenu
%   p.tbl: reference table listing character pixel dimensions

% Created by MH, 23.4.2020

% default
htxt0 = 14;
hpop0 = 22;
hcb0 = 20;
hedit0 = 20;
hbut0 = 20;
fact = 5;
str0 = 'state bin';
str1 = 'exclude first & last';
str2 = 'recalc.';
str2b = 'Histogram:';
str3 = 'Fit settings...';
str4 = 'Fit current';
str5 = 'Fit all';
str6 = 'state';
str7 = {'Select a state value'};
ttl0 = 'Results';
ttstr0 = wrapHtmlTooltipString('<b>Bin states</b> according to their value.');
ttstr1 = wrapHtmlTooltipString('<b>Exclude first and last dwell times</b> of each sequence.');
ttstr2 = wrapHtmlTooltipString('<b>Re-build state sequences</b> by ignoring "false" state transitions (<i>i.e.</i>, that belong to diagonal clusters); the dwell time before transition is extended up to the next "true" state transition in the sequence.');
ttstr3 = wrapHtmlTooltipString('Open fit settings');
ttstr4 = wrapHtmlTooltipString('<b>Refresh exponential fit</b> on current histogram.');
ttstr5 = wrapHtmlTooltipString('<b>Refresh exponential fit</b> for all histograms.');
ttstr6 = wrapHtmlTooltipString('Select a <b>state value</b>');

% parent
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_dtHistograms;

% dimensions
pospan = get(h_pan,'position');
wtxt1 = getUItextWidth(str2b,p.fntun,p.fntsz1,'normal',p.tbl);
wcb0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb1 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wbut0 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut1 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wtxt0 = pospan(3)-p.mg-p.mg/2-wcb0-wcb1-p.mg;
wtxt2 = pospan(3)-p.mg-wtxt1-p.mg/fact-wbut0-p.mg/fact-wbut1-p.mg;
wbut2 = wbut0+p.mg/fact+wbut1;
wpan0 = pospan(3)-2*p.mg;
hpan0 = p.mgpan+htxt0+hpop0+p.mg/2+htxt0+hpop0+p.mg;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TA_slBin = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str0);

y = y-hedit0;

h.edit_TA_slBin = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,hedit0],...
    'tooltipstring',ttstr0,'callback',{@edit_TA_slBin_Callback,h_fig});

x = x+wtxt0+p.mg/2;

h.checkbox_TA_slExcl = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hcb0],'string',str1,'tooltipstring',ttstr1,'callback',...
    {@checkbox_TA_slExcl_Callback,h_fig});

x = x+wcb0;

h.checkbox_tdp_rearrSeq = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb1,hcb0],'string',str2,'tooltipstring',ttstr2,'callback',...
    {@checkbox_tdp_rearrSeq_Callback,h_fig});

x = p.mg;
y = y-p.mg/2-htxt0-hpop0+(hpop0-htxt0)/2;

h.text_TA_slHist = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str2b,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hpop0-htxt0)/2+hpop0;

h.text_TA_slState = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt2,htxt0],'string',str6);

y = y-hpop0;

h.popupmenu_TA_slStates = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt2,hpop0],'string',str7,'tooltipstring',ttstr6,'callback',...
    {@popupmenu_TA_slStates_Callback,h_fig});

x = x+wtxt2+p.mg/fact;
y = y+(hpop0-hbut0)/2;

h.pushbutton_TDPfit_fit = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hbut0],'string',str4,'tooltipstring',ttstr4,'callback',...
    {@pushbutton_TDPfit_fit_Callback,h_fig});

x = x+wbut0+p.mg/fact;

h.pushbutton_TA_slFitAll = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,hbut0],'string',str5,'tooltipstring',ttstr5,'callback',...
    {@pushbutton_TDPfit_fit_Callback,h_fig});

x = x-p.mg/fact-wbut0;
y = y-(hpop0-hbut0)/2-p.mg/2-hbut0;

h.pushbutton_TA_fitSettings = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut2,hbut0],'string',str3,'tooltipstring',ttstr3,...
    'callback',{@pushbutton_TA_fitSettings_Callback,h_fig});

x = p.mg;
y = y-p.mg-hpan0;

h.uipanel_TA_fitResults = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan0,hpan0],...
    'title',ttl0);
h = buildPanelTAfitResults(h,p);

