function updateImgAxes(h_fig)
% updateImgAxes(h_fig)
%
% Update image data of the movie frame displayed on axes_movie: apply background correction if exist and show spots by circling them in red if the Spotfinder tool has been used.
%
% h_fig: handle to main figure

% Last update by MH, 12.12.2019: adapt colorbar visibility to wether or not a video/image is loaded.
% update by MH, 29.11.2019: (1) adapt axes visibility to wether or not a video/image is loaded, (2) remove systemic axes clearance to keep original properties (font size, color bar etc..), (3) remove useless zoom activation

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% add by MH, 29.11.2019
isLoad = isfield(h,'movie');
if ~isLoad
    set([h.axes_movie,h.colorbar],'visible','off');
    return
end

% collect video parameters
n = h.movie.frameCurNb;
expT = h.movie.cyctime;
videoFile = [h.movie.path h.movie.file];
fcurs = h.movie.speCursor;
resX = h.movie.pixelX;
resY = h.movie.pixelY;
L = h.movie.framesTot;
chsplit = h.movie.split;
isMov = isfield(h.movie,'movie') && ~isempty(h.movie.movie);

% collect processing parameters
isBgCorr = isfield(p,'bgCorr') && ~isempty(p.bgCorr);

% get current video frame
if isMov
    img = double(h.movie.movie(:,:,n));
else
    [dat,ok] = getFrames(videoFile, n, {fcurs,[resX,resY],L}, h_fig, true);
    if ~ok
        return
    end
    img =  double(dat.frameCur);
end
h.movie.frameCur =img;

% filter image
if isBgCorr
    avBg = p.movBg_one;
    if ~avBg
        [img,avImg] = updateBgCorr(img, p, h.movie, h_fig);
    elseif avBg==n
        [img,avImg] = updateBgCorr(img, p, h.movie, h_fig);
    end
    h.movie.avImg = avImg;
end

% find spots
SFall = p.SF_all;
frameSF = p.SFprm{1}(3);
if (~SFall && n==frameSF) || SFall
    if SFall
        p.SFprm{1}(3) = n;
    end
    p.SFres = {};
    p = updateSF(img, false, p, h_fig);
else
    p.SFres = {};
end

% convert to proper intensity units
if p.perSec
    img = img/expT;
end

% plot video frame
h.imageMov = plot_VP_videoFrame(h.axes_movie, h.colorbar, img, chsplit, p);

% set tool
if get(h.togglebutton_target, 'Value')
    set(0, 'CurrentFigure', h_fig);
    zoom off
    set(h.imageMov, 'ButtonDownFcn', {@pointITT, h_fig});
else
    set(h.axes_movie, 'ButtonDownFcn', {});
    set(0, 'CurrentFigure', h_fig);
    zoom on
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);
