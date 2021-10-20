function h = buildVPtabPlotTr(h,p)
% h = buildVPtabPlotTr(h,p)
%
% Builds tab "Transformed image" in Video processing's visualization area.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_VP_plot_tr: handle to tab "Transformed image"

% default
limMov = [0,9999];

% parents
h_tab = h.uitab_VP_plot_tr;

% dimensions
postab = get(h_tab,'position');
haxes0 = postab(4)-p.mgtab-p.mg;
waxes0 = haxes0;

% GUI
x = p.mg;
y = p.mg;

h.axes_VP_tr = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'xlim',limMov,'ylim',limMov,'nextplot',...
    'replacechildren','DataAspectRatioMode','manual','DataAspectRatio',...
    [1 1 1],'ydir','reverse');
h_axes = h.axes_VP_tr;
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);
