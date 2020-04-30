function [data,ok] = readGif(fullFname, n, h_fig, useMov)

% defaults
data = [];
cycleTime = []; % time delay between each frame
movie = [];
ok = 1;
maxI = 1; 
minI = 0;

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

info = imfinfo(fullFname); % information array of .tif file
% Store useful movie data in hanldes.movie variable
frameLen = numel(info); % number total of frames
pixelX = double(info(1,1).Width); % width of the movie
pixelY = double(info(1,1).Height); % height of the movie

if isfield(info, 'CommentExtension')
    % time delay between each frame
    cycleTime = getValueFromStr('rate:', info(1,1).CommentExtension);
    if ~(~isempty(cycleTime) && ~isnan(cycleTime))
        cycleTime = 1; % arbitrary time delay between each frame
        txt = ['arbitrary ' num2str(cycleTime)];
    else
        txt = num2str(cycleTime);
    end
    if ~isempty(cycleTime) && ~isnan(cycleTime)
        maxI = getValueFromStr('max:', info(1,1).CommentExtension); 
        minI = getValueFromStr('min:', info(1,1).CommentExtension);
    end
else
    cycleTime = 1; % arbitrary frame rate
    txt = ['arbitrary ' num2str(cycleTime)];
end

if ~isempty(h_fig)
    updateActPan(['Graphics Interchange Format(*.gif)\n' ...
         'Cycle time = ' txt 's\n' ...
         'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
         ' pixels\n' ...
         'Movie length = ' num2str(frameLen) ' frames\n'], h_fig);
else
    fprintf(['\nGraphics Interchange Format(*.gif)\n' ...
         'Cycle time = ' txt 's\n' ...
         'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
         ' pixels\n' ...
         'Movie length = ' num2str(frameLen) ' frames\n']);
end
    
if strcmp(n, 'all')
    if (isMov==0 || isMov==1) && ~memAlloc(frameLen*pixelX*pixelY*4)
        str = cat(2,'Out of memory: MASH is obligated to load the video ',...
            'one frame at a time to function\nThis will slow down all ',...
            'operations requiring video data, including the creation of ',...
            'time traces.');
        setContPan(str,'warning',h_fig);

        [data,ok] = readGif(fullFname,1,fDat,h_fig,0);
        frameCur = data.frameCur;
        
    else
        if ~isempty(h_fig)
            pleaseWait('start', h_fig);
            h = guidata(h_fig);
        else
            disp('Please wait ...');
        end
        
        if isMov==0
            movie = uint8(imread(fullFname, 'frames', 'all'));
            movie = squeeze(movie);
            frameCur = double(movie(:,:,1))*(maxI-minI)/255+minI;
        else
            h.movie.movie = uint8(imread(fullFname, 'frames', 'all'));
            h.movie.movie = squeeze(h.movie.movie);
            frameCur = double(h.movie.movie(:,:,1))*(maxI-minI)/255+minI;
            guidata(h_fig,h);
        end
        
        if ~isempty(h_fig)
            pleaseWait('close', h_fig);
        end
    end
    
else
    if isMov==2
        frameCur = h.movie.movie(:,:,n);
    else
        frameCur = double(squeeze(imread(fullFname, 'frames', n)))*...
            (maxI-minI)/255 + minI;
    end
end

data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', [], ...
              'frameCur', frameCur, ...
              'movie', movie);
        
