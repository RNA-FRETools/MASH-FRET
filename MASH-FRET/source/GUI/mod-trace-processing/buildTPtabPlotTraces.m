function h = buildTPtabPlotTraces(h,p)
% h = buildTPtabPlotTraces(h,p)
%
% Builds tab "Traces" in Trace processing's visualization area.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_TP_plot_traces: handle to tab "Traces"

% defaults
wrelaxes = 0.78;
nrows = 4;
fact = 5;
limAx0 = [0 10000];
limAx1 = [0 0.001];
xlbl0 = 'time (s)';
xlbl1 = 'norm. freq.';
ylbl0 = 'FRET / S';
ylbl1 = 'counts per s. per pixel';

% parents
h_tab = h.uitab_TP_plot_traces;

% dimensions
postab = get(h_tab,'position');
waxes0 = wrelaxes*(postab(3)-2*p.mg-p.mg/fact);
waxes1 = (1-wrelaxes)*(postab(3)-2*p.mg-p.mg/fact);
haxes0 = postab(4)-2*p.mg;

% GUI
x = p.mg;
y = p.mg;
h.axes_top0 = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'activepositionproperty','outerposition','xlim',...
    limAx0,'ylim',limAx0);
h_axes = h.axes_top0;
xlabel(h_axes,xlbl0);
ylabel(h.axes_top0,ylbl1);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
posaxes(4) = (posaxes(4)-2*p.mg/fact)/nrows;
posaxes(2) = posaxes(2)+2*posaxes(4);
set(h_axes,'position',posaxes);
posaxes = get(h_axes,'position');

x = posaxes(1)+posaxes(3)+p.mg/fact;
y = posaxes(2);

h.axes_topRight0 = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes1,posaxes(4)],'xlim',...
    limAx1,'ylim',limAx0,'yticklabel',{});
xlabel(h.axes_topRight0,xlbl1);

x = posaxes(1);
y = y-posaxes(4)-p.mg/fact;

h.axes_top = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,posaxes(3:4)],'xlim',limAx0,...
    'ylim',limAx0);
ylabel(h.axes_top,ylbl1);

x = x+posaxes(3)+p.mg/fact;

h.axes_topRight = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes1,posaxes(4)],'xlim',limAx1,...
    'ylim',limAx0,'yticklabel',{});
xlabel(h.axes_topRight,xlbl1);

x = posaxes(1);
y = y-posaxes(4)-p.mg/fact;

h.axes_bottom = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,posaxes(3:4)],'xlim',limAx0,'ylim',...
    limAx0);

x = x+posaxes(3)+p.mg/fact;

h.axes_bottomRight = axes('parent',h_tab,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,waxes1,posaxes(4)],'xlim',...
    limAx1,'ylim',limAx0,'yticklabel',{});
xlabel(h.axes_bottomRight,xlbl1);

