function h = buildTAtabPlotBICGMM(h,p)
% h = buildTAtabPlotBICGMM(h,p)
%
% Builds tab "BIC (ML-GMM)" in Transition analysis' visualization tabbed panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_TA_plot_BICGMM: handle to tab "BIC (ML-GMM)"

% defaults
tick0 = 1:5;
ticklbl0 = num2cell(num2str((1:5)'))';
xlim0 = [0.5,10.5];
ylim0 = [-1000,1000];
ylbl0 = 'BIC';
xlbl0 = 'V';

% parents
h_tab = h.uitab_TA_plot_BICGMM;

% dimensions
postab = get(h_tab,'position');
waxes0 = postab(3)-2*p.mg;
haxes0 = postab(4)-p.mgtab-p.mg;

% GUI
x = p.mg;
y = p.mg;

h.axes_tdp_BIC = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'xlim',xlim0,'ylim',...
    ylim0,'nextplot','replacechildren','xtick',tick0,'xticklabel',...
    ticklbl0);
h_axes = h.axes_tdp_BIC;
ylabel(h_axes,ylbl0);
xlabel(h_axes,xlbl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);


