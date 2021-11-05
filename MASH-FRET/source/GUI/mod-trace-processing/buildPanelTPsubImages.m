function h = buildPanelTPsubImages(h,p)
% h = buildPanelTPsubImages(h,p);
%
% Builds "Sub-images" panel in the "Trace processing" module
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP_subImages: handle to panel "Sub-images"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 13;
hpop0 = 22;
fact = 5;
file_icon0 = 'target.png';
str0 = 'show laser';
str1 = 'brightness';
str2 = 'contrast';
str3 = 'Select a laser';
str4 = '0%';
str5 = 'Coordinates:';
str6 = 'in channel';
str7 = 'x';
str8 = 'y';
str9 = 'Select a channel';
ttstr0 = wrapHtmlTooltipString('Select a <b>laser wavelength</b> to show sub-images from.');
ttstr1 = wrapHtmlTooltipString('Adjust the <b>brightness</b> in molecule sub-images.');
ttstr2 = wrapHtmlTooltipString('Adjust the <b>contrast</b> in molecule sub-images.');
ttstr3 = wrapHtmlTooltipString('Select the <b>emission channel</b> where molecule coordinates need to be adjusted.');
ttstr4 = wrapHtmlTooltipString('<b>Molecule position:</b> x-coordinate of the current single molecule in the selected emission channel.');
ttstr5 = wrapHtmlTooltipString('<b>Molecule position:</b> y-coordinate of the current single molecule in the selected emission channel.');
ttstr6 = wrapHtmlTooltipString('<b>Recenter positions</b> in all emission channels: recenters on the brightest pixel of the 3-by-3 pixel area around the current position; the process is iterative with three iterations max.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_subImages;

% dimensions
pospan = get(h_pan,'position');
wtxt0a = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt0b = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt0 = max([wtxt0a,wtxt0b]);
wedit0 = (pospan(3)-p.mg-wtxt0-3*p.mg/fact-p.wbut1-p.mg)/2;
wsld0 = (pospan(3)-3*p.mg-wtxt0)/2;
wtxt1 = pospan(3)-2*p.mg;

% images
pname = [fileparts(mfilename('fullpath')),filesep,'..',filesep];
img0 = imread([pname,file_icon0]);

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TP_subImg_exc = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str0);

x = x+wtxt0+p.mg/2;

h.text_TP_subImg_brightness = uicontrol('style','text','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wsld0,htxt0],'string',str1);

x = x+wsld0+p.mg/2;

h.text_TP_subImg_contrast = uicontrol('style','text','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wsld0,htxt0],'string',str2);

x = p.mg;
y = y-hpop0;

h.popupmenu_subImg_exc = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hpop0],'string',str3,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_subImg_exc_Callback,h_fig});

x = x+wtxt0+p.mg/2;
y = y+(hpop0-htxt0);

h.slider_brightness = uicontrol('style','slider','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wsld0,htxt0],'tooltipstring',ttstr1,'value',0.5,'callback',...
    {@slider_brightness_Callback,h_fig});

y = y-htxt0;

h.text_brightness = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wsld0,htxt0],'string',str4);

x = x+wsld0+p.mg/2;
y = y+htxt0;

h.slider_contrast = uicontrol('style','slider','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wsld0,htxt0],'tooltipstring',ttstr2,'value',0.5,'callback',...
    {@slider_contrast_Callback,h_fig});

y = y-htxt0;

h.text_contrast = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wsld0,htxt0],'string',str4);

x = p.mg;
y = y-p.mg/fact-htxt0;

h.text_TP_subImg_coordinates = uicontrol('style','text','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontangle',...
    'italic','position',[x,y,wtxt1,htxt0],'horizontalalignment','left',...
    'string',str5);

y = y-p.mg/fact-htxt0;

h.text_TP_subImg_channel = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str6);

x = x+wtxt0+p.mg/fact;

h.text_TP_subImg_x = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str7);

x = x+wedit0+p.mg/fact;

h.text_TP_subImg_y = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str8);

x = p.mg;
y = y-hpop0;

h.popupmenu_TP_subImg_channel = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wtxt0,hpop0],'string',str9,'tooltipstring',ttstr3,...
    'callback',{@popupmenu_TP_subImg_channel_Callback,h_fig});

x = x+wtxt0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_TP_subImg_x = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TP_subImg_x_Callback,h_fig},...
    'tooltipstring',ttstr4);

x = x+wedit0+p.mg/fact;

h.edit_TP_subImg_y = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TP_subImg_y_Callback,h_fig},...
    'tooltipstring',ttstr5);

x = x+wedit0+p.mg/fact;

% /!\ PUSHBUTTON /!\
h.checkbox_refocus = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,p.wbut1,hedit0],'tooltipstring',ttstr6,'cdata',img0,'callback',...
    {@pushbutton_refocus_Callback,h_fig});




