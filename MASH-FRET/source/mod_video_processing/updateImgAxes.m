function updateImgAxes(h_fig)
% Update image data of the movie frame displayed on axes_movie: apply
% background correction if exist and show spots by circling them in red if
% the Spotfinder tool has been used.
%
% Requires external fucntions: getFrame, updateBgCorr, updateSF.

% Last update by MH, 12.12.2019:
% >> adapt colorbar visibility to wether or not a video/image is loaded.
%
% update by MH, 29.11.2019
% >> adapt axes visibility to wether or not a video/image is loaded.
% >> remove systemic axes clearance to keep original properties (font size,
%  color bar etc..) 
% >> remove useless zoom activation

h = guidata(h_fig);
p = h.param.movPr;

% add by MH, 29.11.2019
isLoad = isfield(h,'movie');
if ~isLoad
    set([h.axes_movie,h.colorbar],'visible','off');
    return;
else
    set([h.axes_movie,h.colorbar],'visible','on');
end

frameCurNb = h.movie.frameCurNb;
bgCorr = isfield(p,'bgCorr') && ~isempty(p.bgCorr);
SFapply = isfield(p,'SFres') && ~isempty(p.SFres);
SFall = p.SF_all;
trsfApply = isfield(p,'coordTrsf') && ~isempty(p.coordTrsf);
isMov = isfield(h.movie,'movie') && ~isempty(h.movie.movie);

if isMov
    frameCur = h.movie.movie(:,:,frameCurNb);
else
    [dat,ok] = getFrames([h.movie.path h.movie.file], frameCurNb, ...
        {h.movie.speCursor, [h.movie.pixelX h.movie.pixelY], ...
        h.movie.framesTot}, h_fig, true);
    if ~ok
        return;
    end
    frameCur = dat.frameCur;
end

% Apply background corrections if exist
if bgCorr
    avBg = p.movBg_one;
    if ~avBg
        img = updateBgCorr(frameCur, h_fig);
        frameCur = img;
    else % Apply only if the bg-corrected frame is displayed
        if avBg == frameCurNb
            img = updateBgCorr(frameCur, h_fig);
            frameCur = img;
        end
    end
end
nChan = p.nChan;
spots = [];

if SFapply
    frameSF = p.SFres{1,1}(3);
    if (~SFall && frameCurNb==frameSF) || SFall
        h.param.movPr = p;
        guidata(h_fig, h);
        updateSF(frameCur, false, h_fig);
        h = guidata(h_fig);
        p = h.param.movPr;
        for i = 1:nChan
            if ~isempty(p.SFres{2,i})
                spots = [spots;p.SFres{2,i}(:,1:2)];
            end
        end
    end
    
elseif trsfApply
    for i = 1:nChan
        if ~isempty(p.coordTrsf) && size(p.coordTrsf,2)>=2*i
            spots = [spots;p.coordTrsf(:,2*i-1:2*i)];
        end
    end
end

if p.perSec
    frameCur = frameCur/h.movie.cyctime;
end

h.movie.frameCur = frameCur;

% cancelled by MH, 29.11.2019
% cla(h.axes_movie);
% zoom(h_fig,'on');

h.imageMov = imagesc(h.axes_movie,[0.5 h.movie.pixelX-0.5],...
    [0.5 h.movie.pixelY-0.5],frameCur);
set(h.axes_movie,'nextplot','add');
if ~isempty(spots)
    plot(h.axes_movie,spots(:,1),spots(:,2),'or','markersize',10);
end
for i = 1:size(h.movie.split,2)
    plot(h.axes_movie, [h.movie.split(i) h.movie.split(i)], ...
        [0 h.movie.pixelY], '--w', 'LineWidth', 2);
end

% modified by MH, 29.11.2019
% set(h.axes_movie, 'NextPlot', 'replace');
set(h.axes_movie,'nextPlot','replacechildren','xlim',[0,h.movie.pixelX],...
    'ylim',[0,h.movie.pixelY],'clim',...
    [min(min(frameCur)),max(max(frameCur))]);

if get(h.togglebutton_target, 'Value')
    set(0, 'CurrentFigure', h_fig);
    zoom off;
    set(h.imageMov, 'ButtonDownFcn', {@pointITT, h_fig});
else
    set(h.axes_movie, 'ButtonDownFcn', {});
    set(0, 'CurrentFigure', h_fig);
    zoom on;
end

% cancelled by MH, 29.11.2019
% set(h.axes_movie, 'NextPlot', 'replacechildren', 'DataAspectRatio', ...
%     [1 1 1], 'DataAspectRatioMode', 'manual', 'PlotBoxAspectRatio', ...
%     [1 1 1], 'PlotBoxAspectRatioMode', 'auto');
% 
% if isfield(h, 'colorbar') && ishandle(h.colorbar)
%     colorbar(h.colorbar, 'delete');
% end
% 
% h.colorbar = colorbar('peer', h.axes_movie, 'EastOutside', 'Units', ...
%     'normalized');

if p.perSec
    ylabel(h.colorbar, 'intensity(counts /pix /s)');
else
    ylabel(h.colorbar, 'intensity(counts /pix)');
end
% pos = get(h.colorbar, 'Position');
% set(h.colorbar, 'Position', [pos(1:3) 11*pos(4)/12]);
drawnow;

h.param.movPr = p;
guidata(h_fig, h);
