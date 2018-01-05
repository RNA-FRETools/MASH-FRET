function ok = export2Tiff(h_fig, nameMain, pathName)
% Export the movie / image with background corrections to a .tif file
%
% Requires functions: loading_bar, updateActPan, updateBgCorr.

ok = 1;

h = guidata(h_fig);

startFrame = h.param.movPr.mov_start;
lastFrame = h.param.movPr.mov_end;

% loading bar parameters--------------------------------------
intrupt = loading_bar('init', h_fig, lastFrame-startFrame+1, ...
    'Export to a *.tif file...');
if ~intrupt

    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    % ------------------------------------------------------------

    for i = startFrame:lastFrame
        if i == startFrame
            writeMode = 'overwrite';
        else
            writeMode = 'append';
        end
        [dat ok] = getFrames([h.movie.path h.movie.file], i, ...
            {h.movie.speCursor, [h.movie.pixelX h.movie.pixelY], ...
            h.movie.framesTot}, h_fig);
        if ~ok
            return;
        end
        img = dat.frameCur;
        % Apply background corrections if exist
        if isfield(h.param.movPr, 'bgCorr')
            avBg = h.param.movPr.movBg_one;
            if ~avBg
                img = updateBgCorr(img, h_fig);
            else % Apply only if the bg-corrected frame is displayed
                if avBg == i
                    img = updateBgCorr(img, h_fig);
                end
            end
        end
        min_img = min(min(round(img)));
        if min_img >= 0
            min_img = 0;
        end
        img_16 = uint16(round(img)+abs(min_img));
        imwrite(img_16, [pathName nameMain], 'tif', 'WriteMode', ...
            writeMode, 'Description', ...
            sprintf('%d\t%d', h.movie.cyctime, min_img));

        % loading bar updating---------------------------------------------
        if ~intrupt
            intrupt = loading_bar('update', h_fig);
        else
            ok = 0;
            break;
        end
        % -----------------------------------------------------------------
    end
    intrupt = loading_bar('close', h_fig);
end

