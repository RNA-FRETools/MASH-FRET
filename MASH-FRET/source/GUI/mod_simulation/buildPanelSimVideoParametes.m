function h = buildPanelSimVideoParametes(h,p)
% h = buildPanelSimVideoParametes(h,p);
%
% Builds panel "Video parameters" in "Simulation" module including panel "Camera SNR characteristics"
% 
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_S_videoParameters: handle to panel "Video parameters"
% p: structure containing default and often-used parameters
% (dimensions, margin etc.) with fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wttsr: pixel width of tooltip box
%   p.tbl: reference table listing character's pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 14;
fact = 10;
str0 = 'length';
str1 = 'rate';
str2 = 'px size';
str3 = 'BR';
str4 = 'dimensions';
str5 = 'x';
ttl0 = 'Camera SNR characteristics';
ttstr0 = wrapStrToWidth('<b>Video length:</b> total number of video frames.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Frame rate</b> (in frame per second)',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Pixel dimensions</b> (um)',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('<b>Bitrate</b> (max ic /frame /px)',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Movie width</b> (pixels)',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('<b>Movie height</b> (pixels)',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S_videoParameters;

% dimensions
pospan = get(h_pan,'position');
wedit0 = (pospan(3)-p.mg-3*p.mg/fact)/4;
wtxt0 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = 2*wedit0+wtxt0;
wpan = pospan(3)-p.mg;
hpan = pospan(4)-4*p.mg-2*hedit0-2*htxt0;

x = p.mg/2;
y = pospan(4)-p.mgpan-htxt0;

h.text_simLength = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str0);

x = x+wedit0+p.mg/fact;

h.text_simFrameRate = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str1);

x = x+wedit0+p.mg/fact;

h.text_simPixDim = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str2);

x = x+wedit0+p.mg/fact;

h.text_simBitPix = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str3);

x = p.mg/2;
y = y-hedit0;

h.edit_length = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_length_Callback,h_fig},'tooltipstring',ttstr0);

x = x+wedit0+p.mg/fact;

h.edit_simRate = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_simRate_Callback,h_fig},...
    'tooltipstring',ttstr1);

x = x+wedit0+p.mg/fact;

h.edit_pixDim = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_pixDim_Callback,h_fig},'tooltipstring',ttstr2);

x = x+wedit0+p.mg/fact;

h.edit_simBitPix = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_simBitPix_Callback,h_fig},'tooltipstring',ttstr3);

x = (pospan(3)-wtxt1)/2;
y = y-p.mg/2-htxt0;

h.text_simMovDim = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str4);

y = y-hedit0;

h.edit_simMov_w = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_simMov_w_Callback,h_fig},'tooltipstring',ttstr4);

x = x+wedit0;
y = y+(hedit0-htxt0)/2;

h.text_simMov_x = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str5);

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_simMov_h = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_simMov_h_Callback,h_fig},'tooltipstring',ttstr5);

x = p.mg/2;
y = y-p.mg-hpan;

h.uipanel_S_cameraSnrCharacteristics = uipanel('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpan,hpan],'title',ttl0);
h = buildPanelSimCameraSnrCharacteristics(h,p);
