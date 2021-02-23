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
wedit0 = 40;
fact = 5;
lim0 = [0,10000];
xlbl0 = 'dwell-times (s)';
ylbl0 = 'normalized (1 - cum(P))';
axttl0 = 'Kinetic analysis from dwell-times';
str0 = 'State binning:';
str1 = 'exclude first & last';
str2 = 'recalculate';
str3 = 'Fit settings...';
str4 = 'Fit current';
str5 = 'Fit all';
str6 = 'state';
str7 = 'degen.';
str8 = {'Select a state value'};
str9 = {'Select a degenerated level'};
str10 = 'sigma';
str11 = [char(964),' (s)'];
str12 = 'transition';
str13 = {'Select a tansition'};
str14 = 'contrib.';
str15 = 'y-log scale';
ttstr0 = wrapHtmlTooltipString('<b>Bin states</b> according to their value.');
ttstr1 = wrapHtmlTooltipString('<b>Exclude first and last dwell times</b> of each sequence.');
ttstr2 = wrapHtmlTooltipString('<b>Re-build state sequences</b> by ignoring "false" state transitions (<i>i.e.</i>, that belong to diagonal clusters); the dwell time before transition is extended up to the next "true" state transition in the sequence.');
ttstr3 = wrapHtmlTooltipString('Open fit settings');
ttstr4 = wrapHtmlTooltipString('<b>Refresh exponential fit</b> on current histogram.');
ttstr5 = wrapHtmlTooltipString('<b>Refresh exponential fit</b> for all histograms.');
ttstr6 = wrapHtmlTooltipString('Select a <b>state value</b>');
ttstr7 = wrapHtmlTooltipString('Select a <b>degenerated level</b>');
ttstr8 = wrapHtmlTooltipString('Bootstap mean of <b>state lifetime</b> (in seconds)');
ttstr9 = wrapHtmlTooltipString('Bootstap mean of <b>relative contribution</b> of degenerated level to dwell time histogram');
ttstr10 = wrapHtmlTooltipString('Bootstap deiation of <b>state lifetime</b> (in seconds)');
ttstr11 = wrapHtmlTooltipString('Bootstap deviation of <b>relative contribution</b> of degenerated level to dwell time histogram');
ttstr12 = wrapHtmlTooltipString('Show histogram''s y-axis in a <b>logarithmic scale</b>.');
ttstr13 = wrapHtmlTooltipString('Select a <b>state transition</b>');

% parent
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_dtHistograms;

% dimensions
pospan = get(h_pan,'position');
wtxt2 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt0 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = getUItextWidth(str7,p.fntun,p.fntsz1,'normal',p.tbl);
wbut3 = getUItextWidth(str15,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wcol = wtxt0+wtxt1+2*wedit0+3*p.mg/fact;
wcb0 = wcol;
wbut0 = wcol;
wbut1 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut2 = wcol-wbut1-p.mg/fact;
wedit1 = wcol-wtxt2;
wtxt3 = wtxt0+p.mg/fact+wtxt1;

waxes0 = pospan(3)-wcol-3*p.mg;
haxes0 = pospan(4)-p.mgpan-p.mg;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hedit0+(hedit0-htxt0)/2;

h.text_TA_slBin = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt2,htxt0],...
    'string',str0,'horizontalalignment','left');

x = x+wtxt2;
y = y-(hedit0-htxt0)/2;

h.edit_TA_slBin = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit0],...
    'tooltipstring',ttstr0,'callback',{@edit_TA_slBin_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-hcb0;

h.checkbox_TA_slExcl = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hcb0],'string',str1,'tooltipstring',ttstr1,'callback',...
    {@checkbox_TA_slExcl_Callback,h_fig});

y = y-p.mg/fact-hcb0;

h.checkbox_tdp_rearrSeq = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hcb0],'string',str2,'tooltipstring',ttstr2,'callback',...
    {@checkbox_tdp_rearrSeq_Callback,h_fig});

x = p.mg;
y = y-p.mg-hcb0;

h.pushbutton_TA_fitSettings = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut0,hbut0],'string',str3,'tooltipstring',ttstr3,...
    'callback',{@pushbutton_TA_fitSettings_Callback,h_fig});

x = p.mg;
y = y-p.mg-hbut0;

h.pushbutton_TDPfit_fit = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,hbut0],'string',str4,'tooltipstring',ttstr4,'callback',...
    {@pushbutton_TDPfit_fit_Callback,h_fig});

x = x+wbut1+p.mg/fact;

h.pushbutton_TA_slFitAll = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut2,hbut0],'string',str5,'tooltipstring',ttstr5,'callback',...
    {@pushbutton_TDPfit_fit_Callback,h_fig});

x = p.mg;
y = y-p.mg-htxt0;

h.text_TA_slState = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str6);

x = x+wtxt0+p.mg/fact;

h.text_TA_slDegen = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt1,htxt0],'string',str7);

x = x+wtxt1+p.mg/fact;

h.text_TA_slTau = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str11);

x = x+wedit0+p.mg/fact;

h.text_TA_slTauSig = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str10);

x = p.mg;
y = y-hpop0;

h.popupmenu_TA_slStates = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hpop0],'string',str8,'tooltipstring',ttstr6,'callback',...
    {@popupmenu_TA_slStates_Callback,h_fig});

x = x+wtxt0+p.mg/fact;

h.popupmenu_TA_slDegen = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt1,hpop0],'string',str9,'tooltipstring',ttstr7,'callback',...
    {@popupmenu_TA_slDegen_Callback,h_fig});

x = x+wtxt1+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_TA_slTauMean = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr8,'callback',...
    {@edit_TA_slTauMean_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TA_slTauSig = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr10,'callback',...
    {@edit_TA_slTauSig_Callback,h_fig});

x = p.mg;
y = y-p.mg/2-(hpop0-hedit0)/2-htxt0;

h.text_TA_slTrans = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt3,htxt0],'string',str12);

x = x+wtxt3+p.mg/fact;

h.text_TA_slPop = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str14);

x = x+wedit0+p.mg/fact;

h.text_TA_slPopSig = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str10);

x = p.mg;
y = y-hpop0;

h.popupmenu_TA_slTrans = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt3,hpop0],'string',str13,'tooltipstring',ttstr13,'callback',...
    {@popupmenu_TA_slTrans_Callback,h_fig});

x = x+wtxt3+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_TA_slPopMean = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr9,'callback',...
    {@edit_TA_slPopMean_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TA_slPopSig = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr11,'callback',...
    {@edit_TA_slPopSig_Callback,h_fig});

x = pospan(3)-p.mg-waxes0;
y = p.mg;

h.axes_TDPplot2 = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'xlim',lim0,'ylim',...
    lim0, 'nextplot', 'replacechildren');
h_axes = h.axes_TDPplot2;
xlabel(h_axes,xlbl0);
ylabel(h_axes,ylbl0);
title(h_axes,axttl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

x = posaxes(1)+posaxes(3)-p.mg-wbut3;
y = posaxes(2)+posaxes(4)-p.mg-hbut0;

h.pushbutton_TDPfit_log = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut3,hbut0],'string',str15,'tooltipstring',ttstr12,'callback',...
    {@pushbutton_TDPfit_log_Callback,h_fig});
