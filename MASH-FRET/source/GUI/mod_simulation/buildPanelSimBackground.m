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
%   p.wttstr: pixel width of tooltip box
%   p.tbl: reference table listing character's pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% created by MH, 19.10.2019

% default
hedit = 20;
htxt = 14;
hpop = 22;
fact = 5;
str0 = {'Uniform','2D Gaussian profile','Pattern'};
str1 = 'bgD:';
str2 = 'bgA:';
str3 = 'w0,ex:';
str4 = 'x:';
str5 = 'y:';
str6 = 'decay';
str7 = 'dec.';
str8 = 'amp.';
ttstr0 = wrapStrToWidth('Select a type of <b>spatial distribution</b> for the fluorescent background in single molecule images.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Fluorescent background intensity</b> in donor channel (counts/time bin).',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Fluorescent background intensity</b> in acceptor channel (counts/time bin).',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('<b>Standard deviation (in pixels)</b> in the x-direction used in the 2D-Gaussian profile.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Standard deviation (in pixels)</b> in the y-direction used in the 2D-Gaussian profile.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('<b>Simulate photobleaching of fluorescent background:</b> the fluorescent background decay exponentially in both video channels.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr6 = wrapStrToWidth('Background <b>decay time constant (in seconds)</b>',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr7 = wrapStrToWidth('<b>Enhancement/reduction factor</b> of background intensity prior decay.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S_background;

% dimensions
pospan = get(h_pan,'position');
wpop = pospan(3)-p.mg;
wtxt0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl);
wedit0 = (pospan(3)-p.mg-p.mg/fact-2*wtxt0)/2;
wtxt1 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt2 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl);
wedit1 = (pospan(3)-p.mg-p.mg/fact-wtxt1-2*wtxt2)/2;
wcb0 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wedit2 = (pospan(3)-p.mg-p.mg/fact-wcb0)/2;

% GUI
x = p.mg/2;
y = pospan(4)-2*p.mg-hedit;

h.popupmenu_simBg_type = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop,hpop],'string',str0,'callback',...
    {@popupmenu_simBg_type_Callback,h_fig},'tooltipstring',ttstr0);

y = y-p.mg/fact-hedit+(hedit-htxt)/2;

h.text_simBgD = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt],...
    'string',str1,'horizontalalignment','right');

x = x+wtxt0;
y = y-(hedit-htxt)/2;

h.edit_bgInt_don = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit],...
    'callback',{@edit_bgInt_don_Callback,h_fig},'tooltipstring',ttstr1);

x = x+wedit0+p.mg/fact;
y = y+(hedit-htxt)/2;

h.text_simBgA = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt],...
    'string',str2,'horizontalalignment','right');

x = x+wtxt0;
y = y-(hedit-htxt)/2;

h.edit_bgInt_acc = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit],...
    'callback',{@edit_bgInt_acc_Callback,h_fig},'tooltipstring',ttstr2);

x = p.mg/2;
y = y-p.mg/fact-hedit+(hedit-htxt)/2;

h.text_simWTIRF = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt],...
    'string',str3);

x = x+wtxt1;

h.text_simWTIRF_x = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt2,htxt],...
    'string',str4,'horizontalalignment','right');

x = x+wtxt2;
y = y-(hedit-htxt)/2;

h.edit_TIRFx = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit],...
    'callback',{@edit_TIRFx_Callback,h_fig},'tooltipstring',ttstr3);

x = x+wedit1+p.mg/fact;
y = y+(hedit-htxt)/2;

h.text_simWTIRF_y = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt2,htxt],...
    'string',str5,'horizontalalignment','right');

x = x+wtxt2;
y = y-(hedit-htxt)/2;

h.edit_TIRFy = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit],...
    'callback',{@edit_TIRFy_Callback,h_fig},'tooltipstring',ttstr4);

x = p.mg/2;
y = p.mg/2;

h.checkbox_bgExp = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit],'string',str6,'callback',...
    {@checkbox_bgExp_Callback,h_fig},'tooltipstring',ttstr5);

x = x+wcb0;

h.edit_bgExp_cst = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit2,hedit],...
    'callback',{@edit_bgExp_cst_Callback,h_fig},'tooltipstring',ttstr6);

y = y+hedit;

h.text_dec = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit2,htxt],...
    'string',str7);

x = x+wedit2+p.mg/fact;
y = y-hedit;

h.edit_simAmpBG = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit2,hedit],...
    'callback',{@edit_simAmpBG_Callback,h_fig},'tooltipstring',ttstr7);

y = y+hedit;

h.text_amp = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit2,htxt],...
    'string',str8);

