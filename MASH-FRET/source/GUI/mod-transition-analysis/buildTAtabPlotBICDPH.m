function h = buildTAtabPlotBICDPH(h,p)
% h = buildTAtabPlotBICDPH(h,p)
%
% Builds tab "BIC (ML-DPH)" in Transition analysis' visualization tabbed panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_TA_plot_BICDPH: handle to tab "BIC (ML-DPH)"

% defaults
tick0 = 1:5;
ticklbl0 = repmat({'1234'},[1,5]);
lim0 = [0.5,5.5];
ylbl0 = 'BIC';
fntsz = 6;

% parents
h_tab = h.uitab_TA_plot_BICDPH;

% dimensions
postab = get(h_tab,'position');
waxes0 = postab(3)-2*p.mg;
haxes0 = postab(4)-p.mgtab-p.mg;

% GUI
x = p.mg;
y = p.mg;

h.axes_TA_mdlBIC = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',fntsz,'position',[x,y,waxes0,haxes0],'xlim',lim0,'nextplot',...
    'replacechildren','ytick',[],'xtick',tick0,'xticklabel',ticklbl0);
h_axes = h.axes_TA_mdlBIC;
ylabel(h_axes,ylbl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);


