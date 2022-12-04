function h = buildVPtabgroupPlotVid(h,p,nMov,tabttl)
% h = buildVPtabgroupPlotVid(h,p,nMov,tabttl)
%
% Builds plot tabgroup in "Video" tab of Video processing's visualization area.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uitabgroup_VP_plot_vid: handle to tab group "Video"
% p: structure containing default and often-used GUI parameters
% nMov: number of videos
% tabttl: string or {1-by-nMov} cellstring channel names

% defaults
hedit0 = 20;
htxt0 = 14;
lim = [0,99999];
limMov = [0,9999];
str0 = 'File:';
str7 = 'Size:';
str8 = 'x';
ylbl0 = 'intensity(counts /pix)';
ttstr2 = wrapHtmlTooltipString('Video/image file:</b> source file where video frames are taken from.');

% adjust input
if ~iscell(tabttl)
    tabttl = {tabttl};
end

% parents
h_fig = h.figure_MASH;
h_tg = h.uitabgroup_VP_plot_vid;

% dimensions
prevun = h_tg.Units;
setProp([h_fig,(h_fig.Children)'],'units','pixels');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt7 = getUItextWidth(str7,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt8 = getUItextWidth(num2str(limMov(2)),p.fntun,p.fntsz1,'normal',p.tbl);
wtxt9 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl);

% delete existing controls
h = delControlIfHandle(h,{'text_movH','text_VP_x','text_movW',...
    'text_VP_size','edit_movFile','text_VP_file','cb_VP_vid',...
    'axes_VP_vid','uitab_VP_plot_vidChan'});
delete(h_tg.Children);

% GUI
for mov = 1:nMov

    h.uitab_VP_plot_vidChan(mov) = uitab('parent',h_tg,'units',p.posun,...
        'title',tabttl{mov});
    h_tab = h.uitab_VP_plot_vidChan(mov);
    postab = h_tab.Position;
    
    haxes0 = min([postab(4)-p.mgtab-hedit0-p.mg,postab(3)-2*p.mg]);
    waxes0 = haxes0;
    wedit0 = postab(3)-2*p.mg-wtxt0-p.mg-wtxt7-2*wtxt8-wtxt9-p.mg;
    
    x = p.mg;
    y = postab(4)-p.mgtab-hedit0+(hedit0-htxt0)/2;

    h.text_VP_file(mov) = uicontrol('style','text','parent',h_tab,'units',...
        p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
        [x,y,wtxt0,htxt0],'string',str0,'horizontalalignment','left');

    x = x+wtxt0;
    y = y-(hedit0-htxt0)/2;

    h.edit_movFile(mov) = uicontrol('style','edit','parent',h_tab,'units',...
        p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
        [x,y,wedit0,hedit0],'tooltipstring',ttstr2,'foregroundcolor',...
        p.fntclr1);
    
    x = x+wedit0+p.mg;
    y = y+(hedit0-htxt0)/2;

    h.text_VP_size(mov) = uicontrol('style','text','parent',h_tab,'units',...
        p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
        [x,y,wtxt7,htxt0],'string',str7,'horizontalalignment','right');

    x = x+wtxt7;

    h.text_movW(mov) = uicontrol('style','text','parent',h_tab,'units',...
        p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
        [x,y,wtxt8,htxt0],'string','');

    x = x+wtxt8;

    h.text_VP_x(mov) = uicontrol('style','text','parent',h_tab,'units',...
        p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
        [x,y,wtxt9,htxt0],'string',str8);

    x = x+wtxt9;

    h.text_movH(mov) = uicontrol('style','text','parent',h_tab,'units',...
        p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
        [x,y,wtxt8,htxt0],'string','');
    
    x = p.mg;
    y = y-(hedit0-htxt0)/2-p.mg-haxes0;

    h.axes_VP_vid(mov) = axes('parent',h_tab,'units',p.posun,'fontunits',...
        p.fntun,'fontsize',p.fntsz1,'xlim',limMov,'ylim',limMov,'clim',...
        lim,'nextplot','replacechildren','DataAspectRatioMode','manual',...
        'DataAspectRatio',[1 1 1],'ydir','reverse');
    h_axes = h.axes_VP_vid(mov);
    tiaxes = get(h_axes,'tightinset');
    posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');

    h.cb_VP_vid(mov) = colorbar(h_axes,'units',p.posun);
    ylabel(h.cb_VP_vid(mov),ylbl0);
    poscb = get(h.cb_VP_vid(mov),'position');

    posaxes(3) = posaxes(3)-2.6*poscb(3);
    set(h_axes,'position',posaxes);
end

setProp([h_fig,(h_fig.Children)'],'units',prevun);
