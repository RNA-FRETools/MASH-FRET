function h = buildStabPlotVid(h,p)
% h = buildStabPlotVid(h,p)
%
% Builds tab "Video" in Simulation's visualization area.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_S_plot_vid: handle to tab "Video"

% defaults
limxy = [0 999];
limc = [0 10000];
ylbl = 'photon counts/time bin';

% parents
h_tab = h.uitab_S_plot_vid;

% dimensions
postab = get(h_tab,'position');
waxes = postab(3)-2*p.mg;
haxes = postab(4)-2*p.mg;

% GUI
x = p.mg;
y = p.mg;

h.axes_example_mov = axes('parent',h_tab,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'xlim',limxy,'ylim',limxy,'clim',limc,...
    'nextplot','replacechildren','DataAspectRatioMode','manual',...
    'DataAspectRatio',[1 1 1],'ydir','reverse');
h_axes = h.axes_example_mov;

% adjust axes dimensions
pos = getRealPosAxes([x,y,waxes,haxes],get(h_axes,'tightinset'),'traces');

% add color bar and shift axes x-position
h.cb_example_mov = colorbar(h_axes,'units',p.posun);
ylabel(h.cb_example_mov,ylbl);
pos_cb = get(h.cb_example_mov,'position');
pos(3) = pos(3) - 3*pos_cb(3);
set(h_axes,'position',pos);

