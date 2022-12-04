function h = buildVPtabgroupPlotTr(h,p,nMov,tabttl)
% h = buildVPtabgroupPlotTr(h,p,nMov,tabttl)
%
% Builds tab "Transformed image" in Video processing's visualization area.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uitabgroup_VP_plot_tr: handle to plot tab group "Transformed image"
% p: structure containing default and often-used GUI parameters
% nMov: number of videos
% tabttl: string or {1-by-nMov} cellstring channel names

% default
lim = [0,10000];
limMov = [0,9999];

% adjust input
if ~iscell(tabttl)
    tabttl = {tabttl};
end

% parents
h_fig = h.figure_MASH;
h_tg = h.uitabgroup_VP_plot_tr;

% dimensions
prevun = h_tg.Units;
setProp([h_fig,(h_fig.Children')],'units','pixels');

% delete existing controls
h = delControlIfHandle(h,{'axes_VP_tr','uitab_VP_plot_trChan'});
delete(h_tg.Children);

% GUI
x = p.mg;
y = p.mg;

for mov = 1:nMov
    h.uitab_VP_plot_trChan(mov) = uitab('parent',h_tg,'units',p.posun,...
        'title',tabttl{mov});
    h_tab = h.uitab_VP_plot_trChan(mov);
    
    postab = h_tab.Position;
    dimaxes = min([postab(4)-p.mgtab-p.mg,postab(3)-2*p.mg]);

    h.axes_VP_tr(mov) = axes('parent',h_tab,'units',p.posun,'fontunits',...
        p.fntun,'fontsize',p.fntsz1,'xlim',limMov,'ylim',limMov,'clim',lim,...
        'nextplot','replacechildren','DataAspectRatioMode','manual',...
        'DataAspectRatio',[1 1 1],'ydir','reverse');
    h_axes = h.axes_VP_tr(mov);
    tiaxes = get(h_axes,'tightinset');
    posaxes = getRealPosAxes([x,y,dimaxes,dimaxes],tiaxes,'traces');
    set(h_axes,'position',posaxes);
end

setProp([h_fig,(h_fig.Children)'],'units',prevun);
