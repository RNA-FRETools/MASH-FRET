function [data ok] = readGif(fullFname, n, h_fig)

data = [];
ok = 1;

% Store useful movie data in hanldes.movie variable
info = imfinfo(fullFname); % information array of .tif file
frameLen = numel(info); % number total of frames
pixelX = info(1,1).Width; % width of the movie
pixelY = info(1,1).Height; % height of the movie

if isfield(info, 'CommentExtension')
    % time delay between each frame
    cycleTime = getValueFromStr('rate:', info(1,1).CommentExtension);
    if ~(~isempty(cycleTime) && ~isnan(cycleTime))
        cycleTime = 1; % arbitrary time delay between each frame
        txt = ['arbitrary ' num2str(cycleTime)];
    else
        txt = num2str(cycleTime);
    end
    if ~(~isempty(cycleTime) && ~isnan(cycleTime))
        maxI = 1; 
        minI = 0; 
    else
        maxI = getValueFromStr('max:', info(1,1).CommentExtension); 
        minI = getValueFromStr('min:', info(1,1).CommentExtension);
    end
else
    cycleTime = 1; % arbitrary frame rate
    txt = ['arbitrary ' num2str(cycleTime)];
    maxI = 1; 
    minI = 0; 
end

if ~isempty(h_fig)
    updateActPan(['Graphics Interchange Format(*.gif)\n' ...
         'Cycle time = ' txt 's-1\n' ...
         'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
         ' pixels\n' ...
         'Movie length = ' num2str(frameLen) ' frames\n'], h_fig);
else
    fprintf(['\nGraphics Interchange Format(*.gif)\n' ...
         'Cycle time = ' txt 's-1\n' ...
         'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
         ' pixels\n' ...
         'Movie length = ' num2str(frameLen) ' frames\n']);
end
           
if strcmp(n, 'all')
    if ~isempty(h_fig)
        pleaseWait('start', h_fig);
    else
        disp('Please wait ...');
    end
    
    try
        movie = uint8(imread(fullFname, 'frames', 'all'));
        movie = squeeze(movie);
        frameCur = double(movie(:,:,1))*(maxI - minI)/255 + minI;
        
    catch exception
        if (strcmp(exception.identifier, 'MATLAB:nomem'))
            ok = 0;
            fclose(f);
            if ~isempty(h_fig)
                pleaseWait('close', h_fig);
                updateActPan('Out of memory, no file loaded.', h_fig, ...
                    'error');
            else
                disp('Out of memory, no file loaded.');
            end
        else
            throw(exception);
        end
    end
    
else
    frameCur = uint8(imread(fullFname, 'frames', n));
    frameCur = squeeze(frameCur);
    frameCur = double(frameCur(:,:,1))*(maxI - minI)/255 + minI;
    movie = [];
end

data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', [], ...
              'frameCur', frameCur, ...
              'movie', movie);
        
