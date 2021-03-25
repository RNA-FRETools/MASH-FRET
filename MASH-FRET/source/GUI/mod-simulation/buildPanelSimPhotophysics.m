function h = buildPanelSimPhotophysics(h,p)
% h = buildPanelSimPhotophysics(h,p);
%
% Build panel "Photophysics" in "Simulation" module
% 
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_S_photophysics: handle to panel "Photophysics"
% p: structure containing default and often-used parameters (dimensions, margin etc.) with fields:
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
str0 = 'Itot';
str1 = 'wItot';
str2 = 'in photons';
str3 = char(947);
str4 = ['w',char(947)];
str5 = 'dED';
str6 = 'dEA';
str7 = 'BtD';
str8 = 'BtA';
str9 = 'Photobleaching decay (s):';
str10 = 'decay (s)';
ttstr0 = wrapHtmlTooltipString('<b>Total intensity</b> (counts/time bin): pure donor fluorescence intensity collected in absence of acceptor.');
ttstr1 = wrapHtmlTooltipString('<b>Sample heterogeneity:</b> standard deviation of the Itot,em Gaussian distribution (counts/time bin).');
ttstr2 = wrapHtmlTooltipString('<b>Intensity units of simulation parameters:</b> photon counts or amplified electron counts (only total intensity and background intensities are concerned).');
ttstr3 = wrapHtmlTooltipString('<b>Gamma factor:</b> modulate the donor fluorescence intensity.');
ttstr4 = wrapHtmlTooltipString('<b>Sample heterogeneity:</b> standard deviation of the &#947; factor Gaussian distribution.');
ttstr5 = wrapHtmlTooltipString('<b>Direct excitation coefficient</b> of donor upon acceptor excitation (given as a fraction of the total intensity)');
ttstr6 = wrapHtmlTooltipString('<b>Direct excitation coefficient</b> of acceptor upon donor excitation (given as a fraction of the total intensity)');
ttstr7 = wrapHtmlTooltipString('<b>Bleedthrough coefficient</b> of donor emission in acceptor channel.');
ttstr8 = wrapHtmlTooltipString('<b>Bleedthrough coefficient</b> of acceptor emission in acceptor channel.');
ttstr9 = wrapHtmlTooltipString('<b>Simulate donor photobleaching</b>: photobleaching times are randomly drawn from an exponentially decaying ditribution.');
ttstr10 = wrapHtmlTooltipString('<b>Decay constant (in seconds)</b>: characterizes the distribution of photobleaching times.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S_photophysics;

% dimensions

pospan = get(h_pan,'position');
wedit0 = (pospan(3)-3*p.mg-2*p.mg/fact)/4;
wcb0 = 2*wedit0+p.mg/fact;
wcb1 = getUItextWidth(str9,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wtxt0 = getUItextWidth(str10,p.fntun,p.fntsz1,'normal',p.tbl);

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_simItotVal = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str0);

x = x+wedit0+p.mg/fact;

h.text_simItotDelta = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str1);

x = x+wedit0+p.mg;

h.text_simGval = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str3);

x = x+wedit0+p.mg/fact;

h.text_simGdelta = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str4);

x = p.mg;
y = y-hedit0;

h.edit_totInt = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_totInt_Callback,h_fig},...
    'tooltipstring',ttstr0);

x = x+wedit0+p.mg/fact;

h.edit_dstrbNoise = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_dstrbNoise_Callback,h_fig},...
    'tooltipstring',ttstr1);

x = x+wedit0+p.mg;

h.edit_gamma = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_gamma_Callback,h_fig},...
    'tooltipstring',ttstr3);

x = x+wedit0+p.mg/fact;

h.edit_gammaW = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_gammaW_Callback,h_fig},...
    'tooltipstring',ttstr4);

x = p.mg;
y = y-p.mg/fact-hedit0;

h.checkbox_photon = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str2,'callback',...
    {@checkbox_photon_Callback,h_fig},'tooltipstring',ttstr2);

x = p.mg;
y = y-p.mg/2-htxt0;

h.text_simDeD = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str5);

x = x+wedit0+p.mg/fact;

h.text_simDeA = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str6);

x = x+wedit0+p.mg;

h.text_simBtD = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str7);

x = x+wedit0+p.mg/fact;

h.text_simBtA = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str8);

x = p.mg;
y = y-hedit0;

h.edit_simDeD = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_simDeD_Callback,h_fig},...
    'tooltipstring',ttstr5);

x = x+wedit0+p.mg/fact;

h.edit_simDeA = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_simDeA_Callback,h_fig},...
    'tooltipstring',ttstr6);

x = x+wedit0+p.mg;

h.edit_simBtD = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_simBtD_Callback,h_fig},...
    'tooltipstring',ttstr7);

x = x+wedit0+p.mg/fact;

h.edit_simBtA = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_simBtA_Callback,h_fig},...
    'tooltipstring',ttstr8);

x = p.mg;
y = y-p.mg/2-hedit0;

h.checkbox_simBleach = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb1,hedit0],'string',str9,'callback',...
    {@checkbox_simBleach_Callback,h_fig},'tooltipstring',ttstr9);

x = x+wcb1+p.mg/2;

h.edit_simBleach = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hedit0],'callback',{@edit_simBleach_Callback,h_fig},...
    'tooltipstring',ttstr10);
