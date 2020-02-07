function [img_ave,ok] = createAveIm(param,corr,useMov,h_fig)
% Create the average image for all frames obtained at donor excitation
% (first cell) and for all frames obtained at acceptor excitation (second
% cell)
%
% useMov allows the use of the video stored in VP, for VP, in h.movie.movie

% Last update: MH, 29.5.2019
% >> correct calculation of intervalled average image when full-length
%    movie is loaded in memory

h = guidata(h_fig);

startFrame = param.start; % start data
stopFrame = param.stop; % stop data
iv = param.iv; % interval averaged
fullname = param.file; % path + file
fDat = param.extra; % file data for accelerate reading
resX = fDat{2}(1);
resY = fDat{2}(2);
frameLength = fDat{3};
ok = 1;
isMov = 0;
if useMov && isfield(h,'movie') && isfield(h.movie,'movie') && ...
    ~isempty(h.movie.movie)
    isMov = 1;
end
isBgcorr = 0;
if corr && isfield(h.param.movPr,'bgCorr') && ...
    ~isempty(h.param.movPr.bgCorr)
    isBgcorr = 1;
end

if (stopFrame<=frameLength && startFrame>=1)
    img_ave = zeros(resY,resX);
    realLength = numel(startFrame:iv:stopFrame);
    
    % original average image
    if isMov && ~isBgcorr
        img_ave = sum(h.movie.movie(:,:,startFrame:iv:stopFrame),3)/...
            frameLength;
        return
    end
    
    if ~isempty(h_fig)
        % loading bar parameters-------------------------------------------
        intrupt = loading_bar('init', h_fig, realLength, ...
            'Build average image...');
        if intrupt
            return;
        end
        h = guidata(h_fig);
        h.barData.prev_var = h.barData.curr_var;
        guidata(h_fig, h);
        % -----------------------------------------------------------------
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
            avBg = h.param.movPr.movBg_one;
            if ~avBg
                imgNext = updateBgCorr(imgNext, h_fig);
            else % Apply only if the bg-corrected frame is displayed
                if avBg == i
                    imgNext = updateBgCorr(imgNext, h_fig);
                end
            end
        end

        img_ave = img_ave + single(imgNext)/realLength;

        if ~isempty(h_fig)
            % loading bar update-------------------------------------------
            intrupt = loading_bar('update', h_fig);
            if intrupt
                ok = 0;
                return
            end
            % -------------------------------------------------------------
        end
    end

    if ~isempty(h_fig)
        loading_bar('close', h_fig);
    end

else
    if ~isempty(h_fig)
        updateActPan('Input parameters inconsitents.', h_fig, 'error');
    else
        disp('Input parameters inconsitents.');
    end
end

