function ok = export2Gif(h_fig, nameMain, pathName)
% Export the movie / image with background corrections to a .gif file
%
% Requires functions: loading_bar, updateActPan, updateBgCorr.

ok = 1;

h = guidata(h_fig);
startFrame = h.param.movPr.mov_start;
lastFrame = h.param.movPr.mov_end;
frameIv = 1;

% loading bar parameters---------------------------------------------------
intrupt = loading_bar('init', h_fig, ...
    floor(2*numel(startFrame:frameIv:lastFrame)), ...
    'Export to a *.gif file...');
if intrupt
    ok = 0;
    return;
end

h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);
% -------------------------------------------------------------------------

maxInt = 0;
minInt = 100000;

for i = startFrame:frameIv:lastFrame
    [dat ok] = getFrames([h.movie.path h.movie.file], i, ...
        {h.movie.speCursor, [h.movie.pixelX h.movie.pixelY], ...
        h.movie.framesTot}, h_fig);
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
    intrupt = loading_bar('update', h_fig);
    if intrupt
        ok = 0;
        loading_bar('close', h_fig);
        return;
    end
    % -----------------------------------------------------------------
end

for ii = startFrame:frameIv:lastFrame
    [dat ok] = getFrames([h.movie.path h.movie.file], ii, ...
        {h.movie.speCursor, [h.movie.pixelX h.movie.pixelY], ...
        h.movie.framesTot}, h_fig);
    if ~ok
        return;
    end
    img = dat.frameCur;
    img = 255*(img - minInt)/(maxInt - minInt);

    % Apply background corrections if exist
    if isfield(h.param.movPr, 'bgCorr')
        avBg = h.param.movPr.movBg_one;
        if ~avBg
            img = updateBgCorr(img, h_fig);
        else % Apply only if the bg-corrected frame is displayed
            if avBg == ii
                img = updateBgCorr(img, h_fig);
            end
        end
    end

    img = uint8(img);

    if ii == startFrame
        imwrite(img, [pathName nameMain], 'gif', 'WriteMode', ...
            'overwrite', 'Comment', ['rate:' ...
            num2str(h.movie.cyctime) ' min:' num2str(minInt) ...
            ' max:' num2str(maxInt)], 'LoopCount', Inf, ...
            'DelayTime', h.movie.cyctime);
    else
        imwrite(img, [pathName nameMain], 'gif', 'WriteMode', ...
            'append');
    end

    % loading bar updating-------------------------------------------------
    intrupt = loading_bar('update', h_fig);
    if intrupt
        ok = 0;
        loading_bar('close', h_fig);
        return;
    end
    % ---------------------------------------------------------------------

end
loading_bar('close', h_fig);
ok = 1;

