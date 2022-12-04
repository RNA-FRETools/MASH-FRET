function h = buildTAtabPlotMdl(h,p)
% h = buildTAtabPlotMdl(h,p)
%
% Builds tab "Diagram" in Transition analysis' visualization tabbed panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_TA_plot_mdl: handle to tab "Diagram"

% defaults

% parents
h_tab = h.uitab_TA_plot_mdl;

% dimensions
postab = get(h_tab,'position');
waxes0 = postab(3)-2*p.mg;
haxes0 = postab(4)-2*p.mg;

% GUI
x = p.mg;
y = p.mg;

h.axes_TDPplot3 = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'box','on','xtick',...
    [],'ytick',[],'color','none');



