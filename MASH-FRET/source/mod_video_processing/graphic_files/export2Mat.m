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
p = h.param.movPr;

if isfield(h,'movie') && isfield(h.movie,'movie') && ...
    ~isempty(h.movie.movie)
    isMov = 1;
end
if isfield(p, 'bgCorr') && ~isempty(p.bgCorr)
    isBgCorr = 1;
end

startFrame = p.mov_start;
lastFrame = p.mov_end;
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
            h.movie.framesTot}, h_fig, true);
        if ~ok
            return;
        end
        img(:,:,i) = dat.frameCur;
    end
    
    % Apply background corrections if exist
    if isBgCorr
        avBg = p.movBg_one;
        if ~avBg
            [img,avImg] = updateBgCorr(img, p, h.movie, h_fig);
        else % Apply only if the bg-corrected frame is displayed
            if avBg==i
                [img,avImg] = updateBgCorr(img, p, h.movie, h_fig);
            end
        end
        if ~isfield(h.movie,'avImg')
            h.movie.avImg = avImg;
            guidata(h_fig,h);
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

