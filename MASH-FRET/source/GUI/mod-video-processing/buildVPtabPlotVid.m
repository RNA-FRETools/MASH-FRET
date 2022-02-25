function h = buildVPtabPlotVid(h,p)
% h = buildVPtabgroupPlotVid(h,p)
%
% Builds tab "Video" in Video processing's visualization area.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uitab_VP_plot_vid: handle to tab "Video"
% p: structure containing default and often-used GUI parameters

% defaults
hedit0 = 20;
htxt0 = 14;
fact = 5;
gray = [0.93,0.93,0.93];
maxframe = 99999;
str1 = '+';
str2 = 'Z';
str3 = 'Tool:';
str4 = 'Frame';
str5 = 'of';
str6 = 's';
str9 = 'Channel splitting:';
ttstr0 = wrapHtmlTooltipString('Activate <b>"create trace" cursor:</b> clicking on one pixel of the video will create intensity-time traces from this position.');
ttstr1 = wrapHtmlTooltipString('Activate <b>zoom cursor:</b> regular MATLAB zoom tool.');

% parents
h_fig = h.figure_MASH;
h_tab = h.uitab_VP_plot_vid;

% dimensions
postab = get(h_tab,'position');
wbut0 = max([getUItextWidth(str1,p.fntun,p.fntsz1,'bold',p.tbl),...
    getUItextWidth(str2,p.fntun,p.fntsz1,'bold',p.tbl)])+p.wbrd;
wtxt2 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt3 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt4 = getUItextWidth(num2str(maxframe),p.fntun,p.fntsz1,'normal',p.tbl);
wtxt5 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt6 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl);
wtg = postab(3)-2*p.mg;
htg = postab(4)-p.mgtab-p.mg-hedit0-p.mg-hedit0-p.mg;
wtxt10 = postab(3)-(p.mg+wtxt3+2*wtxt4+wtxt6+wtxt5+2*p.mg+wtxt2+p.mg/fact+...
    wbut0+p.mg/fact+wbut0+p.mg);

% GUI
x = p.mg;
y = postab(4)-p.mgtab-htg;

h.uitabgroup_VP_plot_vid = uitabgroup('parent',h_tab,...
    'units',p.posun,'position',[x,y,wtg,htg],'tablocation','bottom');

y = y-p.mg-hedit0;

h.slider_img = uicontrol('style','slider','parent',h_tab,'units',...
    p.posun,'position',[x,y,wtg,hedit0],'callback',...
    {@slider_img_Callback,h_fig});

y = y-p.mg-hedit0+(hedit0-htxt0)/2;

h.text_frame = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt3,htxt0],...
    'string',str4,'horizontalalignment','right');

x = x+wtxt3;

h.text_frameCurr = uicontrol('style','text','parent',h_tab,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt4,htxt0],'string','');

x = x+wtxt4;

h.text_frameOf = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt6,htxt0],...
    'string',str5);

x = x+wtxt6;

h.text_frameEnd = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt4,htxt0],...
    'string','');

x = x+wtxt4;

h.text_frameUnits = uicontrol('style','text','parent',h_tab,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt5,htxt0],'string',str6,'horizontalalignment','left');

x = x+wtxt5+p.mg;

h.text_split = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt10,htxt0],...
    'string',str9,'horizontalalignment','left');

x = x+wtxt10+p.mg;

h.text_tool = uicontrol('style','text','parent',h_tab,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt2,htxt0],...
    'string',str3);

x = x+wtxt2+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.togglebutton_target = uicontrol('style','togglebutton','parent',h_tab,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str1,'callback',...
    {@switchMovTool,h_fig},'value',0,'tooltipstring',ttstr0,...
    'backgroundcolor',gray);

x = x+wbut0+p.mg/fact;

h.togglebutton_zoom = uicontrol('style','togglebutton','parent',h_tab,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str2,'callback',...
    {@switchMovTool,h_fig},'value',1,'tooltipstring',ttstr1,...
    'backgroundcolor',gray);
