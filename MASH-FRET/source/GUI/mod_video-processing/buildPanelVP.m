function h = buildPanelVP(h,p)
% h = buildPanelVP(h,p);
%
% Builds module "Video processing" including panels "Plot", "Experiment settings", "Edit video", "Coordinates" and "Intensity integration".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_VP: handle to the panel containing "Video processing" module
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.wttsr: pixel width of tooltip box
%   p.fntclr1: text color in file/folder fields
%   p.wbuth: pixel width of help buttons
%   p.tbl: reference table listing character's pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
hsld0 = 20;
fact = 5;
limMov = [0,9999];
lim = [0,10000];
gray = [0.93,0.93,0.93];
maxframe = 99999;
wpan0 = 106;
ylbl0 = 'intensity(counts /pix)';
str0 = 'Load...';
str1 = 'Free';
str2 = '+';
str3 = 'Z';
str4 = 'Tool:';
str5 = 'Frame';
str6 = 'of';
str7 = 'Size:';
str8 = 'x';
str9 = 'Channel splitting:';
ttl0 = 'Plot';
ttl1 = 'Experiment settings';
ttl2 = 'Edit and export video';
ttl3 = 'Molecule coordinates';
ttl4 = 'Intensity integration';
ttstr0 = wrapStrToWidth('Open browser and <b>select a video/image file</b> to load.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Free memory from video data</b>: to be done when you are done with video processing; this will increase the general processing time.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('Activate <b>"create trace" cursor:</b> clicking on one pixel of the video will create intensity-time traces from this position.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('Activate <b>zoom cursor:</b> regular MATLAB zoom tool.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('Video/image file:</b> source file where video frames are taken from.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_VP;

% dimensions
pospan = get(h_pan,'position');
haxes0 = pospan(4)-5*p.mg-hedit0-hsld0-htxt0;
waxes0 = haxes0;
wbut0 = getUItextWidth(str0,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wbut1 = getUItextWidth(str1,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wbut2 = max([hedit0,max([getUItextWidth(str2,p.fntun,p.fntsz1,'bold',p.tbl),...
    getUItextWidth(str3,p.fntun,p.fntsz1,'bold',p.tbl)])+p.wbrd]);
wtxt0 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt2 = getUItextWidth(num2str(maxframe),p.fntun,p.fntsz1,'normal',p.tbl);
wtxt3 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt4 = getUItextWidth(str7,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt5 = getUItextWidth(num2str(limMov(2)),p.fntun,p.fntsz1,'normal',p.tbl);
wtxt6 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl);
hpan0 = p.mgpan+p.mg/2+p.mg/fact+hedit0+hpop0;
hpan1 = p.mgpan+2*p.mg/fact+p.mg/2+3*hedit0+htxt0;
hpan3 = p.mgpan+3*p.mg/2+3*hedit0;
hpan2 = pospan(4)-2*p.mg-3*p.mg/2-hpan0-hpan1-hpan3;

% GUI
x = p.mg;
y = 3*p.mg+hsld0+htxt0;

h.axes_movie = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'xlim',limMov,'ylim',limMov,'clim',lim,'nextplot',...
    'replacechildren','DataAspectRatioMode','manual','DataAspectRatio',...
    [1 1 1],'ydir','reverse');
h_axes = h.axes_movie;
tiaxes = get(h_axes,'tightinset');
% adjust axes dimensions
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
% add color bar
h.colorbar = colorbar(h_axes,'units',p.posun);
ylabel(h.colorbar,ylbl0);
set(h_axes,'position',posaxes);
pos_cb = get(h.colorbar,'position');

% dimensions (complement)
wedit0 = posaxes(3)-4*p.mg/fact-p.mg-wbut0-wbut1-wbut2*2-wtxt0-p.wbuth;
wtxt7 = posaxes(3)-2*p.mg-wtxt1-wtxt2*2-wtxt3-wtxt4-wtxt5*2-wtxt6;
wpan1 = pospan(3)-2*p.mg-posaxes(1)-posaxes(3)-4*pos_cb(3)-wpan0;
wpan2 = pospan(3)-p.mg-posaxes(1)-posaxes(3)-4*pos_cb(3);

% GUI
x = posaxes(1)+p.wbuth+p.mg/fact;
y = pospan(4)-p.mg-hedit0;

h.pushbutton_loadMov = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str0,'callback',...
    {@pushbutton_loadMov_Callback,h_fig},'tooltipstring',ttstr0);

x = x+wbut0+p.mg/fact;

h.pushbutton_VP_freeMem = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut1,hedit0],'string',str1,'callback',...
    {@pushbutton_VP_freeMem_Callback,h_fig},'tooltipstring',ttstr1);

