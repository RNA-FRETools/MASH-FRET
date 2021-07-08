function h = buildTAtabTrans(h,p)
% h = buildTAtabHistogram(h,p)
%
% Builds tab "Trans." in "Kinetic model" panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uitab_TA_trans: handle to tab "Histogram"

% defaults
tick0 = 1:5;
ticklbl0 = repmat({'0.00\newline0.99'},[1,5]);
xlim0 = [0.5,5.5];
ylim0 = [0,99999];
ylbl0 = 'nb. of transitions';
fntsz = 6;

% parents
h_fig = h.figure_MASH;
h_tab = h.uitab_TA_trans;

% dimensions
postab = get(h_tab,'position');
waxes0 = postab(3)-2*p.mg;
haxes0 = postab(4)-2*p.mg;

% GUI
x = p.mg;
y = p.mg;

h.axes_TA_mdlTrans = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',fntsz,'position',[x,y,waxes0,haxes0],'xlim',xlim0,'ylim',...
    ylim0,'nextplot','replacechildren','xtick',tick0,'xticklabel',ticklbl0);
h_axes = h.axes_TA_mdlTrans;
ylabel(h_axes,ylbl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);
