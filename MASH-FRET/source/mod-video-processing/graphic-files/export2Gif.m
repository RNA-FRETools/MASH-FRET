function ok = export2Gif(h_fig, fname, pname)
% ok = export2Gif(h_fig, fname, pname)
%
% Export the movie / image with background corrections to a .gif file
% Pixel values are normalized frame-wise before being written to file
%
% h_fig: handle to main figure
% fname: file name
% pname: file location
% ok: 1 for succes, 0 otherwise

% defaults
ok = 0;
iv = 1;
maxInt = -Inf;
minInt = Inf;

% collect video processing parameters
h = guidata(h_fig);
p = h.param;
expT = p.proj{p.curr_proj}.frame_rate;
vidfile = p.proj{p.curr_proj}.movie_file;
viddat = p.proj{p.curr_proj}.movie_dat;
curr = p.proj{p.curr_proj}.VP.curr;
filtlst = curr.edit{1}{4};
start = curr.edit{2}(1);
stop = curr.edit{2}(2);
tocurr = curr.edit{1}{1}(2);

% control full-length video
isMov = isFullLengthVideo(h_fig);

% control image filters
isBgCorr = ~isempty(filtlst);

% abort if the file being written is the one being accessed for reading data
if ~isMov && isequal(vidfile,[pname fname])
    updateActPan(cat(2,'The exported file must be different from the ',...
        'original one.'),h_fig);
    return
end

% initialize loading bar
if loading_bar('init',h_fig,(double(~isMov)+1)*L,...
        'Export to a *.gif file...')
    return
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

if isMov
    maxInt = max(max(max(h.movie.movie)));
    minInt = min(min(min(h.movie.movie)));
else
    for i = start:iv:stop
        
        % get video frame
        if isMov
            img = h.movie.movie(:,:,i);
        else
            [data,succ] = getFrames(vidfile, i, viddat, h_fig, true);
            if ~succ
                return
            end
            img = data.frameCur;
        end

        % get maximum and minimum intensities
        if max(max(img)) > maxInt
            maxInt = max(max(img));
        end
        if min(min(img)) < minInt
            minInt = min(min(img));
        end

        % increment loading bar
        if loading_bar('update', h_fig)
            return
        end
    end
end

% process and write video frame to file
for i = start:iv:stop
    
   % get video frame
    if isMov
        img = h.movie.movie(:,:,i);
    else
        [data,succ] = getFrames(vidfile, i, viddat, h_fig, true);
        if ~succ
            return
        end
        img = data.frameCur;
    end

    % apply background corrections if any
    if isBgCorr
        if ~tocurr
            img = updateBgCorr(img, p, h_fig);
        else % Apply only if the bg-corrected frame is displayed
            if tocurr==i
                img = updateBgCorr(img, p, h_fig);
            end
        end
    end
    
    % normalize intensities
    img = 255*(img-minInt)/(maxInt-minInt);

    % convert to uint8 format
    img = uint8(img);
    
    % write to file
    if i==start
        imwrite(img,[pname,fname],'gif','WriteMode','overwrite','Comment',...
            ['rate:',num2str(expT),' min:',num2str(minInt),' max:',...
            num2str(maxInt)],'LoopCount',Inf,'DelayTime',expT);
    else
        imwrite(img,[pname,fname],'gif','WriteMode','append','DelayTime',...
            expT);
    end

    % loading bar updating
    if loading_bar('update', h_fig)
        ok = 0;
        return
    end
end

loading_bar('close', h_fig);


