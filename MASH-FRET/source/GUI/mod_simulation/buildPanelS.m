function h = buildPanelS(h,p)
% h = buildPanelS(h,p);
%
% Builds module "Simulation" including panels "Video parameters", "Molecules", "Experimental setup" and "Export options".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_S: handle to the panel containing "Simulation" module
%
% p: structure containing default and often-used parameters that must 
% contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.fntclr1: text color in file/folder fields

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hpan = 231;
wpan0 = 176;
wpan1 = 506;
wpan2 = 175;
wpan3 = 158;
hedit0 = 61;
ttl0 = 'Video parameters';
ttl1 = 'Molecules';
ttl2 = 'Experimental setup';
ttl3 = 'Export options';
limMov = [0 999];
lim = [0 10000];
ylbl0 = 'photon counts/time bin';
xlbl0 = 'photon counts';
ylbl1 = 'frequency';
xlbl1 = 'time (sec)';

% parents
h_pan = h.uipanel_S;

% dimensions
pospan = get(h_pan,'position');
waxes0 = pospan(4)-3*p.mg-hpan;
haxes0 = waxes0;
haxes1 = pospan(4)-4*p.mg-hpan-hedit0;

fact = 10;

x = 2*p.mg/fact;
y = pospan(4)-p.mg-hpan;

h.uipanel_S_videoParameters = uipanel('parent',h_pan,'title',ttl0,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wpan0,hpan]);
h = buildPanelSimVideoParametes(h,p);

x = x+wpan0+p.mg/fact;

h.uipanel_S_molecules = uipanel('parent',h_pan,'title',ttl1,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wpan1,hpan]);
h = buildPanelSimMolecules(h,p);

x = x+wpan1+p.mg/fact;

h.uipanel_S_experimentalSetup = uipanel('parent',h_pan,'title',ttl2,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wpan2,hpan]);
h = buildPanelSimExperimentalSetup(h,p);

x = x+wpan2+p.mg/fact;

h.uipanel_S_exportOptions = uipanel('parent',h_pan,'title',ttl3,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wpan3,hpan]);
h = buildPanelSimExportOptions(h,p);

x = pospan(3)-p.mg-waxes0;
y = p.mg;

h.axes_example_mov = axes('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'xlim',limMov,'ylim',limMov,'clim',lim,...
    'nextplot','replacechildren','DataAspectRatioMode','manual',...
    'DataAspectRatio',[1 1 1],'ydir','reverse');
h_axes = h.axes_example_mov;

% adjust axes dimensions
pos = getRealPosAxes([x,y,waxes0,haxes0],get(h_axes,'tightinset'),'traces');

% add color bar and shift axes x-position
h.cb_example_mov = colorbar(h_axes,'units',p.posun);
ylabel(h.cb_example_mov,ylbl0);
pos_cb = get(h.cb_example_mov,'position');
pos(1) = pos(1) - 3*pos_cb(3);
set(h_axes,'position',pos);

x = p.mg;
y = pospan(4)-2*p.mg-hpan-hedit0;

posax = get(h_axes,'position');
tisax = get(h_axes,'tightinset');
wedit0 = posax(1) - tisax(1) - 2*p.mg;

h.edit_simContPan = uicontrol('parent',h_pan,'style','edit','units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'enable','inactive',...
    'position',[x,y,wedit0,hedit0],'max',2,'horizontalalignment','left');

y = p.mg;

waxes1 = (wedit0-p.mg)/3;
h.axes_example_hist = axes('Parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'activepositionproperty','outerposition',...
    'xlim',lim,'ylim',lim,'nextplot','replacechildren');
h_axes = h.axes_example_hist;
xlabel(h_axes,xlbl0);
ylabel(h_axes,ylbl1);
pos = getRealPosAxes([x,y,waxes1,haxes1],get(h_axes,'tightinset'),'traces');
set(h_axes,'position',pos);

x = x + waxes1 + p.mg;

waxes2 = 2*(wedit0-p.mg)/3;
h.axes_example = axes('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'activepositionproperty','outerposition',...
    'xlim',lim,'ylim',lim,'nextplot','replacechildren');
h_axes = h.axes_example;
xlabel(h_axes,xlbl1);
ylabel(h_axes,xlbl0);
pos = getRealPosAxes([x,y,waxes2,haxes1],get(h_axes,'tightinset'),'traces');
set(h_axes,'position',pos);

