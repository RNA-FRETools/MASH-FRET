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

if ~isModuleOn(p,'VP')
    cla(h.axes_VP_vid);
    cla(h.axes_VP_avimg);
    if isfield(h,'axes_VP_tr') && ishandle(h.axes_VP_tr)
        cla(h.axes_VP_tr);
        set(h.axes_VP_tr,'visible','off');
    end
    set([h.axes_VP_vid,h.cb_VP_vid,h.axes_VP_avimg,h.cb_VP_avimg],...
        'visible','off');
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
n = p.movPr.curr_frame(proj);
expT = p.proj{proj}.frame_rate;
videoFile = p.proj{proj}.movie_file;
fcurs = p.proj{proj}.movie_dat{1};
resX = p.proj{proj}.movie_dat{2}(1);
resY = p.proj{proj}.movie_dat{2}(2);
L = p.proj{proj}.movie_dat{3};
persec = p.proj{proj}.cnt_p_sec;
curr = p.proj{proj}.VP.curr;

% collect CP parameters
chsplit = curr.plot{2};
tocurr = curr.edit{1}{1}(2);
bgfilt = curr.edit{1}{4};
avimg = curr.res_plot{2};

% check if any image filter is applied
isBgCorr = ~isempty(bgfilt);

% get current video frame
if isFullLengthVideo(videoFile,h_fig)
    img = double(h.movie.movie(:,:,n));
else
    [dat,ok] = getFrames(videoFile,n,{fcurs,[resX,resY],L},h_fig,true);
    if ~ok
        return
    end
    img =  double(dat.frameCur);
end
curr.res_plot{1} = img;

% filter image
if isBgCorr
     avimg = updateBgCorr(avimg, p, h_fig);
    if ~tocurr
        img = updateBgCorr(img, p, h_fig);
    elseif tocurr==n
        img = updateBgCorr(img, p, h_fig);
    end
end

% convert to proper intensity units
if persec
    img = img/expT;
    avimg = avimg/expT;
end

% plot video frame
h_axes = [h.axes_VP_vid,h.axes_VP_avimg];
if isfield(h,'axes_VP_tr') && ishandle(h.axes_VP_tr)
    h_axes = cat(2,h_axes,h.axes_VP_tr);
end
h.imageMov = plot_VP_videoFrame(h_axes,[h.cb_VP_vid,h.cb_VP_avimg],...
    cat(3,img,avimg),chsplit,curr,persec);

% set tool
if get(h.togglebutton_target, 'Value')
    set(0, 'CurrentFigure', h_fig);
    zoom off
    set(h.imageMov, 'ButtonDownFcn', {@pointITT, h_fig});
else
    set(h.axes_VP_vid, 'ButtonDownFcn', {});
    set(0, 'CurrentFigure', h_fig);
    zoom on
end

% apply current parameter set to project
p.proj{proj}.VP.prm.res_plot = curr.res_plot;
p.proj{proj}.VP.prm.plot = curr.plot;
p.proj{proj}.VP.prm.edit{1} = curr.edit{1};

% save modifications
p.proj{proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);
