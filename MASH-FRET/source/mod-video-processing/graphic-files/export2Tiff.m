function ok = export2Tiff(h_fig, fname, pname)
% ok = export2Tiff(h_fig, fname, pname)
%
% Export the movie / image with background corrections to a .tif file
%
% h_fig: handle to main figure
% fname: file name
% pname: file location
% ok: 1 for succes, 0 otherwise

% defaults
iv = 1;
ok = 0;

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
if loading_bar('init', h_fig, L, 'Export to a *.tif file...')
    return
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

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
    
    min_img = min(min(round(img)));
    if min_img >= 0
        min_img = 0;
    end
    img_16 = uint16(round(img)+abs(min_img));

    if i == start
        writeMode = 'overwrite';
    else
        writeMode = 'append';
    end

    imwrite(img_16,[pname fname],'tif','WriteMode',writeMode,'Description',...
        sprintf('%d\t%d',expT,min_img));

    % increment loading bar
    if loading_bar('update', h_fig)
        return
    end
end

% close file and loading bar
loading_bar('close', h_fig);

% return success
ok = 1;

