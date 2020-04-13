function ok = export2Gif(h_fig, fname, pname)
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

% get interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if isfield(h,'movie') && isfield(h.movie,'movie') && ...
        ~isempty(h.movie.movie)
    isMov = 1;
end

% get processing parameters
startFrame = p.mov_start;
lastFrame = p.mov_end;
L = numel(startFrame:iv:lastFrame);
if isfield(p, 'bgCorr') && ~isempty(p.bgCorr)
    isBgCorr = 1;
end

% loading bar parameters
if loading_bar('init',h_fig,L*(2-isMov),'Export to a *.gif file...');
    ok = 0;
    return
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

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

        % loading bar updating
        if loading_bar('update', h_fig);
            ok = 0;
            return
        end
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
            return
        end
        img = dat.frameCur;
    end
    img = 255*(img-minInt)/(maxInt-minInt);

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

    img = uint8(img);

    if i==startFrame
        imwrite(img,[pname,fname],'gif','WriteMode','overwrite','Comment',...
            ['rate:',num2str(h.movie.cyctime),' min:',num2str(minInt),...
            ' max:',num2str(maxInt)],'LoopCount',Inf,'DelayTime',...
            h.movie.cyctime);
    else
        imwrite(img,[pname,fname],'gif','WriteMode','append',...
            'DelayTime',h.movie.cyctime);
    end

    % loading bar updating
    if loading_bar('update', h_fig);
        ok = 0;
        return
    end
end

loading_bar('close', h_fig);


