function [data,ok] = readSpe(fullFname, n, h_fig, useMov)

% default
data = [];
ok = 1;

h = guidata(h_fig);
isMov = 0; % no movie variable was defined before (no memory is allocated)
if ~isempty(h_fig)
    if isfield(h,'movie') && isfield(h.movie,'movie')
        isMov = 1; % the movie variable exist and is free (free memory already allocated)
        if ~isempty(h.movie.movie)
            isMov = 2; % the movie variable exist and contain the video data
        end
    end
end

if ~useMov
    isMov = 0;
end

if isMov==0 || isMov==1
    pleaseWait('start', h_fig);
    [pname,o,o] = fileparts(fullFname);
    cd(pname);
    
    if ~exist('SPEImport')
        setContPan(cat(2,'SPE import can not be used: problem with mex ',...
            'compilation.'),'error',h.figure_MASH);
        ok = 0;
        return;
    end
    
    try
        [A,info] = SPEImport(fullFname);
        
    catch err
        if strcmp(err.identifier,'MATLAB:nomem')
            str = 'Out of memory: MASH is unable to load the .spe file.';
            setContPan(str,'warning',h_fig);
            ok = 0;
            return;
        end
    end

    pleaseWait('close', h_fig);
end

frameLen = size(A, 3); % number total of frames
cycleTime = info.exposure; % time delay between each frame
pixelX = size(A, 2); % Width of the movie
pixelY = size(A, 1); % Height of the movie

% Store useful movie data in hanldes.movie variable
if isMov==1
    h.movie.movie = double(A);
    guidata(h_fig,h);
else
    if ~memAlloc(4*frameLen*pixelX*pixelY)
        str = 'Out of memory: MASH is unable to load the .spe file.';
        setContPan(str,'warning',h_fig);
        ok = 0;
        return;
    end
    
    movie = double(A);
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
          
          