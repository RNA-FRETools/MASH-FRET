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
%   p.wttsr: pixel width of tooltip box
%   p.fntclr2: text color in special pushbuttons
%   p.wbuth: pixel width of help buttons
%   p.tbl: reference table listing character's pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% Last update: by MH, 10.1.2020
% >> add panel "Cross-talks" and remove cross-talks parameters from panel
% "Factor corrections"
%
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 13;
hsld0 = 13;
hpop0 = 22;
wedit0 = 40;
wlst1 = 90; % default label list width (invisible)
hlst1 = 80; % default label list height (invisible)
fact = 5;
wrelaxes = 0.78;
limAx0 = [0 10000];
limAx1 = [0 0.001];
xlbl0 = 'time (s)';
xlbl1 = 'norm. freq.';
ylbl0 = 'FRET / S';
ylbl1 = 'counts per s. per pixel';
str0 = 'ASCII options...';
str1 = 'Add';
str2 = 'Remove';
str3 = 'Edit...';
str4 = 'Save';
str5 = 'int. units /';
str6 = 's';
str7 = 'pixel';
str8 = 'auto.';
str9 = 'Show';
str10 = 'Opt.';
str11 = {'default labels'};
ttl0 = 'Sample management';
ttl1 = 'Plot';
ttl2 = 'Sub-images';
ttl3 = 'Background correction';
ttl4 = 'Cross-talks';
ttl5 = 'Factor corrections';
ttl6 = 'Denoising';
ttl7 = 'Photobleaching';
ttl8 = 'Find states';
ttstr0 = wrapStrToWidth('Open <b>import options</b> to configure how intensity-time traces are imported from ASCII files.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Import traces</b> from a .mash file or from a set of ASCII files.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Close selected project</b> and remove it from the list.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('Open <b>project options:</b> includes informations about emitters, FRET pairs and user-defined experimental conditions for the selected project.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Export selected project</b> to a .mash file.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP;

% dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut1 = getUItextWidth(str1,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wbut2 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut3 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut4 = getUItextWidth(str4,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wtxt0 = getUItextWidth(str5,p.fntun,p.fntsz1,'bold',p.tbl);
wcb0 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb1 = getUItextWidth(str7,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb2 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wbut5 = getUItextWidth(str9,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut6 = getUItextWidth(str10,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpan0 = 2*p.mg+wtxt0+wcb0+wcb1;
wpan1 = 2*p.mg+4*p.mg/fact+2*wedit0+wcb2+wbut5+wbut6;
hpan0 = p.mgpan+6*p.mg/fact+2*p.mg+hpop0+6*hedit0+2*htxt0;
hpan1 = p.mgpan+3*p.mg/fact+2*p.mg+2*hpop0+3*hedit0+2*htxt0;
hpan2 = p.mgpan+p.mg/2+2*p.mg/fact+4*htxt0+hsld0+hedit0;
hpan3 = p.mgpan+p.mg+2*p.mg/fact+2*htxt0+hpop0+2*hedit0;
hpan4 = p.mgpan+htxt0+hpop0+p.mg/2;
hpan5 = p.mgpan+p.mg/2+p.mg/fact+hpop0+hedit0;
hpan6 = p.mgpan+p.mg/2+p.mg/fact+2*hpop0+2*htxt0;
hpan7 = p.mgpan+hpop0+p.mg/fact+htxt0+hpop0+p.mg;
hpan8 = p.mgpan+p.mg+p.mg/fact+2*hpop0+2*htxt0;
mgpan = (pospan(4)-2*p.mg-hpan2-hpan3-hpan4-hpan5-hpan6-hpan7)/5;
waxes0 = wrelaxes*(pospan(3)-4*p.mg-p.mg/2-wpan0-wpan1);
waxes1 = (1-wrelaxes)*(pospan(3)-4*p.mg-p.mg/2-wpan0-wpan1);
haxes0 = pospan(4)-3*p.mg-hpan8;
mgproj0 = (wpan0-p.wbuth-wbut0-wbut1)/2;
mgproj1 = (wpan0-wbut2-wbut3-wbut4)/2;
hlst0 = pospan(4)-3*p.mg-p.mg/2-2*p.mg/fact-hpan0-hpan1-2*hedit0;

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
y = pospan(4)-p.mg-hedit0;

h.pushbutton_traceImpOpt = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str0,'callback',{@openTrImpOpt,h_fig},...
    'tooltipstring',ttstr0);

x = x+wbut0+mgproj0;

h.pushbutton_addTraces = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut1,hedit0],'string',str1,'callback',...
    {@pushbutton_addTraces_Callback,h_fig},'tooltipstring',ttstr1,...
    'foregroundcolor',p.fntclr2);

x = p.mg;
y = y-p.mg/fact-hlst0;

h.listbox_traceSet = uicontrol('style','listbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpan0,hlst0],'string',{''},'callback',...
    {@listbox_traceSet_Callback,h_fig});

y = y-p.mg/fact-hedit0;

h.pushbutton_remTraces = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut2,hedit0],'string',str2,'tooltipstring',ttstr2,'callback',...
    {@pushbutton_remTraces_Callback,h_fig});

x = x+wbut2+mgproj1;

h.pushbutton_editParam = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut3,hedit0],'string',str3,'tooltipstring',ttstr3,'callback',...
    {@pushbutton_editParam_Callback,h_fig});

x = x+wbut3+mgproj1;

h.pushbutton_expProj = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut4,hedit0],'string',str4,'callback',...
    {@pushbutton_expProj_Callback,h_fig},'tooltipstring',ttstr4);

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
y = pospan(4)-p.mg-hpan2;

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
posbut = get(h.pushbutton_TP_addTag,'position');
pospan = get(h.uipanel_TP_sampleManagement,'position');
x = pospan(1)+posbut(1)+posbut(3);
y = pospan(2)+posbut(2)+posbut(4)-hlst1;

h.lisbox_TP_defaultTags = uicontrol('style','listbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wlst1,hlst1],'string',str11,'visible','off','callback',...
    {@lisbox_TP_defaultTags_Callback,h_fig});


