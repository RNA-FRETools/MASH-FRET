function h = buildPanelTP(h,p)
% h = buildPanelTP(h,p);
%
% Builds "Trace processing" module including panels "Sample management", "Plot", "Sub-images", "Background corrections", "Cross-talks", "Factor corrections", "Denoising", "Photobleaching" and "Find states".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP: handle to the panel containing "Trace processing" module
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.fntclr2: text color in special pushbuttons
%   p.wbuth: pixel width of help buttons
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% Last update, 10.1.2020 by MH: add panel "Cross-talks" and remove cross-talks parameters from panel "Factor corrections"
% created, 19.10.2019 by MH

% default
hedit0 = 20;
htxt0 = 13;
hsld0 = 13;
hpop0 = 22;
hbut0 = 25;
wbut0 = 25;
wedit0 = 40;
wlst1 = 90; % default label list width (invisible)
hlst1 = 80; % default label list height (invisible)
fact = 5;
file_icon1 = 'open_file.png';
file_icon2 = 'close_file.png';
file_icon3 = 'save_file.png';
file_icon5 = 'edit_file.png';
wrelaxes = 0.78;
limAx0 = [0 10000];
limAx1 = [0 0.001];
xlbl0 = 'time (s)';
xlbl1 = 'norm. freq.';
ylbl0 = 'FRET / S';
ylbl1 = 'counts per s. per pixel';
str0 = 'int. units /';
str1 = 's';
str2 = 'pixel';
str3 = 'auto.';
str4 = 'Show';
str5 = 'Opt.';
str6 = {'default labels'};
ttl0 = 'Sample management';
ttl1 = 'Plot';
ttl2 = 'Sub-images';
ttl3 = 'Background correction';
ttl4 = 'Cross-talks';
ttl5 = 'Factor corrections';
ttl6 = 'Denoising';
ttl7 = 'Photobleaching';
ttl8 = 'Find states';
ttstr1 = wrapHtmlTooltipString('<b>Import traces</b> from a .mash file or from a set of ASCII files.');
ttstr2 = wrapHtmlTooltipString('<b>Close selected project</b> and remove it from the list.');
ttstr3 = wrapHtmlTooltipString('Open <b>project options:</b> includes informations about emitters, FRET pairs and user-defined experimental conditions for the selected project.');
ttstr4 = wrapHtmlTooltipString('<b>Export selected project</b> to a .mash file.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'bold',p.tbl);
wcb0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb1 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb2 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wbut5 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut6 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpan0 = 2*p.mg+wtxt0+wcb0+wcb1;
wpan1 = 2*p.mg+4*p.mg/fact+2*wedit0+wcb2+wbut5+wbut6;
hpan0 = p.mgpan+6*p.mg/fact+2*p.mg+hpop0+6*hedit0+2*htxt0;
hpan1 = p.mgpan+3*p.mg/fact+2*p.mg+2*hpop0+3*hedit0+2*htxt0;
hpan2 = p.mgpan+p.mg/2+2*p.mg/fact+4*htxt0+hsld0+hedit0;
hpan3 = p.mgpan+p.mg+2*p.mg/fact+2*htxt0+hpop0+2*hedit0;
hpan4 = p.mgpan+htxt0+hpop0+p.mg/2;
hpan5 = p.mgpan+p.mg/2+p.mg/fact+hpop0+hedit0;
hpan6 = p.mgpan+p.mg/2+p.mg/fact+2*hpop0+2*htxt0;
hpan7 = p.mgpan+htxt0+hpop0+p.mg/fact+htxt0+hedit0+p.mg;
hpan8 = p.mgpan+p.mg+p.mg/fact+2*hpop0+2*htxt0;
mgpan = (pospan(4)-p.mg-p.mg/2-hpan2-hpan3-hpan4-hpan5-hpan6-hpan7)/5;
waxes0 = wrelaxes*(pospan(3)-4*p.mg-p.mg/2-wpan0-wpan1);
waxes1 = (1-wrelaxes)*(pospan(3)-4*p.mg-p.mg/2-wpan0-wpan1);
haxes0 = pospan(4)-3*p.mg-hpan8;
mgproj0 = (wpan0-p.wbuth-4*wbut0)/4;
hlst0 = pospan(4)-3*p.mg-p.mg/2-2*p.mg/fact-hpan0-hpan1-2*hedit0;

% images
pname = [fileparts(fileparts(mfilename('fullpath'))),filesep];
img1 = imread([pname,file_icon1]);
img2 = imread([pname,file_icon2]);
img3 = imread([pname,file_icon3]);
img5 = imread([pname,file_icon5]);

% GUI
x = p.mg+wpan0+p.mg;
y = p.mg+hpan8+p.mg;

h.axes_bottom = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'activepositionproperty','outerposition','xlim',...
    limAx0,'ylim',limAx0);
