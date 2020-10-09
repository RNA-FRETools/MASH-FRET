function h = buildPanelSimExperimentalSetup(h,p)
% h = buildPanelSimExperimentalSetup(h,p);
%
% Builds "Experimental setup" panel in module "Simulation" including "Background" panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_S_experimentalSetup: handle to the panel "Experimental setup"
% p: structure containing default and often-used parameters
%   (dimensions, margin etc.) with fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbox: box's pixel width in checkboxes
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 14;
fact = 5;
str0 = 'PSF';
str1 = 'wdet,D';
str2 = 'wdet,A';
str3 = 'defocus';
str4 = 'm';
str5 = 'z_0,A';
ttl0 = 'Background';
ttstr0 = wrapHtmlTooltipString('Convolute single moelcule images with a <b>point spread function (PSF)</b> (2D Gaussian).');
ttstr1 = wrapHtmlTooltipString('PSF <b>standard deviation (in um)</b> in donor channel.');
ttstr2 = wrapHtmlTooltipString('PSF <b>standard deviation (in um)</b> in acceptor channel.');
ttstr3 = wrapHtmlTooltipString('<b>Simulate objective defocusing:</b> single molecule signal decreases exponentially.');
ttstr4 = wrapHtmlTooltipString('Defocusing decay <b>time constant (in seconds)</b>.');
ttstr5 = wrapHtmlTooltipString('<b>Initial defocusing factor</b> in acceptor channel (between 0 and 1).');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S_experimentalSetup;

% dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox; % add boxe dimensions
wedit0 = (pospan(3)-p.mg-2*p.mg/fact-wcb0)/2;
wpan = pospan(3)-p.mg;
hpan = pospan(4)-3*p.mg/2-2*p.mg-2*htxt0-2*hedit0;

x = p.mg/2;
y = pospan(4)-2*p.mg-htxt0-hedit0;

h.checkbox_convPSF = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str0,'callback',...
    {@checkbox_convPSF_Callback,h_fig},'tooltipstring',ttstr0);

y = y+hedit0;
x = x+wcb0+p.mg/fact;

h.text_simPSFw1 = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str1);

y = y-hedit0;

h.edit_psfW1 = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_psfW1_Callback,h_fig},'tooltipstring',ttstr1);

y = y+hedit0;
x = x+wedit0+p.mg/fact;

h.text_simPSFw2 = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str2);

y = y-hedit0;

h.edit_psfW2 = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_psfW2_Callback,h_fig},'tooltipstring',ttstr2);

x = p.mg/2;
y = y-p.mg/2-htxt0-hedit0;

h.checkbox_defocus = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str3,'callback',...
    {@checkbox_defocus_Callback,h_fig},'tooltipstring',ttstr3);

x = x+wcb0+p.mg/fact;
y = y+hedit0;

h.text_simzdec = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str4);

y = y-hedit0;

h.edit_simzdec = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_simzdec_Callback,h_fig},'tooltipstring',ttstr4);

x = x+wedit0+p.mg/fact;
y = y+hedit0;

h.text_simz0 = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str5);

y = y-hedit0;

h.edit_simz0_A = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_simz0_A_Callback,h_fig},'tooltipstring',ttstr5);

x = p.mg/2;
y = p.mg/2;

h.uipanel_S_background = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'title',ttl0,'position',...
    [x,y,wpan,hpan]);
h = buildPanelSimBackground(h,p);
