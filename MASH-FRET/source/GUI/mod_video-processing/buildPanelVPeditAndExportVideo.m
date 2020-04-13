function h = buildPanelVPeditAndExportVideo(h,p)
% h = buildPanelVPeditAndExportVideo(h,p);
%
% Builds "Edit and export video" panel in "Video processing" module
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_VP_editAndExportVideo: handle to the panel "Edit and export video"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbox: box's pixel width in checkboxes
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
wedit0 = 40;
htxt0 = 14;
hpop0 = 22;
fact = 5;
str0 = {'Method','(sensitive) Gaussian filter','mean filter',...
    'median filter','(sensitive) Crocker-Grier filter',...
    '(sensitive) local Wiener filter','(sensitive) global Wiener filter',...
    '(sensitive) outlier filter','(sensitive) histotresh filter',...
    '(sensitive) simpletresh filter','mean value','most frequent',...
    'subtract histotresh','Ha average','Ha framewise','TwoTone',...
    'subtract image','multiplication','addition'};
str1 = 'Add';
str2 = 'all frames';
str3 = 'Channel n°:';
str4 = 'Select a channel';
str5 = 'Remove filter';
str6 = 'Export...';
str7 = 'start';
str8 = 'end';
ttstr0 = wrapHtmlTooltipString('<b>Select an image filter/correction</b> to configure.');
ttstr1 = wrapHtmlTooltipString('<b>Add filter</b> to list: filters/corrections are applied one after the other according to the list order.');
ttstr2 = wrapHtmlTooltipString('<b>Filter/correct all frames:</b> each frame is processed individually (otherwise, only the current frame will be processed).');
ttstr3 = wrapHtmlTooltipString('<b>Select the channel</b> to configure the filter/correction for: channels are numebred from left to right.');
ttstr4 = wrapHtmlTooltipString('<b>Remove</b> selected filter/correction from the list.');
ttstr5 = wrapHtmlTooltipString('<b>Export</b> edited image/video to file.');
ttstr6 = wrapHtmlTooltipString('<b>First video frame</b> in the frame range to export.');
ttstr7 = wrapHtmlTooltipString('<b>Last video frame</b> in the frame range to export.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_VP_editAndExportVideo;

% dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wtxt0 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl);
wcb0 = 2*p.mg/fact+wtxt0+3*wedit0;
wpop0 = wcb0-wbut0-p.mg/fact;
wbut1 = p.mg/fact+2*wedit0;
wlst0 = pospan(3)-4*p.mg-wcb0-wbut1;
hlst0 = pospan(4)-p.mgpan-p.mg/2;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hpop0;

h.popupmenu_bgCorr = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_bgCorr_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.pushbutton_addBgCorr = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str1,'callback',...
    {@pushbutton_addBgCorr_Callback,h_fig},'tooltipstring',ttstr1);

x = p.mg;
y = y-(hpop0-hedit0)/2-hedit0;

h.checkbox_bgCorrAll = uicontrol('style','checkbox','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wcb0,hedit0],...
    'string',str2,'callback',{@checkbox_bgCorrAll_Callback,h_fig},...
    'tooltipstring',ttstr2);

y = p.mg/2+(hpop0-htxt0)/2;

h.text_bgChannel = uicontrol('style','text','parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],'string',str3,...
    'horizontalalignment','left');

x = x+wtxt0;
y = p.mg/2;

h.popupmenu_bgChanel = uicontrol('style','popupmenu','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hpop0],...
    'string',str4,'callback',{@popupmenu_bgChanel_Callback,h_fig},...
    'tooltipstring',ttstr3);

x = x+wedit0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_bgParam_01 = uicontrol('style','edit','parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],'callback',...
    {@edit_bgParam_01_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_bgParam_02 = uicontrol('style','edit','parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],'callback',...
    {@edit_bgParam_02_Callback,h_fig});

x = p.mg+wcb0+p.mg;

h.listbox_bgCorr = uicontrol('style','listbox','parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wlst0,hlst0],'string',...
    {''});

x = x+wlst0+p.mg;
y = pospan(4)-p.mgpan-hedit0;

h.pushbutton_remBgCorr = uicontrol('style','pushbutton','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wbut1,hedit0],...
    'string',str5,'callback',{@pushbutton_remBgCorr_Callback,h_fig},...
    'tooltipstring',ttstr4);

y = y-p.mg/fact-hedit0;

h.pushbutton_export = uicontrol('style','pushbutton','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wbut1,hedit0],...
    'string',str6,'tooltipstring',ttstr5,'callback',...
    {@pushbutton_export_Callback,h_fig});

y = y-p.mg/fact-htxt0;

h.text_movStart = uicontrol('style','text','parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],'string',...
    str7);

y = y-hedit0;

h.edit_startMov = uicontrol('style','edit','parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],'callback',...
    {@edit_startMov_Callback,h_fig},'tooltipstring',ttstr6);

x = x+wedit0+p.mg/fact;
y = y+hedit0;

h.text_endMov = uicontrol('style','text','parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],'string',...
    str8);

y = y-hedit0;

h.edit_endMov = uicontrol('style','edit','parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],'callback',...
    {@edit_endMov_Callback,h_fig},'tooltipstring',ttstr7);