x = posaxes(1)+posaxes(3)-wbut2;

h.togglebutton_target = uicontrol('style','togglebutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut2,hedit0],'string',str2,'callback',...
    {@switchMovTool,h_fig},'value',0,'tooltipstring',ttstr2,...
    'backgroundcolor',gray);

x = x-p.mg/fact-wbut2;

h.togglebutton_zoom = uicontrol('style','togglebutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut2,hedit0],'string',str3,'callback',...
    {@switchMovTool,h_fig},'value',1,'tooltipstring',ttstr3,...
    'backgroundcolor',gray);

x = x-wtxt0;
y = y+(hedit0-htxt0)/2;

h.text_tool = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str4);

x = x-p.mg-wedit0;
y = y-(hedit0-htxt0)/2;

h.edit_movFile = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr4,'foregroundcolor',p.fntclr1);

x = posaxes(1);
y = p.mg;

h.text_frame = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str5,'horizontalalignment','right');

x = x+wtxt1;

h.text_frameCurr = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt2,htxt0],...
    'string','');

x = x+wtxt2;

h.text_frameOf = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt3,htxt0],...
    'string',str6);

x = x+wtxt3;

h.text_frameEnd = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt2,htxt0],...
    'string','');

x = x+wtxt2+p.mg;

h.text_VP_size = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt4,htxt0],...
    'string',str7,'horizontalalignment','right');

x = x+wtxt4;

h.text_movW = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt5,htxt0],...
    'string','');

x = x+wtxt5;

h.text_VP_x = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt6,htxt0],...
    'string',str8);

x = x+wtxt6;

h.text_movH = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt5,htxt0],...
    'string','');

x = x+wtxt5+p.mg;

h.text_split = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt7,htxt0],...
    'string',str9,'horizontalalignment','left');

x = posaxes(1);
y = y +htxt0+p.mg;

h.slider_img = uicontrol('style','slider','parent',h_pan,'units',p.posun,...
    'position',[x,y,posaxes(3),hedit0],'callback',...
    {@slider_img_Callback,h_fig});

x = x+posaxes(3)+4*pos_cb(3);
y = pospan(4)-p.mg-hpan0;

h.uipanel_VP_plot = uipanel('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan0],'title',ttl0);
h = buildPanelVPplot(h,p);

x = x+wpan0+p.mg;

h.uipanel_VP_experimentSettings = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan0],'title',ttl1);
h = buildPanelVPexperimentSettings(h,p);

x = x-wpan0-p.mg;
y = y-p.mg/2-hpan1;

h.uipanel_VP_editAndExportVideo = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan2,hpan1],'title',ttl2);
h = buildPanelVPeditAndExportVideo(h,p);

y = y-p.mg/2-hpan2;

h.uipanel_VP_moleculeCoordinates = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan2,hpan2],'title',ttl3);
h = buildPanelVPmoleculeCoordinates(h,p);

y = p.mg;

h.uipanel_VP_intensityIntegration = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan2,hpan3],'title',ttl4);
h = buildPanelVPintensityIntegration(h,p);
