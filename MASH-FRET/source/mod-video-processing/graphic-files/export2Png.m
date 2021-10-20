function ok = export2Png(h_fig, fname, pname)
% ok = export2Png(h_fig, fname, pname)
%
% Export the image with background corrections to a .png file
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
curr = p.proj{p.curr_proj}.VP.curr;
filtlst = curr.edit{1}{4};
start = curr.edit{2}(1);

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

% get video frame
if isMov
    img = h.movie.movie(:,:,start);
else
    [data,succ] = getFrames(vidfile, start, viddat, h_fig, true);
    if ~succ
        return
    end
    img = data.frameCur;
end

% apply background corrections if any
if isBgCorr
    img = updateBgCorr(img, p, h_fig);
end

% write image to file
imwrite(uint16(65535*(img-min(min(img)))/(max(max(img))-min(min(img)))), ...
    [pname fname],'png','BitDepth',16,'Description',[num2str(expT) ' ' ...
    num2str(max(max(img))) ' ' num2str(min(min(img)))]);

