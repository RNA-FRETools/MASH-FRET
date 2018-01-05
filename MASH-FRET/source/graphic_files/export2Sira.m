function ok = export2Sira(h_fig, nameMain, pathName)
% Export the movie / image with background corrections to a .sira file
%
% Requires functions: loading_bar, updateActPan, updateBgCorr.

h = guidata(h_fig);

startFrame = h.param.movPr.mov_start;
lastFrame = h.param.movPr.mov_end;

ok = 1;

f = fopen([pathName nameMain], 'w');
if f == -1
    ok = 0;
    updateActPan(['Enable to open file ' nameMain], h_fig);
else
    figname = get(h_fig, 'Name');
    vers = figname(length('MASH smFRET '):end);
    fprintf(f, 'MASH smFRET exported binary graphic Version: %s\r', vers);
    fwrite(f, double(h.movie.cyctime), 'double');
    fwrite(f, single(h.movie.pixelX), 'single');
    fwrite(f, single(h.movie.pixelY), 'single');
    fwrite(f, single(lastFrame-startFrame+1), 'single');
    
    % loading bar parameters--------------------------------------
    intrupt = loading_bar('init', h_fig, lastFrame-startFrame+1, ...
        'Export to a *.sira file...');
    if ~intrupt

        h = guidata(h_fig);
        h.barData.prev_var = h.barData.curr_var;
        guidata(h_fig, h);
        % ------------------------------------------------------------

        for i = startFrame:lastFrame
            [data ok] = getFrames([h.movie.path h.movie.file], i, ...
                {h.movie.speCursor [h.movie.pixelX h.movie.pixelY] ...
                h.movie.framesTot}, h_fig);
            if ~ok
                return
            end
            img = data.frameCur;
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
            min_img = min(min(img));
            if min_img >= 0
                min_img = 0;
            end
            img = single(img+abs(min_img));
            imgBin = [reshape(img, 1, h.movie.pixelY*h.movie.pixelX) ...
                single(abs(min_img))];
            fwrite(f, imgBin, 'single');
            % loading bar updating-----------------------------------------
            if ~intrupt
                intrupt = loading_bar('update', h_fig);
            else
                fclose(f);
                ok = 0;
                return;
            end
            % -------------------------------------------------------------
        end
        fclose(f);
    end
    loading_bar('close', h_fig);
end
