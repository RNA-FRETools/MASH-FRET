function h = buildPanelVPspotfinder(h,p)
% h = buildPanelVPspotfinder(h,p);
%
% Builds "Spotfinder" panel in module "Video processing"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_VP_spotfinder: handle to the panel "Spotfinder"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
fact = 5;
str0 = {'Method','"In-series" screening','Houghpeaks','Schmied2012',...
    'Twotone'};
str1 = 'Gauss. fit';
str2 = 'Channel n°:';
str3 = 'Select channel';
str4 = 'apply to all frames';
str5 = 'Find';
str6 = 'Exclusion rules:';
str7 = 'Results';
str8 = 'spots';
str9 = 'Save...';
ttstr0 = wrapHtmlTooltipString('Select a <b>spot finding algorithm</b> to configure and use on the current image/video.');
ttstr1 = wrapHtmlTooltipString('<b>Fit spot profiles</b> with 2D Gaussian functions: Gaussian widths and amplitude are then used to sort and select spots (see Exclusion rules).');
ttstr2 = wrapHtmlTooltipString('<b>Select a video channel</b> to configure the algorithm for (chanels are numbered from left to right).');
ttstr3 = wrapHtmlTooltipString('<b>Width of fitting area</b> used for Gaussian fitting.');
ttstr4 = wrapHtmlTooltipString('<b>Height of fitting area</b> used for Gaussian fitting.');
ttstr5 = wrapHtmlTooltipString('<b>Find spots in all video frames:</b> when activated, each video frame is processed individually using the same settings.');
ttstr6 = wrapHtmlTooltipString('Start spot finding algorithm.');
ttstr7 = wrapHtmlTooltipString('<b>Maximum number</b> of spots to find.');
ttstr8 = wrapHtmlTooltipString('<b>Minimum distance</b> allowed between spots.');
ttstr9 = wrapHtmlTooltipString('<b>Minimum distance</b> allowed between spots and image edges.');
ttstr10 = wrapHtmlTooltipString('<b>Minimum spot width</b> allowed (in pixels): spots widths are the Gaussian standard deviations obtained after fitting.');
ttstr11 = wrapHtmlTooltipString('<b>Maximum spot width</b> allowed (in pixels): spots widths are the Gaussian standard deviations obtained after fitting.');
ttstr12 = wrapHtmlTooltipString('<b>Maximum spot assymetry</b> allowed (in percent): spot assymetry is calculated as the ratio of the spot''s widths in th x- and y- directions obtained after fitting (spot assymetry is always higher than 100%).');
ttstr13 = wrapHtmlTooltipString('<b>Number of spots found</b> after applying exclusion rules.');
ttstr14 = wrapHtmlTooltipString('<b>Export</b> spot coordinates to file.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_VP_spotfinder;

% dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wpop0 = pospan(3)-2*p.mg-p.mg/fact-wcb0;
wtxt0 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl);
wedit0 = (pospan(3)-2*p.mg-p.mg/2-2*p.mg/fact)/4;
wbut0 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wcb1 = pospan(3)-p.mg*2-p.mg-wbut0;
wtxt1 = pospan(3)-2*p.mg;
wtxt2 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl);
wbut1 = getUItextWidth(str9,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
mgsf = pospan(4)-p.mgpan-p.mg/2-6*p.mg/fact-2*hpop0-5*hedit0-htxt0;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hpop0;

h.popupmenu_SF = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_SF_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.checkbox_SFgaussFit = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hpop0],'string',str1,'tooltipstring',ttstr1,'callback',...
    {@checkbox_SFgaussFit_Callback,h_fig});

x = p.mg;
y = y-(hpop0-hedit0)/2-p.mg/fact-hpop0+(hpop0-htxt0)/2;

h.text_channel = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str2,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hpop0-htxt0)/2;

h.popupmenu_SFchannel = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hpop0],'string',str3,'tooltipstring',ttstr2,'callback',...
    {@popupmenu_SFchannel_Callback,h_fig});

x = pospan(3)-p.mg-wedit0;
y = y+(hpop0-hedit0)/2;

h.edit_SFintThresh = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_SFintThresh_Callback,h_fig});

x = p.mg;
y = y-(hpop0-hedit0)/2-p.mg/fact-hedit0;

h.edit_SFparam_w = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr3,'callback',{@edit_SFparam_w_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_SFparam_h = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr4,'callback',{@edit_SFparam_h_Callback,h_fig});

x = x+wedit0+p.mg/2;

h.edit_SFparam_darkW = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_SFparam_darkW_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_SFparam_darkH = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_SFparam_darkH_Callback,h_fig});

x = pospan(3)-p.mg-wbut0;
y = y-p.mg/fact-hedit0;

h.pushbutton_SFgo = uicontrol('style','pushbutton','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str5,'tooltipstring',ttstr6,'callback',...
    {@pushbutton_SFgo_Callback,h_fig});

x = p.mg;
y = y-mgsf-htxt0;

h.text_SFexcl = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str6,'horizontalalignment','left');

y = y-p.mg/fact-hedit0;

h.edit_SFparam_maxN = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr7,'callback',...
    {@edit_SFparam_maxN_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_SFparam_minI = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_SFparam_minI_Callback,h_fig});

x = x+wedit0+p.mg/2;

h.edit_SFparam_minDspot = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr8,'callback',...
    {@edit_SFparam_minDspot_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_SFparam_minDedge = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr9,'callback',...
    {@edit_SFparam_minDedge_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-hedit0;

h.edit_SFparam_minHWHM = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr10,'callback',...
    {@edit_SFparam_minHWHM_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_SFparam_maxHWHM = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr11,'callback',...
    {@edit_SFparam_maxHWHM_Callback,h_fig});

x = x+wedit0+p.mg/2;

h.edit_SFparam_maxAssy = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr12,'callback',...
    {@edit_SFparam_maxAssy_Callback,h_fig});

x = p.mg;
y = p.mg/2+(hedit0-htxt0)/2;

h.text_resSF = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str7,'horizontalalignment','left');

x = x+wedit0+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.edit_SFres = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr13,'enable','inactive');

x = x+wedit0+p.mg/fact;
y = y+(hedit0-htxt0)/2;

h.text_spots = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt2,htxt0],...
    'string',str8,'horizontalalignment','right');

x = pospan(3)-p.mg-wbut1;
y = y-(hedit0-htxt0)/2;

h.pushbutton_SFsave = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,hedit0],'string',str9,'tooltipstring',ttstr14,'callback',...
    {@pushbutton_SFsave_Callback,h_fig});