h_axes = h.axes_bottom;
xlabel(h_axes,xlbl0);
ylabel(h_axes,ylbl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
posaxes(4) = (posaxes(4)-2*p.mg/fact)/3;
set(h_axes,'position',posaxes);
posaxes = get(h_axes,'position');

x = posaxes(1)+posaxes(3)+p.mg/fact;
y = posaxes(2);

h.axes_bottomRight = axes('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,waxes1,posaxes(4)],'xlim',...
    limAx1,'ylim',limAx0,'yticklabel',{});
xlabel(h.axes_bottomRight,xlbl1);

x = posaxes(1);
y = posaxes(2)+posaxes(4)+p.mg/fact;

h.axes_top = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,posaxes(3:4)],'xlim',limAx0,...
    'ylim',limAx0,'xticklabel',{});
ylabel(h.axes_top,ylbl1);

x = x+posaxes(3)+p.mg/fact;

h.axes_topRight = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes1,posaxes(4)],'xlim',limAx1,...
    'ylim',limAx0,'xticklabel',{},'yticklabel',{});

x = p.mg+p.wbuth+mgproj0;
y = pospan(4)-p.mg-hbut0;

h.pushbutton_addTraces = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hbut0],'string','','callback',...
    {@pushbutton_openProj_Callback,h_fig},'tooltipstring',ttstr1,...
    'foregroundcolor',p.fntclr2,'cdata',img1);

x = x+wbut0+mgproj0;

h.pushbutton_remTraces = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hbut0],'string','','tooltipstring',ttstr2,'callback',...
    {@pushbutton_closeProj_Callback,h_fig},'cdata',img2);

x = x+wbut0+mgproj0;

h.pushbutton_editParam = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hbut0],'string','','tooltipstring',ttstr3,'callback',...
    {@pushbutton_editParam_Callback,h_fig},'cdata',img5);

x = x+wbut0+mgproj0;

h.pushbutton_expProj = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hbut0],'string','','callback',...
    {@pushbutton_saveProj_Callback,h_fig},'tooltipstring',ttstr4,'cdata',...
    img3);

x = p.mg;
y = y-p.mg/fact-hlst0;

h.listbox_traceSet = uicontrol('style','listbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpan0,hlst0],'string',{''},'callback',...
    {@listbox_projList_Callback,h_fig});

x = p.mg;
y = y-p.mg-hpan0;

h.uipanel_TP_sampleManagement = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan0],'title',ttl0);
h = buildPanelTPsampleManagement(h,p);

y = p.mg;

h.uipanel_TP_plot = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan1],'title',ttl1);
h = buildPanelTPplot(h,p);

x = pospan(3)-p.mg-wpan1;
y = pospan(4)-p.mg/2-hpan2;

h.uipanel_TP_subImages = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan2],'title',ttl2);
h = buildPanelTPsubImages(h,p);

y = y-mgpan-hpan3;

h.uipanel_TP_backgroundCorrection = uipanel('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wpan1,hpan3],'title',ttl3);
h = buildPanelTPbackgroundCorrection(h,p);

y = y-mgpan-hpan4;

h.uipanel_TP_crossTalks = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan4],'title',ttl4);
h = buildPanelTPcrossTalks(h,p);

y = y-mgpan-hpan5;

h.uipanel_TP_denoising = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan5],'title',ttl6);
h = buildPanelTPdenoising(h,p);

y = y-mgpan-hpan6;

h.uipanel_TP_photobleaching = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan6],'title',ttl7);
h = buildPanelTPphotobleaching(h,p);

y = y-mgpan-hpan7;

h.uipanel_TP_factorCorrections = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan7],'title',ttl5);
h = buildPanelTPfactorCorrections(h,p);

x = posaxes(1);
w = pospan(3)-p.mg-wpan1-x-p.mg;

h.uipanel_TP_findStates = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,w,hpan8],'title',ttl8);
h = buildPanelTPfindStates(h,p);
pos = get(h.uipanel_TP_findStates,'position');
x = pospan(3)-p.mg-wpan1-p.mg-pos(3);
set(h.uipanel_TP_findStates,'position',[x,pos(2:4)]);

% place invivisible label list
posbut = get(h.togglebutton_TP_addTag,'position');
pospan = get(h.uipanel_TP_sampleManagement,'position');
x = pospan(1)+posbut(1)+posbut(3);
y = pospan(2)+posbut(2)+posbut(4)-hlst1;

h.listbox_TP_defaultTags = uicontrol('style','listbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wlst1,hlst1],'string',str6,'visible','off','callback',...
    {@listbox_TP_defaultTags_Callback,h_fig});


