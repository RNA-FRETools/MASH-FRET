function ok = export2Gif(h_fig, nameMain, pathName)
% Export the movie / image with background corrections to a .gif file
% Pixel values are normalized frame-wise before being written to file
%
% Requires functions: loading_bar, updateActPan, updateBgCorr.

% defaults
ok = 1;
iv = 1;
isMov = 0;
isBgCorr = 0;
maxInt = -Inf;
minInt = Inf;

h = guidata(h_fig);

if isfield(h,'movie') && isfield(h.movie,'movie') && ...
    ~isempty(h.movie.movie)
    isMov = 1;
end
if isfield(h.param.movPr, 'bgCorr') && ~isempty(h.param.movPr.bgCorr)
    isBgCorr = 1;
end

startFrame = h.param.movPr.mov_start;
lastFrame = h.param.movPr.mov_end;
L = numel(startFrame:iv:lastFrame);

% loading bar parameters---------------------------------------------------
if loading_bar('init',h_fig,L*(2-isMov),'Export to a *.gif file...');
    ok = 0;
    return;
end

h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);
% -------------------------------------------------------------------------

if isMov
    maxInt = max(max(max(h.movie.movie)));
    minInt = min(min(min(h.movie.movie)));
else
    for i = startFrame:iv:lastFrame
        [dat,ok] = getFrames([h.movie.path h.movie.file], i, ...
            {h.movie.speCursor, [h.movie.pixelX h.movie.pixelY], ...
            h.movie.framesTot}, h_fig, true);
        if ~ok
            return;
        end
        img = dat.frameCur;

        if max(max(img)) > maxInt
            maxInt = max(max(img));
        end
        if min(min(img)) < minInt
            minInt = min(min(img));
        end

        % loading bar updating---------------------------------------------
        if loading_bar('update', h_fig);
            ok = 0;
            return;
        end
        % -----------------------------------------------------------------
    end
end

for i = startFrame:iv:lastFrame
    
    if isMov
        img = h.movie.movie(:,:,i);
    else
        [dat,ok] = getFrames([h.movie.path h.movie.file],i, ...
            {h.movie.speCursor,[h.movie.pixelX h.movie.pixelY], ...
            h.movie.framesTot},h_fig,true);
        if ~ok
            return;
        end
        img = dat.frameCur;
    end
    img = 255*(img-minInt)/(maxInt-minInt);

    % Apply background corrections if exist
    if isBgCorr
        avBg = h.param.movPr.movBg_one;
        if ~avBg
            img = updateBgCorr(img, h_fig);
        else % Apply only if the bg-corrected frame is displayed
            if avBg == i
                img = updateBgCorr(img, h_fig);
            end
        end
    end

    img = uint8(img);

    if i==startFrame
        imwrite(img, [pathName nameMain], 'gif', 'WriteMode', ...
            'overwrite', 'Comment', ['rate:' ...
            num2str(h.movie.cyctime) ' min:' num2str(minInt) ...
            ' max:' num2str(maxInt)], 'LoopCount', Inf, ...
            'DelayTime', h.movie.cyctime);
    else
        imwrite(img, [pathName nameMain], 'gif', 'WriteMode', ...
            'append', 'DelayTime', h.movie.cyctime);
    end

    % loading bar updating-------------------------------------------------
    if loading_bar('update', h_fig);
        ok = 0;
        return;
    end
    % ---------------------------------------------------------------------

end

loading_bar('close', h_fig);


