function ok = export2Avi(h_fig, fname, pname)
% Export the video/image loaded in module Video processing  to a .avi file, after applying image filters/background corrections
% Pixel values are normalized frame-wise before being written to file
%
% Requires functions: loading_bar, updateActPan, updateBgCorr, getFrame, writeAviFile.

% Last update: 5.12.2019 by MH
% >> use external function writeAviFile.m to create and write pixel data in
%  avi file (this allows the use of the same script from both modules Video
%  processing and Simulation)

% defaults
iv = 1;

% initialize execution failure/success
ok = 0;

% collect video processing parameters
h = guidata(h_fig);
p = h.param.movPr;

% identify if a full-length video was loaded
isMov = isfield(h,'movie') && isfield(h.movie,'movie') && ...
    ~isempty(h.movie.movie);

% identify if background corrections must be applied
isBgCorr = isfield(p,'bgCorr') && ~isempty(p.bgCorr);

% get video frame indexes
frameRange = p.mov_start:iv:p.mov_end;
L = numel(frameRange);

% open blank avi file
v = writeAviFile('init',cat(2,pname,fname),h.movie.cyctime);

% initialize loading bar
if loading_bar('init',h_fig,L,'Export to an *.avi file...');
    return;
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

for i = frameRange
    
    % get video frame
    if isMov
        img = h.movie.movie(:,:,i);
    else
        [data,succ] = getFrames([h.movie.path h.movie.file], i, ...
            {h.movie.speCursor [h.movie.pixelX h.movie.pixelY] ...
            h.movie.framesTot}, h_fig);
        if ~succ
            return
        end
        img = data.frameCur;
    end

    % apply background corrections if any
    if isBgCorr
        avBg = p.movBg_one;
        if ~avBg
            img = updateBgCorr(img, h_fig);
        else % Apply only if the bg-corrected frame is displayed
            if avBg == i
                img = updateBgCorr(img, h_fig);
            end
        end
    end
    
    % write pixel data to avi file
    v = writeAviFile('append',v,img);

    % increment loading bar
    if loading_bar('update', h_fig)
        close(v);
        return;
    end
end

% close file and loading bar
close(v);
loading_bar('close', h_fig);
