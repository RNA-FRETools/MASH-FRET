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
p = h.param;

if ~prepPanel(h.uitabgroup_VP_plot,h)
    set([h.axes_movie,h.colorbar],'visible','off');
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
n = p.VP.curr_frame(proj);
expT = 1/p.proj{proj}.frame_rate;
videoFile = p.proj{proj}.movie_file;
fcurs = p.proj{proj}.movie_dat{1};
resX = p.proj{proj}.movie_dat{2}(1);
resY = p.proj{proj}.movie_dat{2}(2);
L = p.proj{proj}.movie_dat{3};
prm = p.proj{proj}.VP;
chsplit = prm.split;

% check if full-length video is loaded in memory
isFullMov = isfield(h.movie,'movie') && ~isempty(h.movie.movie);

% check if any image filter is applied
isBgCorr = isfield(prm,'bgCorr') && ~isempty(prm.bgCorr);

% get current video frame
if isFullMov
    img = double(h.movie.movie(:,:,n));
else
    [dat,ok] = getFrames(videoFile, n, {fcurs,[resX,resY],L}, h_fig, true);
    if ~ok
        return
    end
    img =  double(dat.frameCur);
end
prm.curr_img =img;

% filter image
if isBgCorr
    avBg = prm.movBg_one;
    if ~avBg
        [img,avImg] = updateBgCorr(img, p, h_fig);
    elseif avBg==n
        [img,avImg] = updateBgCorr(img, p, h_fig);
    end
    if exist('avImg','var')
        prm.proj{proj}.aveImg{1} = avImg;
    end
end

% find spots
SFall = prm.SF_all;
frameSF = prm.SFprm{1}(3);
if (~SFall && n==frameSF) || SFall
    if SFall && prm.SFprm{1}(3)~=n
        prm.SFprm{1}(3) = n;
        prm.SFres = {};
    end
    prm = updateSF(img, false, prm, h_fig);
else
    prm.SFres = {};
end

% convert to proper intensity units
if prm.perSec
    img = img/expT;
end

% plot video frame
h.imageMov = plot_VP_videoFrame(h.axes_movie,h.colorbar,img,chsplit,prm);

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
prm.proj{proj}.VP = prm;
h.param = p;
guidata(h_fig, h);
