function ok = export2Mat(h_fig, pname, fname)
% ok = export2Mat(h_fig, fname, pname)
%
% Export the movie / image with background corrections to a .mat file
%
% h_fig: handle to main figure
% fname: file name
% pname: file location
% ok: 1 for succes, 0 otherwise

% defaults
ok = 0;

% collect video processing parameters
h = guidata(h_fig);
p = h.param;
vidfile = p.proj{p.curr_proj}.movie_file;
viddim = p.proj{p.curr_proj}.movie_dim;
viddat = p.proj{p.curr_proj}.movie_dat;
curr = p.proj{p.curr_proj}.VP.curr;
filtlst = curr.edit{1}{4};
start = curr.edit{2}(1);
stop = curr.edit{2}(2);
iv =  curr.edit{2}(3);
tocurr = curr.edit{1}{1}(2);

% control full-length video
isMov = isFullLengthVideo(h_fig);

% control image filters
isBgCorr = ~isempty(filtlst);

% abort if the file being written is the one being accessed for reading data
if ~isMov && isequal(vidfile,[pname fname])
    setContPan(cat(2,'The exported file must be different from the ',...
        'original one.'),'error'h_fig);
    return
end

% initialize loading bar
if loading_bar('init', h_fig, L, 'Export to a *.mat file...')
    return
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

% process video frames
img = zeros([viddim,viddat{3}]);
for i = start:iv:stop
    
    % get video frame
    if isMov
        img(:,:,i) = h.movie.movie(:,:,i);
    else
        [data,succ] = getFrames(vidfile, i, viddat, h_fig, true);
        if ~succ
            return
        end
        img(:,:,i) = data.frameCur;
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

    % increment loading bar
    if loading_bar('update', h_fig)
        return
    end
end

% close loading bar
loading_bar('close', h_fig);

% save data to file
save([pname fname], 'img', '-mat');

