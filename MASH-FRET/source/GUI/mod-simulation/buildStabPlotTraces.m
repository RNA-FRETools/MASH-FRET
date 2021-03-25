function h = buildStabPlotTraces(h,p)
% h = buildStabPlotTraces(h,p)
%
% Builds tab "Traces" in Simulation's visualization area.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_S_plot_traces: handle to tab "Traces"

% defaults
lim = [0 10000];
xlbl = 'time (sec)';
ylbl = 'photon counts';

% parents
h_tab = h.uitab_S_plot_traces;

% dimensions
postab = get(h_tab,'position');
waxes = postab(3)-2*p.mg;
haxes = postab(4)-2*p.mg;

% GUI
x = p.mg;
y = p.mg;

h.axes_example = axes('parent',h_tab,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'activepositionproperty','outerposition',...
    'xlim',lim,'ylim',lim,'nextplot','replacechildren');
h_axes = h.axes_example;
xlabel(h_axes,xlbl);
ylabel(h_axes,ylbl);
pos = getRealPosAxes([x,y,waxes,haxes],get(h_axes,'tightinset'),'traces');
set(h_axes,'position',pos);