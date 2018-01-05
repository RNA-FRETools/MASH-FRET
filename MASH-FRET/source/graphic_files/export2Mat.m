function ok = export2Mat(h_fig, nameMain, pathName)
% Export the movie / image with background corrections to a .mat file
%
% Requires functions: loading_bar, updateActPan, updateBgCorr.

ok = 1;

h = guidata(h_fig);

startFrame = h.param.movPr.mov_start;
lastFrame = h.param.movPr.mov_end;

% loading bar parameters--------------------------------------
intrupt = loading_bar('init', h_fig, lastFrame-startFrame+1, ...
    'Export to a *.tif file...');
if intrupt
    return;
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);
% ------------------------------------------------------------

img = zeros(h.movie.pixelY, h.movie.pixelX, lastFrame-startFrame);

for i = startFrame:lastFrame
    [dat ok] = getFrames([h.movie.path h.movie.file], i, ...
        {h.movie.speCursor, [h.movie.pixelX h.movie.pixelY], ...
        h.movie.framesTot}, h_fig);
    if ~ok
        return;
    end
    img(:,:,i) = dat.frameCur;
    % Apply background corrections if exist
    if isfield(h.param.movPr, 'bgCorr')
        avBg = h.param.movPr.movBg_one;
        if ~avBg
            img(:,:,i) = updateBgCorr(img(:,:,i), h_fig);
        else % Apply only if the bg-corrected frame is displayed
            if avBg == i
                img(:,:,i) = updateBgCorr(img(:,:,i), h_fig);
            end
        end
    end

    % loading bar updating---------------------------------------------
    if ~intrupt
        intrupt = loading_bar('update', h_fig);
    else
        ok = 0;
        break;
    end
    % -----------------------------------------------------------------
end
save([pathName nameMain], 'img', '-mat');
loading_bar('close', h_fig);

