function h = buildStabPlotDistrib(h,p)
% h = buildStabPlotDistrib(h,p)
%
% Builds tab "Distributions" in Simulation's visualization area.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_S_plot_distrib: handle to tab "Distributions"

% defaults
lim = [0 10000];
xlbl = 'photon counts';
ylbl = 'frequency';

% parents
h_tab = h.uitab_S_plot_distrib;

% dimensions
postab = get(h_tab,'position');
waxes = postab(3)-2*p.mg;
haxes = postab(4)-2*p.mg;

% GUI
x = p.mg;
y = p.mg;

h.axes_example_hist = axes('Parent',h_tab,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'activepositionproperty','outerposition',...
    'xlim',lim,'ylim',lim,'nextplot','replacechildren');
h_axes = h.axes_example_hist;
xlabel(h_axes,xlbl);
ylabel(h_axes,ylbl);
pos = getRealPosAxes([x,y,waxes,haxes],get(h_axes,'tightinset'),'traces');
set(h_axes,'position',pos);