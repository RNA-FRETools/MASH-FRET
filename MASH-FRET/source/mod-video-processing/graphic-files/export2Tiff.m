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
ok = 0;

% collect video processing parameters
h = guidata(h_fig);
p = h.param;
expT = p.proj{p.curr_proj}.frame_rate;
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
if loading_bar('init', h_fig, nMov*L, 'Export to *.tif format...')
    return
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

for mov = 1:nMov
    if nMov>1
        substr = ['_',labels{mov}];
    else
        substr = '';
    end
    fname = [rootname,substr,'.tif'];
    
    % control full-length video
    isMov = isFullLengthVideo(vidfile{mov},h_fig);

    % abort if the file being written is the one being accessed for reading data
    if ~isMov && isequal(vidfile{mov},[pname fname])
        setContPan(cat(2,'The exported file must be different from the ',...
            'original one.'),'error',h_fig);
        return
    end

    for i = frameRange

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

        imwrite(img_16,[pname fname],'tif','WriteMode',writeMode,...
            'Description',sprintf('%d\t%d',expT,min_img));

        % increment loading bar
        if loading_bar('update', h_fig)
            return
        end
    end
end

% close file and loading bar
loading_bar('close', h_fig);

% return success
ok = 1;

