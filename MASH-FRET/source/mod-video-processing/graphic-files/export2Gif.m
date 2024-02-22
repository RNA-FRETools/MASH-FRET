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
maxInt = -Inf;
minInt = Inf;

% collect video processing parameters
h = guidata(h_fig);
p = h.param;
expT = p.proj{p.curr_proj}.sampling_time;
vidfile = p.proj{p.curr_proj}.movie_file;
viddat = p.proj{p.curr_proj}.movie_dat;
labels = p.proj{p.curr_proj}.labels;
curr = p.proj{p.curr_proj}.VP.curr;
filtlst = curr.edit{1}{4};
start = curr.edit{2}(1);
stop = curr.edit{2}(2);
iv =  curr.edit{2}(3);
tocurr = curr.edit{1}{1}(2);

nMov = numel(vidfile);
multichanvid = nMov==1;

% control image filters
isBgCorr = ~isempty(filtlst);

% get video frame indexes
frameRange = start:iv:stop;
L = numel(frameRange);

[~,rootname,~] = fileparts(fname);

% initialize loading bar
if loading_bar('init', h_fig, nMov*L, 'Export to *.gif format...')
    return
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

for mov = 1:nMov
    if ~multichanvid
        substr = ['_',labels{mov}];
    else
        substr = '';
    end
    fname = [rootname,substr,'.gif'];
    
    % control full-length video
    isMov = isFullLengthVideo(vidfile{mov},h_fig);

    % abort if the file being written is the one being accessed for reading data
    if ~isMov && isequal(vidfile{mov},[pname fname])
        setContPan(cat(2,'The exported file must be different from the ',...
            'original one.'),'error',h_fig);
        return
    end

    if isMov
        maxInt = max(max(max(h.movie.movie)));
        minInt = min(min(min(h.movie.movie)));
    else
        for i = start:iv:stop

            % get video frame
            if isMov
                img = h.movie.movie(:,:,i);
            else
                [data,succ] = getFrames(vidfile{mov},i,viddat{mov},h_fig,...
                    true);
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
        end
    end

    % process and write video frame to file
    for i = start:iv:stop

       % get video frame
        if isMov
            img = h.movie.movie(:,:,i);
        else
            [data,succ] = getFrames(vidfile{mov},i,viddat{mov},h_fig,true);
            if ~succ
                return
            end
            img = data.frameCur;
        end

        % apply background corrections if any
        if isBgCorr
            if ~tocurr
                if multichanvid
                    img = updateBgCorr(img, p, h_fig);
                else
                    img = updateBgCorr(img, p, h_fig, mov);
                end
            else % Apply only if the bg-corrected frame is displayed
                if tocurr==i
                    if multichanvid
                        img = updateBgCorr(img, p, h_fig);
                    else
                        img = updateBgCorr(img, p, h_fig, mov);
                    end
                end
            end
        end

        % normalize intensities
        img = 255*(img-minInt)/(maxInt-minInt);

        % convert to uint8 format
        img = uint8(img);

        % write to file
        if i==start
            imwrite(img,[pname,fname],'gif','WriteMode','overwrite',...
                'Comment',['rate:',num2str(expT),' min:',num2str(minInt),...
                ' max:',num2str(maxInt)],'LoopCount',Inf,'DelayTime',expT);
        else
            imwrite(img,[pname,fname],'gif','WriteMode','append',...
                'DelayTime',expT);
        end

        % loading bar updating
        if loading_bar('update', h_fig)
            ok = 0;
            return
        end
    end
end

loading_bar('close', h_fig);

% return success
ok = 1;
