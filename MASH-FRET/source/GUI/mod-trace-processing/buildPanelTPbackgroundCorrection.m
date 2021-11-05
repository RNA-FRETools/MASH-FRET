function h = buildPanelTPbackgroundCorrection(h,p)
% h = buildPanelTPbackgroundCorrection(h,p);
%
% Builds "Background correction" panel in "Trace processing" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP_backgroundCorrection: handle to panel "Background correction"
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
file_icon0 = 'view.png';
str0 = 'data';
str1 = 'method';
str2 = 'param';
str3 = 'dim';
str4 = {'Select a time trace'};
str5 = {'Select a method'};
str6 = 'x-dark';
str7 = 'y-dark';
str8 = 'auto.';
str10 = 'Opt.';
str11 = 'Background:';
str12 = 'Apply';
str13 = 'all';
ttstr0 = wrapHtmlTooltipString('Select an <b>intensity-time trace</b> to configure the background correction for.');
ttstr1 = wrapHtmlTooltipString('Select a background <b>estimation method</b> for the selected time-trace.');
ttstr2 = wrapHtmlTooltipString('<b>Background position:</b> x-coordinate of the background in the corresponding sub-image.');
ttstr3 = wrapHtmlTooltipString('<b>Background position:</b> y-coordinate of the background in the corresponding sub-image.');
ttstr4 = wrapHtmlTooltipString('<b>Background position:</b> determine automatically the background coordinates in the corresponding sub-image.');
ttstr5 = wrapHtmlTooltipString('Show the <b>background intensity-time trace</b>.');
ttstr6 = wrapHtmlTooltipString('Open the <b>Background analyzer</b>: this tool allows to screen method parameters (useful to test background correction algorithms).');
ttstr7 = wrapHtmlTooltipString('Calculated <b>(mean) background intensity</b> for the selected intensity-time trace.');
ttstr8 = wrapHtmlTooltipString('<b>Subtract background</b> intensity or trace to the selected intensity-time trace.');
ttstr9 = wrapHtmlTooltipString('Apply current background correction settings to all molecules.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_backgroundCorrection;

% images
pname = [fileparts(mfilename('fullpath')),filesep,'..',filesep];
img0 = imread([pname,file_icon0]);

% dimensions
pospan = get(h_pan,'position');
wpop0 = (pospan(3)-2*p.mg-3*p.mg/fact-2*wedit0)/2;
wcb0 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wbut1 = getUItextWidth(str10,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wtxt0 = getUItextWidth(str11,p.fntun,p.fntsz1,'normal',p.tbl);
wcb1 = getUItextWidth(str12,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wbut2 = getUItextWidth(str13,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wedit1 = (pospan(3)-p.mg-2*p.mg/fact-wcb0-p.mg/fact-p.wbut1-p.mg/fact-...
    wbut1-p.mg)/2;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_trBgCorr_data = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str0);

x = x+wpop0+p.mg/fact;

h.text_TP_bg_method = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str1);

x = x+wpop0+p.mg/fact;

h.text_TP_bg_param = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str2);

x = x+wedit0+p.mg/fact;

h.text_subImg_dim = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str3);

x = p.mg;
y = y-hpop0;

h.popupmenu_trBgCorr_data = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str4,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_trBgCorr_data_Callback,h_fig});

x = x+wpop0+p.mg/fact;

h.popupmenu_trBgCorr = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str5,'tooltipstring',ttstr1,'callback',...
    {@popupmenu_trBgCorr_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_trBgCorrParam_01 = uicontrol('style','edit','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_trBgCorrParam_01_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_subImg_dim = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_subImg_dim_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-htxt0;

h.text_xDark = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,htxt0],...
    'string',str6);

y = y-hedit0;

h.edit_xDark = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit0],...
    'callback',{@edit_xDark_Callback,h_fig},'tooltipstring',ttstr2);

x = x+wedit1+p.mg/fact;
y = y+hedit0;

h.text_yDark = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,htxt0],...
    'string',str7);

y = y-hedit0;

h.edit_yDark = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit0],...
    'callback',{@edit_yDark_Callback,h_fig},'tooltipstring',ttstr3);

x = x+wedit1+p.mg/fact;

h.checkbox_autoDark = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str8,'tooltipstring',ttstr4,'callback',...
    {@checkbox_autoDark_Callback,h_fig});

x = x+wcb0+p.mg/fact;

h.pushbutton_showDark = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,p.wbut1,hedit0],'tooltipstring',ttstr5,'cdata',img0,'callback',...
    {@pushbutton_showDark_Callback,h_fig});

x = x+p.wbut1+p.mg/fact;

h.pushbutton_optBg = uicontrol('style','pushbutton','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,hedit0],'string',str10,'tooltipstring',ttstr6,'callback',...
    {@pushbutton_optBg_Callback,h_fig});

x = p.mg;
y = p.mg/2+(hedit0-htxt0)/2;

h.text_trBgCorr_bgInt = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str11);

x = x+wtxt0+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.edit_trBgCorr_bgInt = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_trBgCorr_bgInt_Callback,h_fig},...
    'tooltipstring',ttstr7);

x = x+wedit0+p.mg/fact;

h.checkbox_trBgCorr = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb1,hedit0],'string',str12,'tooltipstring',ttstr8,'callback',...
    {@checkbox_trBgCorr_Callback,h_fig});

x = pospan(3)-p.mg-wbut2;

h.pushbutton_applyAll_ttBg = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut2,hedit0],'string',str13,'callback',...
    {@pushbutton_applyAll_ttBg_Callback,h_fig},'tooltipstring',ttstr9,...
    'foregroundcolor',p.fntclr2);


