function h = buildHAtabPlotHist(h,p)
% h = buildHAtabPlotHist(h,p)
%
% Builds tab "Histograms" in Histogram analysis' visualization tabbed panel.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.uitab_HA_plot_hist: handle to tab "Histograms"

% defaults
waxes1 = 83;
xlim0 = [-1000,1000];
ylim0 = [0,0.01];
xlbl0 = 'data';
ylbl0 = 'normalized occurence';
ylbl1 = 'normalized cumulative occurence';

% parents
h_tab = h.uitab_HA_plot_hist;

% dimensions
postab = get(h_tab,'position');
waxes0 = postab(3)-2*p.mg;
haxes0 = (postab(4)-p.mgtab-2*p.mg)/2;

% GUI
x = p.mg;
y = postab(4)-p.mgtab-haxes0;

h.axes_hist1 = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0]);
h_axes = h.axes_hist1;
xlim(h_axes,xlim0);
ylim(h_axes,ylim0);
ylabel(h_axes,ylbl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

if ~isempty(p.fname_boba)
    x = posaxes(1)+posaxes(3)-waxes1;
    y = posaxes(2)+posaxes(4)-waxes1;

    h.axes_hist_BOBA = axes('parent',h_tab,'units',p.posun,'fontunits',...
        p.fntun,'fontsize',p.fntsz1,'position',[x,y,waxes1,waxes1]);
    
    ico_boba = imread(p.fname_boba);
    ico_boba = repmat(ico_boba, [1,1,3]);
    image(ico_boba,'parent',h.axes_hist_BOBA);
    axis(h.axes_hist_BOBA,'image');
    set(h.axes_hist_BOBA,'xtick',[],'ytick',[]);
end

x = p.mg;
y = postab(4)-p.mgtab-2*haxes0-p.mg;

h.axes_hist2 = axes('parent',h_tab,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0]);
h_axes = h.axes_hist2;
xlim(h_axes,xlim0);
ylim(h_axes,ylim0);
xlabel(h_axes,xlbl0);
ylabel(h_axes,ylbl1);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

