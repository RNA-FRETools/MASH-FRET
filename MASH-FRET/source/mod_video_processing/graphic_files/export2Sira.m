function ok = export2Sira(h_fig, fname, pname)
% Export the video/image loaded in module Video processing  to a .sira file, after applying image filters/background corrections
%
% Requires functions: loading_bar, updateActPan, updateBgCorr, getFrame, writeSiraFile.

% Last update: 5.12.2019 by MH
% >> use external function writeSiraFile.m to create and write pixel data 
%  in sira file (this allows to call the same script from both modules 
%  Video processing and Simulation)

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

% abort if the file being written is the one being accessed for reading data
if ~isMov && strcmp([h.movie.path h.movie.file],[pname fname])
    updateActPan(cat(2,'The exported file must be different from the ',...
        'original one.'),h_fig);
    return
end

% get video frame indexes
frameRange = p.mov_start:iv:p.mov_end;
L = numel(frameRange);

% get MASH-FRET version
figname = get(h_fig, 'Name');
vers = figname(length('MASH-FRET ')+1:end);

% write sira file headers
f = writeSiraFile('init',[pname fname],vers,[h.movie.cyctime,...
    h.movie.pixelX,h.movie.pixelY,L]);
if f == -1
    updateActPan(['Enable to open file ' fname], h_fig);
    return
end

% initialize loading bar
if loading_bar('init', h_fig, L, 'Export to a *.sira file...');
    fclose(f);
    return
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

% get number of pixels in one frame
nPix = h.movie.pixelX*h.movie.pixelY;

for i = frameRange
    
    % get video frame
    if isMov
        img = h.movie.movie(:,:,i);
    else
        [data,succ] = getFrames([h.movie.path h.movie.file], i, ...
            {h.movie.speCursor [h.movie.pixelX h.movie.pixelY] ...
            h.movie.framesTot}, h_fig, true);
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
    
    % write pixel data to sira file
    writeSiraFile('append',f,img,nPix);

    % increment loading bar
    if loading_bar('update', h_fig);
        fclose(f);
        return
    end
end

% close file and loading bar
fclose(f);
loading_bar('close', h_fig);

% return success
ok = 1;
