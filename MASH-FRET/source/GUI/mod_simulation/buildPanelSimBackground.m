function h = buildPanelSimBackground(h,p)
% h = buildPanelSimBackground(h,p);
%
% Builds "Background" panel of module "Simulation"
% 
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_S_background: handle to the panel "Background"
% p: structure containing default and often-used parameters (dimensions, margin etc.) with fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbox: box's pixel width in checkboxes
%   p.tbl: reference table listing character's pixel dimensions
%   p.fntclr1: text color in file/folder fields
%   p.wbrd: cumulated pixel width of pushbutton's border

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hbut = 22;
hedit = 20;
htxt = 14;
hpop = 22;
fact = 5;
str0 = {'Uniform','2D Gaussian profile','Pattern'};
str1 = 'background image';
str2 = '...';
str3 = 'bgD:';
str4 = 'bgA:';
str5 = 'w0,ex:';
str6 = 'x:';
str7 = 'y:';
str8 = 'decay';
str9 = 'dec.';
str10 = 'amp.';
ttstr0 = wrapHtmlTooltipString('Select a type of <b>spatial distribution</b> for the fluorescent background in single molecule images.');
ttstr1 = wrapHtmlTooltipString('<b>Fluorescent background intensity</b> in donor channel (counts/time bin).');
ttstr2 = wrapHtmlTooltipString('<b>Fluorescent background intensity</b> in acceptor channel (counts/time bin).');
ttstr3 = wrapHtmlTooltipString('<b>Standard deviation (in pixels)</b> in the x-direction used in the 2D-Gaussian profile.');
ttstr4 = wrapHtmlTooltipString('<b>Standard deviation (in pixels)</b> in the y-direction used in the 2D-Gaussian profile.');
ttstr5 = wrapHtmlTooltipString('<b>Simulate photobleaching of fluorescent background:</b> the fluorescent background decay exponentially in both video channels.');
ttstr6 = wrapHtmlTooltipString('Background <b>decay time constant (in seconds)</b>');
ttstr7 = wrapHtmlTooltipString('<b>Enhancement/reduction factor</b> of background intensity prior decay.');
ttstr8 = wrapHtmlTooltipString('<b>Open browser</b> and select a background image.');
ttstr9 = wrapHtmlTooltipString('<b>Backgroud image file</b>');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S_background;

% dimensions
pospan = get(h_pan,'position');
wpop = pospan(3)-p.mg;
wbut0 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wedit0 = pospan(3)-p.mg/2-wbut0-p.mg/fact-p.mg/2;
wtxt0 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl);
wedit1 = (pospan(3)-p.mg-p.mg/fact-2*wtxt0)/2;
wtxt1 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt2 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl);
wedit2 = (pospan(3)-p.mg-p.mg/fact-wtxt1-2*wtxt2)/2;
wcb0 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wedit3 = (pospan(3)-p.mg-p.mg/fact-wcb0)/2;

% GUI
x = p.mg/2;
y = pospan(4)-2*p.mg-hedit;

h.popupmenu_simBg_type = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop,hpop],'string',str0,'callback',...
    {@popupmenu_simBg_type_Callback,h_fig},'tooltipstring',ttstr0);

y = y-p.mg/fact-hedit+(hedit-htxt)/2;
x = x+wbut0+p.mg/fact;

h.text_S_bgImgFile = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt],'string',str1);

x = p.mg;
y = y-hbut;

h.pushbutton_S_impBgImg = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit],'callback',{@pushbutton_S_impBgImg_Callback,h_fig},...
    'string',str2,'tooltipstring',ttstr8);

x = x+wbut0+p.mg/fact;
y = y+(hbut-hedit)/2;

h.edit_S_bgImgFile = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit],'callback',{@edit_S_bgImgFile_Callback,h_fig},...
    'tooltipstring',ttstr9,'foregroundcolor',p.fntclr1);

x = p.mg/2;
y = y-(hbut-hedit)/2+hbut;

h.text_simBgD = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt],...
    'string',str3,'horizontalalignment','right');

x = x+wtxt0;
y = y-(hedit-htxt)/2;

h.edit_bgInt_don = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit],...
    'callback',{@edit_bgInt_don_Callback,h_fig},'tooltipstring',ttstr1);

x = x+wedit1+p.mg/fact;
y = y+(hedit-htxt)/2;

h.text_simBgA = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt],...
    'string',str4,'horizontalalignment','right');

x = x+wtxt0;
y = y-(hedit-htxt)/2;

h.edit_bgInt_acc = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit],...
    'callback',{@edit_bgInt_acc_Callback,h_fig},'tooltipstring',ttstr2);

x = p.mg/2;
y = y-p.mg/fact-hedit+(hedit-htxt)/2;

h.text_simWTIRF = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt],...
    'string',str5);

x = x+wtxt1;

h.text_simWTIRF_x = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt2,htxt],...
    'string',str6,'horizontalalignment','right');

x = x+wtxt2;
y = y-(hedit-htxt)/2;

h.edit_TIRFx = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit2,hedit],...
    'callback',{@edit_TIRFx_Callback,h_fig},'tooltipstring',ttstr3);

x = x+wedit2+p.mg/fact;
y = y+(hedit-htxt)/2;

h.text_simWTIRF_y = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt2,htxt],...
    'string',str7,'horizontalalignment','right');

x = x+wtxt2;
y = y-(hedit-htxt)/2;

h.edit_TIRFy = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit2,hedit],...
    'callback',{@edit_TIRFy_Callback,h_fig},'tooltipstring',ttstr4);

x = p.mg/2;
y = p.mg/2;

h.checkbox_bgExp = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit],'string',str8,'callback',...
    {@checkbox_bgExp_Callback,h_fig},'tooltipstring',ttstr5);

x = x+wcb0;

h.edit_bgExp_cst = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit3,hedit],...
    'callback',{@edit_bgExp_cst_Callback,h_fig},'tooltipstring',ttstr6);

y = y+hedit;

h.text_dec = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit3,htxt],...
    'string',str9);

x = x+wedit3+p.mg/fact;
y = y-hedit;

h.edit_simAmpBG = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit3,hedit],...
    'callback',{@edit_simAmpBG_Callback,h_fig},'tooltipstring',ttstr7);

y = y+hedit;

h.text_amp = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit3,htxt],...
    'string',str10);

