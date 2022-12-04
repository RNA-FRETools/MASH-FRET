function [data,ok] = readSpe(fullFname, n, h_fig, useMov)

% default
data = [];
ok = 1;
isMov = 0; % no movie variable was defined before (no memory is allocated)

% control video data
h = guidata(h_fig);
if ~isempty(h_fig)
    h = guidata(h_fig);
    if isFullLengthVideo(fullFname,h_fig)
        isMov = 2; % the movie variable exist and contain the video file data
    elseif isfield(h,'movie') && isfield(h.movie,'movie') && ...
            isempty(h.movie.movie)
        isMov = 1; % the movie variable exist and is free (free memory already allocated)
    end
end
if ~useMov
    isMov = 0;
end

if isMov==0 || isMov==1
    [pname,o,o] = fileparts(fullFname);
    cd(pname);
    
    % check for correct compilation of mex file for method SIFImport
    if exist('SPEImport','file')~=3
        h = guidata(h_fig);
        if h.mute_actions
            disp('MASH-FRET will proceed to file compilation...');
        else
            setContPan(cat(2,'MASH-FRET will proceed to file ',...
                'compilation...'),'warning',h_fig);
        end
        switch computer
            case 'PCWIN' % 32bit windows
                mex(which('SPEImport.c'),'-L./lib','-lITASL32');
            case 'PCWIN64' % 64bit windows
                mex(which('SPEImport.c'),'-L./lib','-lITASL64');
            case 'GLNX86' % 32bit Linux
                mex(which('SPEImport.c'),'-L./lib','-lITASL32');
            case 'GLNX64' % 64bit Linux
                mex(which('SPEImport.c'),'-L./lib','-lITASL64');
        end
    end
    
    try
        if isMov==1
            [h.movie.movie,info] = SPEImport(fullFname);
            frameLen = size(h.movie.movie, 3); % number total of frames
            cycleTime = info.exposure; % time delay between each frame
            pixelX = size(h.movie.movie, 2); % Width of the movie
            pixelY = size(h.movie.movie, 1); % Height of the movie
        else
            [movie,info] = SPEImport(fullFname);
            frameLen = size(movie, 3); % number total of frames
            cycleTime = info.exposure; % time delay between each frame
            pixelX = size(movie, 2); % Width of the movie
            pixelY = size(movie, 1); % Height of the movie
        end
        
    catch err
        if strcmp(err.identifier,'MATLAB:nomem')
            str = 'Out of memory: MASH is unable to load the .spe file.';
            setContPan(str,'warning',h_fig);
            ok = 0;
            return
        end
    end
end

% Store useful movie data in hanldes.movie variable
if isMov==1
    guidata(h_fig,h);
end

if strcmp(n, 'all')
    if isMov
        frameCur = h.movie.movie(:,:,1);
    else
        frameCur = movie(:,:,1);
    end
else
    if isMov
        frameCur = h.movie.movie(:,:,n);
    else
        frameCur = movie(:,:,n);
    end
end

data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', [], ...
              'frameCur', frameCur, ...
              'movie', movie);
          
          