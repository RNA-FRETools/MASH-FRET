function [img_ave,ok] = createAveIm(param,corr,useMov,h_fig)
% [img_ave,ok] = createAveIm(param,corr,useMov,h_fig)
%
% Create the average image
%
% param: structure that must contain fields:
%  param.start: index of first frame of the range to average
%  param.stop: index of last frame of the range to average
%  param.iv: frame interval in range to average
%  param.file: source video file
%  param.extra: metadata used to read file
% corr: apply image filter
% useMov: (1) to use the video stored in VP in h.movie.movie (for VP only), 0 otherwise
% h_fig: handle to main figure
% img_ave: average image
% ok: (1) execution success, (0) otherwise

% Last update: MH, 29.5.2019
% >> correct calculation of intervalled average image when full-length
%    movie is loaded in memory

% defaults
ok = 1;
isBgcorr = 0;

% collect parameters
h = guidata(h_fig);
p = h.param;
n = p.movPr.curr_frame(p.curr_proj);
curr = p.proj{p.curr_proj}.VP.curr;
tocurr = curr.edit{1}{1}(2);
filtlst = curr.edit{1}{4};

% get calculation parameters
start = param.start; % start data
stop = param.stop; % stop data
iv = param.iv; % interval averaged
fullname = param.file; % path + file
fDat = param.extra; % file data for accelerate reading
resX = fDat{2}(1);
resY = fDat{2}(2);
L = fDat{3};
L0 = numel(start:iv:stop);

% initialize output
img_ave = zeros(resY,resX);

% load full-length video data in memory if possible
if useMov && ~isFullLengthVideo(fullname,h_fig)
    h.movie.movie = [];
    h.movie.file = '';
    guidata(h_fig,h);
    [dat,ok] = getFrames(fullname,'all',fDat,h_fig,true);
    if ~ok
        return
    end
    h = guidata(h_fig);
    if ~isempty(dat.movie)
        h.movie.movie = dat.movie;
        h.movie.file = fullname;
        guidata(h_fig,h);
        
    elseif ~isempty(h.movie.movie)
        h.movie.file = fullname;
        guidata(h_fig,h);
    end
end

% control full-length video
isMov = useMov & isFullLengthVideo(fullname,h_fig);

% control filter correction
if corr && ~isempty(filtlst)
    isBgcorr = 1;
end

% control frame range bounds
if ~(stop<=L && start>=1)
    if ~isempty(h_fig)
        updateActPan('Frame interval is out-of-range.', h_fig, 'error');
    else
        disp('Frame interval is out-of-range.');
    end
    return
end

% original average image
if isMov && ~isBgcorr
    img_ave = zeros(resY,resX);
    for l = start:iv:stop
        img_ave = img_ave+double(h.movie.movie(:,:,l))/L0;
    end
    return
end

if ~isempty(h_fig)
    % loading bar parameters
    if loading_bar('init', h_fig, L0, 'Build average image...')
        return
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
end

for i = start:iv:stop
    if isMov
        imgNext = h.movie.movie(:,:,i);
    else
        [data,ok] = getFrames(fullname, i, fDat, h_fig, false);
        if ~ok
            return
        end
        fDat = {data.fCurs,fDat{2},fDat{3}};
        imgNext = data.frameCur;
    end

    if isBgcorr && ~isempty(h_fig)
        if ~tocurr
            imgNext = updateBgCorr(imgNext, p, h_fig);
        elseif tocurr==n
            imgNext = updateBgCorr(imgNext, p, h_fig);
        end
    end

    img_ave = img_ave + single(imgNext)/L0;

    if ~isempty(h_fig) && loading_bar('update', h_fig)
        ok = 0;
        return
    end
end
if ~isempty(h_fig)
    loading_bar('close', h_fig);
end
