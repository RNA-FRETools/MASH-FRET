function ok = export2Sira(h_fig, fname, pname)
% ok = export2Sira(h_fig, fname, pname)
%
% Export the video/image loaded in module Video processing  to a .sira file, after applying image filters/background corrections
%
% h_fig: handle to main figure
% fname: destination file name
% pname: destination folder
% ok: execution success (1 if export was a success, 0 otherwise)

% update 5.12.2019 by MH: use external function writeSiraFile.m to create and write pixel data in sira file (this allows to call the same script from both modules Video processing and Simulation)

% defaults
ok = 0;

% collect video processing parameters
h = guidata(h_fig);
p = h.param;
expT = p.proj{p.curr_proj}.frame_rate;
vidfile = p.proj{p.curr_proj}.movie_file;
viddim = p.proj{p.curr_proj}.movie_dim;
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

% get MASH-FRET version
figname = get(h_fig, 'Name');
vers = figname(length('MASH-FRET ')+1:end);

[~,rootname,~] = fileparts(fname);

% initialize loading bar
if loading_bar('init', h_fig, nMov*L, 'Export to *.sira format...')
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
    fname = [rootname,substr,'.sira'];
    
    % control full-length video
    isMov = isFullLengthVideo(vidfile{mov},h_fig);

    % abort if the file being written is the one being accessed for reading data
    if ~isMov && isequal(vidfile{mov},[pname fname])
        setContPan(cat(2,'The exported file must be different from the ',...
            'original one.'),'error',h_fig);
        return
    end
    
    % process and write video frames to file
    nPix = prod(viddim{mov});

    % write sira file headers
    f = writeSiraFile('init',[pname fname],vers,[expT,viddim{mov},L]);
    if f == -1
        setContPan(['Enable to open file ' fname],'error',h_fig);
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

        % write pixel data to sira file
        writeSiraFile('append',f,img,nPix);

        % increment loading bar
        if loading_bar('update', h_fig)
            return
        end
    end
    
    % close file
    fclose(f);
end

% close loading bar
loading_bar('close', h_fig);

% return success
ok = 1;
