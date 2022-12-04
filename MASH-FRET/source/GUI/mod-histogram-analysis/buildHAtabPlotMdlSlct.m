function h = buildHAtabPlotMdlSlct(h,p)
% h = buildHAtabPlotMdlSlct(h,p)
%
% Builds tab "Model selection" in Histogram analysis' visualization tabbed panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_HA_plot_mdlSlct: handle to tab "Histograms"

% defaults
xlim0 = [0,10];
ylim0 = [-1000,1000];
xlbl0 = 'Model complexity';
ylbl0 = 'BIC';

% parents
h_tab = h.uitab_HA_plot_mdlSlct;

% dimensions
postab = get(h_tab,'position');
waxes0 = postab(3)-2*p.mg;
haxes0 = postab(4)-p.mgtab-p.mg;

% GUI
x = p.mg;
y = postab(4)-p.mgtab-haxes0;

h.axes_thm_BIC = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0]);
h_axes = h.axes_thm_BIC;
xlim(h_axes,xlim0);
ylim(h_axes,ylim0);
ylabel(h_axes,ylbl0);
xlabel(h_axes,xlbl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes,'nextplot','replacechildren');

