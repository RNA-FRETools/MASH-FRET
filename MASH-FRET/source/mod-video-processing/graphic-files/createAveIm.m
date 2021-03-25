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
isMov = 0;
isBgcorr = 0;

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% get processing parameters
startFrame = param.start; % start data
stopFrame = param.stop; % stop data
iv = param.iv; % interval averaged
fullname = param.file; % path + file
fDat = param.extra; % file data for accelerate reading
resX = fDat{2}(1);
resY = fDat{2}(2);
L = fDat{3};
L0 = numel(startFrame:iv:stopFrame);

% initialize output
img_ave = zeros(resY,resX);

if useMov && isfield(h,'movie') && isfield(h.movie,'movie') && ...
    ~isempty(h.movie.movie)
    isMov = 1;
end
if corr && isfield(p,'bgCorr') && ~isempty(p.bgCorr)
    isBgcorr = 1;
end

if ~(stopFrame<=L && startFrame>=1)
    if ~isempty(h_fig)
        updateActPan('Input parameters inconsitents.', h_fig, 'error');
    else
        disp('Input parameters inconsitents.');
    end
    return
end

% original average image
if isMov && ~isBgcorr
    img_ave = sum(h.movie.movie(:,:,startFrame:iv:stopFrame),3)/L;
    return
end

if ~isempty(h_fig)
    % loading bar parameters
    if loading_bar('init', h_fig, L0, 'Build average image...');
        return
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
end

for i = startFrame:iv:stopFrame
    if isMov
        imgNext = h.movie.movie(:,:,i);
    else
        [data,ok] = getFrames(fullname, i, param.extra, h_fig, false);
        if ~ok
            return
        end
        imgNext = data.frameCur;
    end

    if isBgcorr && ~isempty(h_fig)
        avBg = p.movBg_one;
        if ~avBg
            [imgNext,~] = updateBgCorr(imgNext, p, h.movie, h_fig);
        elseif avBg==n
            [imgNext,~] = updateBgCorr(imgNext, p, h.movie, h_fig);
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

