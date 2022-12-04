function h = buildPanelSimCameraSnrCharacteristics(h,p)
% h = buildPanelSimCameraSnrCharacteristics(h,p);
%
% Builds panel "Camera SNR characteristics" in "Simulation" module
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_S_cameraSnrCharacteristics: handle to the panel "Camera SNR characteristics"
% p: structure containing default and often-used parameters (dimensions, margin etc.) with fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hpop0 = 22;
hedit0 = 20;
htxt0 = 14;
fact = 5;
str0 = {'P- or Poisson Model',...
    'N- or Gaussian Model',...
    'NExp-N or Gaussian + exp. tail Model',...
    'Offset only',...
    'PGN- or Hirsch Model'};
str1 = cat(2,char(956),'_ic,dark:');
str2 = cat(2,char(951),':');
str3 = 'K:';
str4 = 'A_CIC:';
str5 = cat(2,char(963),'_ic:');
str6 = cat(2,char(964),'_CIC:');
ttstr0 = wrapHtmlTooltipString('Select a distribution to describe the <b>camera noise</b>.');
ttstr1 = '';
ttstr2 = '';
ttstr3 = '';
ttstr4 = '';
ttstr5 = '';
ttstr6 = '';

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S_cameraSnrCharacteristics;

% dimensions
pospan = get(h_pan,'position');
wpop = pospan(3)-2*p.mg;
wtxt0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl);
wedit1 = (wpop-wtxt0-wtxt1)/2;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hpop0;

h.popupmenu_noiseType = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop,hpop0],'string',str0,'callback',...
    {@popupmenu_noiseType_Callback,h_fig},'tooltipstring',ttstr0);

x = p.mg;
y = y-p.mg/2-hedit0+(hedit0-htxt0)/2;

h.text_camNoise_01 = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str1,'horizontalalignment','right');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_camNoise_01 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'callback',{@edit_camNoise_01_Callback,h_fig},...
    'tooltipstring',ttstr1);

x = x+wedit1;
y = y+(hedit0-htxt0)/2;

h.text_camNoise_02 = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt1,htxt0],'string',str2,'horizontalalignment','right');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

h.edit_camNoise_02 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'callback',{@edit_camNoise_02_Callback,h_fig},...
    'tooltipstring',ttstr2);

x = p.mg;
y = y-p.mg/fact-hedit0+(hedit0-htxt0)/2;

h.text_camNoise_03 = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str3,'horizontalalignment','right');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_camNoise_03 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'callback',{@edit_camNoise_03_Callback,h_fig},...
    'tooltipstring',ttstr3);

x = x+wedit1;
y = y+(hedit0-htxt0)/2;

h.text_camNoise_04 = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt1,htxt0],'string',str4,'horizontalalignment','right');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

h.edit_camNoise_04 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'callback',{@edit_camNoise_04_Callback,h_fig},...
    'tooltipstring',ttstr4);

x = p.mg;
y = y-p.mg/fact-hedit0+(hedit0-htxt0)/2;

h.text_camNoise_05 = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str5,'horizontalalignment','right');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_camNoise_05 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'callback',{@edit_camNoise_05_Callback,h_fig},...
    'tooltipstring',ttstr5);

x = x+wedit1;
y = y+(hedit0-htxt0)/2;

h.text_camNoise_06 = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt1,htxt0],'string',str6,'horizontalalignment','right');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

h.edit_camNoise_06 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'callback',{@edit_camNoise_06_Callback,h_fig},...
    'tooltipstring',ttstr6);
