function h = buildPanelHA(h,p)
% h = buildPanelHA(h,p);
%
% Builds "Histogram analysis" module including panels "Histogram and plot", "State configuration" and "State populations".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_HA: handle to the panel containing the "Histogram analysis" module
%   h.pushbutton_traceImpOpt: handle to pushbutton "ASCII options..." in module "Trace processing"
%   h.pushbutton_addTraces: handle to pushbutton "Add" in module "Trace processing"
%   h.listbox_traceSet: handle to project list in module "Trace processing"
%   h.pushbutton_remTraces: handle to pushbutton "Remove" in module "Trace processing"
%   h.pushbutton_editParam: handle to pushbutton "Edit" in module "Trace processing"
%   h.pushbutton_expProj: handle to pushbutton "Save" in module "Trace processing"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.warr: width of downwards arrow in popupmenu
%   p.fntclr2: text color in special pushbuttons
%   p.wbuth: pixel width of help buttons
%   p.tbl: reference table listing character pixel dimensions
%   p.fname_boba: image file containing BOBA FRET icon

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% update by MH, 12.12.2019: plot boba icon in corresponding axes
% created by MH, 19.10.2019

% default
hpop0 = 22;
hedit0 = 20;
htxt0 = 14;
wedit0 = 40;
fact = 5;
waxes1 = 83;
str0 = 'Export...';
str1 = 'max. Gaussian nb.:';
str2 = 'Gaussian fitting';
str3 = 'relative pop.:';
ttl0 = 'Histogram and plot';
ttl1 = 'State configuration';
ttl2 = 'State populations';
xlim0 = [-1000,1000];
ylim0 = [0,0.01];
xlbl0 = 'data';
ylbl0 = 'normalized occurence';
ylbl1 = 'normalized cumulative occurence';
ttstr1 = wrapHtmlTooltipString('<b>Import traces</b> from a .mash file or from a set of ASCII files.');
ttstr2 = wrapHtmlTooltipString('<b>Close selected project</b> and remove it from the list.');
ttstr3 = wrapHtmlTooltipString('<b>Export results</b> to ASCII files: including histograms, state configurations and state populations.');
ttstr4 = wrapHtmlTooltipString('<b>Export selected project</b> to a .mash file.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_HA;

% dimensions
pospan = get(h_pan,'position');
posbut1 = get(h.pushbutton_addTraces,'position');
posbut2 = get(h.pushbutton_remTraces,'position');
posbut3 = get(h.pushbutton_expProj,'position');
cdat1 = get(h.pushbutton_addTraces,'cdata');
cdat2 = get(h.pushbutton_remTraces,'cdata');
cdat3 = get(h.pushbutton_expProj,'cdata');
poslst0 = get(h.listbox_traceSet,'position');
wtxt0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl);
wcb0 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wtxt1 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl);
wedit1 = wedit0/2;
wpan1 = wedit1+wtxt0+2*p.mg;
hpan1_1 = p.mgpan+p.mg+p.mg/2+4*p.mg/fact+6*hedit0;
hpan1_2 = 2*p.mgpan+2*p.mg+3*p.mg/2+2*p.mg/fact+5*hedit0+hpop0+htxt0;
hpan1 = p.mgpan+p.mg+p.mg/2+hpan1_1+hpan1_2;
wpan2_1 = wcb0+2*p.mg;
wpan2_2 = 2*p.mg+2*p.mg/fact+2*wedit0+wtxt1;
wpan2 = 3*p.mg+wpan2_1+wpan2_2;
wedit2 = wpan1+p.mg+wpan2;
hedit1 = pospan(4)-3*p.mg-hpan1;
waxes0 = pospan(3)-5*p.mg-poslst0(3)-wpan1-wpan2;
haxes0 = (pospan(4)-3*p.mg)/2;

% GUI
h.pushbutton_thm_addProj = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',posbut1,'string','','tooltipstring',ttstr1,...
    'callback',{@pushbutton_openProj_Callback,h_fig},'foregroundcolor',...
    p.fntclr2,'cdata',cdat1);

h.pushbutton_thm_rmProj = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    posbut2,'string','','tooltipstring',ttstr2,'callback',...
    {@pushbutton_closeProj_Callback,h_fig},'cdata',cdat2);

h.pushbutton_thm_saveProj = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',posbut3,'string','','tooltipstring',ttstr4,...
    'callback',{@pushbutton_saveProj_Callback,h_fig},'cdata',cdat3);

h.listbox_thm_projLst = uicontrol('style','listbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',poslst0,...
    'string',{''},'callback',{@listbox_projList_Callback,h_fig});

x = p.mg;
y = poslst0(2)-p.mg-hedit0;

h.pushbutton_thm_export = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,poslst0(3),hedit0],'string',str0,...
    'callback',{@pushbutton_thm_export_Callback,h_fig},'tooltipstring',...
    ttstr3);

h.uipanel_HA_histogramAndPlot = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','title',...
    ttl0);
h = buildPanelHAhistogramAndPlot(h,p);

x = p.mg+poslst0(3)+p.mg;
y = pospan(4)-p.mg-hpan1;

h.uipanel_HA_stateConfiguration = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan1],'title',ttl1);
h = buildPanelHAstateConfiguration(h,p);

y = p.mg;

h.edit_thmContPan = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'enable','inactive',...
    'position',[x,y,wedit2,hedit1],'max',2,'horizontalalignment','left');

x = x+wpan1+p.mg;
y = pospan(4)-p.mg-hpan1;

h.uipanel_HA_statePopulations = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan2,hpan1],'title',ttl2);
h = buildPanelHAstatePopulations(h,p);

x = x+wpan2+p.mg;
y = pospan(4)-p.mg-haxes0;

h.axes_hist1 = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0]);
h_axes = h.axes_hist1;
xlim(h_axes,xlim0);
ylim(h_axes,ylim0);
ylabel(h_axes,ylbl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

if ~isempty(p.fname_boba)
    x = posaxes(1)+posaxes(3)-waxes1;
    y = posaxes(2)+posaxes(4)-waxes1;

    h.axes_hist_BOBA = axes('parent',h_pan,'units',p.posun,'fontunits',...
        p.fntun,'fontsize',p.fntsz1,'position',[x,y,waxes1,waxes1]);
    
    ico_boba = imread(p.fname_boba);
    ico_boba = repmat(ico_boba, [1,1,3]);
    image(ico_boba,'parent',h.axes_hist_BOBA);
    axis(h.axes_hist_BOBA,'image');
    set(h.axes_hist_BOBA,'xtick',[],'ytick',[]);
end

x = pospan(3)-p.mg-waxes0;
y = p.mg;

h.axes_hist2 = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0]);
h_axes = h.axes_hist2;
xlim(h_axes,xlim0);
ylim(h_axes,ylim0);
xlabel(h_axes,xlbl0);
ylabel(h_axes,ylbl1);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

