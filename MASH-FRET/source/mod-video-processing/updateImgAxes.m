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
    if isfield(h,'axes_VP_vid') && any(ishandle(h.axes_VP_vid))
        for mov = 1:numel(h.axes_VP_vid)
            cla(h.axes_VP_vid(mov));
            cla(h.axes_VP_avimg(mov));
            cla(h.axes_VP_tr(mov));
        end
        set([h.axes_VP_vid,h.cb_VP_vid,h.axes_VP_avimg,h.cb_VP_avimg,...
            h.axes_VP_tr],'visible','off');
    end
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
n = p.movPr.curr_frame(proj);
nChan = p.proj{proj}.nb_channel;
expT = p.proj{proj}.sampling_time;
persec = p.proj{proj}.cnt_p_sec;
curr = p.proj{proj}.VP.curr;

% collect VP parameters
tocurr = curr.edit{1}{1}(2);
bgfilt = curr.edit{1}{4};
chsplit = curr.plot{2};
imgtrsf = curr.res_plot{3};

% check if any image filter is applied
isBgCorr = ~isempty(bgfilt);

% collect video-specific parameters
vidfiles = p.proj{proj}.movie_file;
viddat = p.proj{proj}.movie_dat;
multichanvid = numel(vidfiles)==1;

h.imageMov = [];
h.aveImage = [];

for mov = 1:numel(vidfiles)
    % get current video frame
    if isFullLengthVideo(vidfiles{mov},h_fig)
        img = double(h.movie.movie(:,:,n));
    else
        [dat,ok] = getFrames(vidfiles{mov},n,viddat{mov},h_fig,true);
        if ~ok
            return
        end
        img =  double(dat.frameCur);
    end
    curr.res_plot{1}{mov} = img;

    % filter image
    avimg = curr.res_plot{2}{mov};
    if isBgCorr
        if multichanvid
            avimg = updateBgCorr(avimg, p, h_fig);
        else
            avimg = updateBgCorr(avimg, p, h_fig, mov);
        end
        if ~tocurr
            if multichanvid
                img = updateBgCorr(img, p, h_fig);
            else
                img = updateBgCorr(img, p, h_fig, mov);
            end
        elseif tocurr==n
            if multichanvid
                img = updateBgCorr(img, p, h_fig);
            else
                img = updateBgCorr(img, p, h_fig, mov);
            end
        end
    end

    % convert to proper intensity units
    if persec
        img = img/expT;
        avimg = avimg/expT;
    end
    
    % get coordinates to plot
    if multichanvid
        chan = 0;
    else
        chan = mov;
    end
    coord = get_VP_coord2plot(curr,nChan,chan);

    % plot video frame
    h_axes = [h.axes_VP_vid(mov),h.axes_VP_avimg(mov)];
    if isfield(h,'axes_VP_tr') && all(ishandle(h.axes_VP_tr))
        h_axes = cat(2,h_axes,h.axes_VP_tr(mov));
    end
    [h.imageMov(mov),h.aveImage(mov)] = plot_VP_videoFrame(h_axes,...
        [h.cb_VP_vid(mov),h.cb_VP_avimg(mov)],cat(3,img,avimg),...
        imgtrsf{mov},coord,chsplit,persec,multichanvid);
    
    
    if h.togglebutton_target.Value==1
        set([h.axes_VP_vid(mov),h.axes_VP_avimg(mov)],'ButtonDownFcn',...
            {@pointITT, h_fig});
        set([h.imageMov(mov),h.aveImage(mov)],'ButtonDownFcn',...
            {@pointITT, h_fig});
    else
        set([h.imageMov(mov),h.aveImage(mov)],'ButtonDownFcn',{});
        set([h.axes_VP_vid(mov),h.axes_VP_avimg(mov)],'ButtonDownFcn',{});
    end
end

% sets zoom
if h.togglebutton_target.Value==1
    set(0, 'CurrentFigure', h_fig);
    zoom off
else
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
