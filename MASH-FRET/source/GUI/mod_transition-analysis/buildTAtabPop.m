function h = buildTAtabPop(h,p)
% h = buildTAtabTdp(h,p)
%
% Builds tab "Pop." in "Kinetic model" panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_TA_pop: handle to tab "TDP"

% defaults
tick0 = 1:5;
ticklbl0 = repmat({'0.00'},[1,5]);
xlim0 = [0.5,5.5];
ylim0 = [0,99999];
ylbl0 = 'population';
fntsz = 6;

% parents
h_tab = h.uitab_TA_pop;

% dimensions
postab = get(h_tab,'position');
waxes0 = postab(3)-2*p.mg;
haxes0 = postab(4)-2*p.mg;

% GUI
x = p.mg;
y = postab(4)-p.mg-haxes0;

h.axes_TA_mdlPop = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',fntsz,'position',[x,y,waxes0,haxes0],'xlim',xlim0,'ylim',...
    ylim0,'nextplot','replacechildren','xtick',tick0,'xticklabel',ticklbl0);
h_axes = h.axes_TA_mdlPop;
ylabel(h_axes,ylbl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

