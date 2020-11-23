function h = buildTAtabBIC(h,p)
% h = buildTAtabBIC(h,p)
%
% Builds tab "BIC" in "Kinetic model" panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_TA_mdlBIC: handle to tab "TDP"

% defaults

% parents
h_tab = h.uitab_TA_mdlBIC;

% dimensions
postab = get(h_tab,'position');
waxes0 = postab(3)-2*p.mg;
haxes0 = postab(4)-2*p.mg;

% GUI
x = p.mg;
y = postab(4)-p.mg-haxes0;

h.axes_TA_mdlBIC = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'nextplot',...
    'replacechildren','box','on','xtick',[],'ytick',[]);

