function h = buildVPtabgroupPlotAvimg(h,p,nMov,tabttl)
% h = buildVPtabgroupPlotAvimg(h,p,nMov,tabttl)
%
% Builds tab "Average image" in Video processing's visualization area.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uitabgroup_VP_plot_avimg: handle to plot tab group "Average image"
% p: structure containing default and often-used GUI parameters
% nMov: number of videos
% tabttl: string or {1-by-nMov} cellstring channel names

% default
lim = [0,10000];
limMov = [0,9999];
ylbl0 = 'intensity(counts /pix)';

% adjust input
if ~iscell(tabttl)
    tabttl = {tabttl};
end

% parents
h_fig = h.figure_MASH;
h_tg = h.uitabgroup_VP_plot_avimg;

% dimensions
prevun = h_tg.Units;
setProp([h_fig,(h_fig.Children')],'units','pixels');

% delete existing controls
h = delControlIfHandle(h,{'cb_VP_avimg','axes_VP_avimg',...
    'uitab_VP_plot_avimgChan'});
delete(h_tg.Children);

% GUI
x = p.mg;
y = p.mg;

for mov = 1:nMov
    h.uitab_VP_plot_avimgChan(mov) = uitab('parent',h_tg,'units',p.posun,...
        'title',tabttl{mov});
    h_tab = h.uitab_VP_plot_avimgChan(mov);
    
    postab = h_tab.Position;
    dimaxes = min([postab(4)-p.mgtab-p.mg,postab(3)-2*p.mg]);

    h.axes_VP_avimg(mov) = axes('parent',h_tab,'units',p.posun,'fontunits',...
        p.fntun,'fontsize',p.fntsz1,'xlim',limMov,'ylim',limMov,'clim',lim,...
        'nextplot','replacechildren','DataAspectRatioMode','manual',...
        'DataAspectRatio',[1 1 1],'ydir','reverse');
    h_axes = h.axes_VP_avimg(mov);
    tiaxes = get(h_axes,'tightinset');
    posaxes = getRealPosAxes([x,y,dimaxes,dimaxes],tiaxes,'traces');

    h.cb_VP_avimg(mov) = colorbar(h_axes,'units',p.posun);
    ylabel(h.cb_VP_avimg(mov),ylbl0);
    poscb = get(h.cb_VP_avimg(mov),'position');

    posaxes(3) = posaxes(3)-2.6*poscb(3);
    set(h_axes,'position',posaxes);
end

setProp([h_fig,(h_fig.Children)'],'units',prevun);
