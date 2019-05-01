function ok = export2Mat(h_fig, nameMain, pathName)
% Export the movie / image with background corrections to a .mat file
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
if loading_bar('init',h_fig,L,'Export to a *.mat file...');
    ok = 0;
    return;
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);
% -------------------------------------------------------------------------

img = zeros(h.movie.pixelY,h.movie.pixelX,L);

for i = startFrame:iv:lastFrame
    
    if isMov
        img = h.movie.movie(:,:,i);
    else
        [dat,ok] = getFrames([h.movie.path h.movie.file], i, ...
            {h.movie.speCursor, [h.movie.pixelX h.movie.pixelY], ...
            h.movie.framesTot}, h_fig);
        if ~ok
            return;
        end
        img(:,:,i) = dat.frameCur;
    end
    
    % Apply background corrections if exist
    if isBgCorr
        avBg = h.param.movPr.movBg_one;
        if ~avBg
            img(:,:,i) = updateBgCorr(img(:,:,i), h_fig);
        else % Apply only if the bg-corrected frame is displayed
            if avBg == i
                img(:,:,i) = updateBgCorr(img(:,:,i), h_fig);
            end
        end
    end

    % loading bar updating-------------------------------------------------
    if loading_bar('update', h_fig);
        ok = 0;
        return;
    end
    % ---------------------------------------------------------------------
end

save([pathName nameMain], 'img', '-mat');
loading_bar('close', h_fig);

