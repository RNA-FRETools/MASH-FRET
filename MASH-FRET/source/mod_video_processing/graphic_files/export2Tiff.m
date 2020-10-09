function ok = export2Tiff(h_fig, nameMain, pathName)
% Export the movie / image with background corrections to a .tif file
%
% Requires functions: loading_bar, updateActPan, updateBgCorr.

% defaults
ok = 1;
iv = 1;
isMov = 0;
isBgCorr = 0;

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
if loading_bar('init',h_fig,L,'Export to a *.tif file...');
    return;
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);
% -------------------------------------------------------------------------

for i = startFrame:iv:lastFrame

    if isMov
        img = h.movie.movie(:,:,i);
    else
        [dat,ok] = getFrames([h.movie.path h.movie.file], i, ...
            {h.movie.speCursor, [h.movie.pixelX h.movie.pixelY], ...
            h.movie.framesTot}, h_fig, true);
        if ~ok
            return;
        end
        img = dat.frameCur;
    end

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
    
    min_img = min(min(round(img)));
    if min_img >= 0
        min_img = 0;
    end
    img_16 = uint16(round(img)+abs(min_img));

    if i == startFrame
        writeMode = 'overwrite';
    else
        writeMode = 'append';
    end

    imwrite(img_16,[pathName nameMain],'tif','WriteMode',writeMode,...
        'Description',sprintf('%d\t%d',h.movie.cyctime,min_img));

    % loading bar updating-------------------------------------------------
    if loading_bar('update', h_fig);
        ok = 0;
        return;
    end
    % ---------------------------------------------------------------------
end

loading_bar('close', h_fig);


