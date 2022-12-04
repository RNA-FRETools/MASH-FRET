function h = buildVPtabPlotAvimg(h,p)
% h = buildVPtabPlotAvimg(h,p)
%
% Builds tab "Average image" in Video processing's visualization area.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_VP_plot_avimg: handle to tab "Average image"

% default
lim = [0,10000];
limMov = [0,9999];
ylbl0 = 'intensity(counts /pix)';

% parents
h_tab = h.uitab_VP_plot_avimg;

% dimensions
postab = get(h_tab,'position');
dimaxes = min([postab(4)-p.mgtab-p.mg,postab(3)-2*p.mg]);
haxes0 = dimaxes;
waxes0 = dimaxes;

% GUI
x = p.mg;
y = p.mg;

h.axes_VP_avimg = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'xlim',limMov,'ylim',limMov,'clim',lim,'nextplot',...
    'replacechildren','DataAspectRatioMode','manual','DataAspectRatio',...
    [1 1 1],'ydir','reverse');
h_axes = h.axes_VP_avimg;
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');

h.cb_VP_avimg = colorbar(h_axes,'units',p.posun);
ylabel(h.cb_VP_avimg,ylbl0);
poscb = get(h.cb_VP_avimg,'position');

posaxes(3) = posaxes(3)-2.6*poscb(3);
set(h_axes,'position',posaxes);
