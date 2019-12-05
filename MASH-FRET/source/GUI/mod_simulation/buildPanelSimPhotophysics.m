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
%   p.wttsr: pixel width of tooltip box
%   p.tbl: reference table listing character's pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 14;
fact = 5;
str0 = 'Itot,em';
str1 = 'wItot,em';
str2 = 'in photons';
str3 = 'g';
str4 = 'wg';
str5 = 'dED';
str6 = 'dEA';
str7 = 'BtD';
str8 = 'BtA';
str9 = 'PB';
ttstr0 = wrapStrToWidth('<b>Total intensity</b> (counts/time bin): pure donor fluorescence intensity collected in absence of acceptor.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Sample heterogeneity:</b> standard deviation of the Itot,em Gaussian distribution (counts/time bin).',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Intensity units of simulation parameters:</b> photon counts or amplified electron counts (only total intensity and background intensities are concerned).',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('<b>Gamma factor:</b> modulate the donor fluorescence intensity.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Sample heterogeneity:</b> standard deviation of the &#947; factor Gaussian distribution.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('<b>Direct excitation coefficient</b> of donor upon acceptor excitation (given as a fraction of the total intensity)',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr6 = wrapStrToWidth('<b>Direct excitation coefficient</b> of acceptor upon donor excitation (given as a fraction of the total intensity)',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr7 = wrapStrToWidth('<b>Bleedthrough coefficient</b> of donor emission in acceptor channel.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr8 = wrapStrToWidth('<b>Bleedthrough coefficient</b> of acceptor emission in acceptor channel.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr9 = wrapStrToWidth('<b>Simulate donor photobleaching</b>: photobleaching times are randomly drawn from an exponentially decaying ditribution.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr10 = wrapStrToWidth('<b>Decay constant (in seconds)</b>: characterizes the distribution of photobleaching times.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S_photophysics;

% dimensions

pospan = get(h_pan,'position');
wtxt0 = (pospan(3)-p.mg-p.mg/fact)/2;
wcb0 = 2*wtxt0+p.mg/fact;
wtxt1 = getUItextWidth('PB',p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = wtxt1+p.wbox;
wedit0 = pospan(3)-wtxt1-p.mg-p.mg/fact;

% GUI
x = p.mg/2;
y = pospan(4)-2*p.mg-htxt0;

h.text_simItotVal = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str0);

x = x+wtxt0+p.mg/fact;

h.text_simItotDelta = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str1);

x = p.mg/2;
y = y-hedit0;

h.edit_totInt = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hedit0],'callback',{@edit_totInt_Callback,h_fig},...
    'tooltipstring',ttstr0);

x = x+wtxt0+p.mg/fact;

h.edit_dstrbNoise = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hedit0],'callback',{@edit_dstrbNoise_Callback,h_fig},...
    'tooltipstring',ttstr1);

x = p.mg/2;
y = y-hedit0;

h.checkbox_photon = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str2,'callback',...
    {@checkbox_photon_Callback,h_fig},'tooltipstring',ttstr2);

y = y-p.mg/fact-htxt0;

h.text_simGval = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str3);

x = x+wtxt0+p.mg/fact;

h.text_simGdelta = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str4);

x = p.mg/2;
y = y-hedit0;

h.edit_gamma = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hedit0],'callback',{@edit_gamma_Callback,h_fig},...
    'tooltipstring',ttstr3);

x = x+wtxt0+p.mg/fact;

h.edit_gammaW = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hedit0],'callback',{@edit_gammaW_Callback,h_fig},...
    'tooltipstring',ttstr4);

x = p.mg/2;
y = y-p.mg/fact-htxt0;

h.text_simDeD = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str5);

x = x+wtxt0+p.mg/fact;

h.text_simDeA = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str6);

x = p.mg/2;
y = y-hedit0;

h.edit_simDeD = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hedit0],'callback',{@edit_simDeD_Callback,h_fig},...
    'tooltipstring',ttstr5);

x = x+wtxt0+p.mg/fact;

h.edit_simDeA = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hedit0],'callback',{@edit_simDeA_Callback,h_fig},...
    'tooltipstring',ttstr6);

x = p.mg/2;
y = y-p.mg/fact-htxt0;

h.text_simBtD = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str7);

x = x+wtxt0+p.mg/fact;

h.text_simBtA = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str8);

x = p.mg/2;
y = y-hedit0;

h.edit_simBtD = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hedit0],'callback',{@edit_simBtD_Callback,h_fig},...
    'tooltipstring',ttstr7);

x = x+wtxt0+p.mg/fact;

h.edit_simBtA = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hedit0],'callback',{@edit_simBtA_Callback,h_fig},...
    'tooltipstring',ttstr8);

x = p.mg/2;
y = p.mg/2;

h.checkbox_simBleach = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt1,hedit0],'string',str9,'callback',...
    {@checkbox_simBleach_Callback,h_fig},'tooltipstring',ttstr9);

x = x+wtxt1+p.mg/fact;

h.edit_simBleach = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_simBleach_Callback,h_fig},...
    'tooltipstring',ttstr10);
