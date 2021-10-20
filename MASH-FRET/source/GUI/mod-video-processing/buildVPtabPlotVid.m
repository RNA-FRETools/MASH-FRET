function h = buildVPtabPlotVid(h,p)
% h = buildVPtabPlotVid(h,p)
%
% Builds tab "Video" in Video processing's visualization area.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_VP_plot_vid: handle to tab "Video"

% defaults
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
hsld0 = 20;
fact = 5;
lim = [0,99999];
limMov = [0,9999];
gray = [0.93,0.93,0.93];
maxframe = 99999;
str0 = 'File:';
str1 = 'Units per s.';
str2 = 'colormap:';
str3 = {'Jet','Gray','Hot','Cool','Spring','Summer','Autumn','Winter',...
    'Pink','Bone','Copper'};
str4 = '+';
str5 = 'Z';
str6 = 'Tool:';
str7 = 'Frame';
str8 = 'of';
str9 = 'Size:';
str10 = 'x';
str11 = 'Channel splitting:';
ylbl0 = 'intensity(counts /pix)';
ttstr0 = wrapHtmlTooltipString('<b>Intensity units:</b> image counts per time bin or per second (affects displayed intensities in the visualization area, displayed intensities when using the "create trace" cursor and intensity parameters used in Spotfinder).');
ttstr1 = wrapHtmlTooltipString('<b>Select a colormap:</b> color scale for pixel intensities.');
ttstr2 = wrapHtmlTooltipString('Activate <b>"create trace" cursor:</b> clicking on one pixel of the video will create intensity-time traces from this position.');
ttstr3 = wrapHtmlTooltipString('Activate <b>zoom cursor:</b> regular MATLAB zoom tool.');
ttstr4 = wrapHtmlTooltipString('Video/image file:</b> source file where video frames are taken from.');

% parents
h_fig = h.figure_MASH;
h_tab = h.uitab_VP_plot_vid;

% dimensions
postab = get(h_tab,'position');
haxes0 = postab(4)-p.mgtab-hpop0-2*p.mg-hsld0-p.mg-htxt0-p.mg;
waxes0 = haxes0;
wbut0 = max([getUItextWidth(str4,p.fntun,p.fntsz1,'bold',p.tbl),...
    getUItextWidth(str5,p.fntun,p.fntsz1,'bold',p.tbl)])+p.wbrd;
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl);
wcb0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wpop0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.warr;
wtxt2 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt3 = getUItextWidth(str7,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt4 = getUItextWidth(num2str(maxframe),p.fntun,p.fntsz1,'normal',p.tbl);
wtxt5 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt6 = getUItextWidth(str9,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt7 = getUItextWidth(num2str(limMov(2)),p.fntun,p.fntsz1,'normal',p.tbl);
wtxt8 = getUItextWidth(str10,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt9 = postab(3)-2*p.mg-2*p.mg-wtxt3-wtxt4*2-wtxt5-wtxt6-wtxt7*2-wtxt8;

% GUI
x = p.mg;
y = p.mg+htxt0+p.mg+hedit0+p.mg;

h.axes_VP_vid = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'xlim',limMov,'ylim',limMov,'clim',lim,'nextplot',...
    'replacechildren','DataAspectRatioMode','manual','DataAspectRatio',...
    [1 1 1],'ydir','reverse');
h_axes = h.axes_VP_vid;
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');

h.cb_VP_vid = colorbar(h_axes,'units',p.posun);
ylabel(h.cb_VP_vid,ylbl0);
poscb = get(h.cb_VP_vid,'position');

posaxes(3) = posaxes(3)-2.6*poscb(3);
set(h_axes,'position',posaxes);

wedit0 = posaxes(3)-wtxt0-p.mg-wtxt2-2*wbut0-p.mg/fact;

x = posaxes(1);
y = postab(4)-p.mgtab-hedit0+(hedit0-htxt0)/2;
h.text_VP_file = uicontrol('style','text','parent',h_tab,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str0,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;
h.edit_movFile = uicontrol('style','edit','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr4,'foregroundcolor',p.fntclr1);

x = x+wedit0+p.mg;
y = y+(hedit0-htxt0)/2;

h.text_tool = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt2,htxt0],...
    'string',str6);

x = x+wtxt2+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.togglebutton_target = uicontrol('style','togglebutton','parent',h_tab,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str4,'callback',...
    {@switchMovTool,h_fig},'value',0,'tooltipstring',ttstr2,...
    'backgroundcolor',gray);

x = x+wbut0+p.mg/fact;

h.togglebutton_zoom = uicontrol('style','togglebutton','parent',h_tab,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str5,'callback',...
    {@switchMovTool,h_fig},'value',1,'tooltipstring',ttstr3,...
    'backgroundcolor',gray);

x = posaxes(1)+wtxt0;
y = y-p.mg-hpop0+(hpop0-hedit0)/2;

h.checkbox_int_ps = uicontrol('style','checkbox','parent',h_tab,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str1,'callback',...
    {@checkbox_int_ps_Callback,h_fig},'tooltipstring',ttstr0);

x = x+wcb0+p.mg;
y = y+(hedit0-htxt0)/2;

h.text_VP_cmap = uicontrol('style','text','parent',h_tab,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt1,htxt0],'string',str2);

x = x+wtxt1;
y = y-(hpop0-htxt0)/2;

h.popupmenu_colorMap = uicontrol('style','popupmenu','parent',h_tab,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str3,'callback',...
    {@popupmenu_colorMap_Callback,h_fig},'tooltipstring',ttstr1);

x = posaxes(1);
y = p.mg+htxt0+p.mg;

h.slider_img = uicontrol('style','slider','parent',h_tab,'units',p.posun,...
    'position',[x,y,posaxes(3),hedit0],'callback',...
    {@slider_img_Callback,h_fig});

y = y-p.mg-htxt0;

h.text_frame = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt3,htxt0],...
    'string',str7,'horizontalalignment','right');

x = x+wtxt3;

h.text_frameCurr = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt4,htxt0],...
    'string','');

x = x+wtxt4;

h.text_frameOf = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt5,htxt0],...
    'string',str8);

x = x+wtxt5;

h.text_frameEnd = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt4,htxt0],...
    'string','');

x = x+wtxt4+p.mg;

h.text_VP_size = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt6,htxt0],...
    'string',str9,'horizontalalignment','right');

x = x+wtxt6;

h.text_movW = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt7,htxt0],...
    'string','');

x = x+wtxt7;

h.text_VP_x = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt8,htxt0],...
    'string',str10);

x = x+wtxt8;

h.text_movH = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt7,htxt0],...
    'string','');

x = x+wtxt7+p.mg;

h.text_split = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt9,htxt0],...
    'string',str11,'horizontalalignment','left');


