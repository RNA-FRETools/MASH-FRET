function h = buildPanelVPexperimentSettings(h,p)
% h = buildPanelVPexperimentSettings(h,p);
%
% Builds "Experiment settings" panel in "Video processing" module
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_VP_experimentSettings: handle to the panel "Experiment settings"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wttsr: pixel width of tooltip box
%   p.tbl: reference table listing character's pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
fact = 5;
str0 = 'Nb. of lasers:';
str1 = 'Laser n°:';
str2 = {'select a laser'};
str3 = 'nm';
str4 = 'Nb. of channels:';
str5 = 'Exposure time:';
str6 = 's';
str7 = 'Options...';
ttstr0 = wrapStrToWidth('<b>Number of alternated lasers</b> used in the video recording.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Select a laser</b> to configure: lasers are numbered according to the order of appearance in the video.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Characetristic wavelength</b> of selected laser.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('<b>Number of spectroscopic channels</b> imaged in the video.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Acquisition time (in seconds):</b> time spent to acquire one video frame.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('Open <b>project options:</b> includes informations about emitters, FRET pairs and user-defined experimental conditions.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_VP_experimentSettings;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt2 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt3 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl);
wedit0 = (pospan(3)-p.mg-2*p.mg/fact-wtxt0-wtxt1-wtxt3-wtxt2)/3;
wbut0 = wtxt2+wedit0;

% GUI
x = p.mg/2;
y = pospan(4)-p.mgpan-hpop0+(hpop0-htxt0)/2;

h.text_VP_exc = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str0,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_nLasers = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_nLasers_Callback,h_fig},'tooltipstring',ttstr0);

x = x+wedit0+p.mg/fact;
y = y+(hedit0-htxt0)/2;

h.text_VP_excindex = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str1,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hpop0-htxt0)/2;

h.popupmenu_TTgen_lasers = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hpop0],'string',str2,'callback',...
    {@popupmenu_TTgen_lasers_Callback,h_fig},'tooltipstring',ttstr1);

x = x+wedit0+wtxt3+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_wavelength = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_wavelength_Callback,h_fig},'tooltipstring',ttstr2);

x = x+wedit0;
y = y+(hedit0-htxt0)/2;

h.text_VP_nm = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt2,htxt0],...
    'string',str3,'horizontalalignment','left');

x = p.mg/2;
y = p.mg/2+(hedit0-htxt0)/2;

h.text_VP_nChan = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str4,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_nChannel = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_nChannel_Callback,h_fig},'tooltipstring',ttstr3);

x = x+wedit0+p.mg/fact;
y = y+(hedit0-htxt0)/2;

h.text_VP_expTime = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str5,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

h.edit_rate = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_rate_Callback,h_fig},'tooltipstring',ttstr4);

x = x+wedit0;
y = y+(hedit0-htxt0)/2;

h.text_VP_s = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt3,htxt0],...
    'string',str6,'horizontalalignment','left');

x = x+wtxt3+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.pushbutton_chanOpt = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str7,'callback',{@openItgExpOpt,h_fig},...
    'tooltipstring',ttstr5);



