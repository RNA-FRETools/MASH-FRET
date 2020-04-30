function [data,ok] = readTif(fullFname, n, fDat, h_fig, useMov)

% defaults
ok = 1;

data = [];
cycleTime = []; % time delay between each frame
movie = [];

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

% Store useful movie data in hanldes.movie variable
info = imfinfo(fullFname); % information array of .tif file

if isempty(fDat)
    cycleTime = 1; % arbitrary time delay between each frame
    frameLen = numel(info); % number total of frames
    pixelX = info(1,1).Width; % width of the movie
    pixelY = info(1,1).Height; % height of the movie
    
    txt = ['arbitrary ' num2str(cycleTime)];
    
    % If the *.tif file has been exported from SIRA, the cycletime is
    % stored in ImageDescription field of structure info.
    if isfield(info,'ImageDescription')
        strdat = str2num(info(1,1).ImageDescription);
        if ~isempty(strdat)
            cycleTime = strdat(1); % time delay between each frame
            if ~isnan(cycleTime)
                txt = num2str(cycleTime);
            end
        end
    end
    
    if ~isempty(h_fig)
        updateActPan(['Tagged Image File Format(*.tiff)\n' ...
            'Cycle time = ' txt 's-1\n' ...
            'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
            ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n'], h_fig);
    else
        fprintf(['\nTagged Image File Format(*.tiff)\n' ...
            'Cycle time = ' txt 's-1\n' ...
            'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
            ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n']);
    end
else
    pixelX = fDat{2}(1);
    pixelY = fDat{2}(2);
    frameLen = fDat{3};
end

if strcmp(n,'all')
    
    if (isMov==0 || isMov==1) && ~memAlloc(pixelX*pixelY*(frameLen+1)*4)
        str = cat(2,'Out of memory: MASH is obligated to load the video ',...
            'one frame at a time to function\nThis will slow down all ',...
            'operations requiring video data, including the creation of ',...
            'time traces.');
        if ~isempty(h_fig)
            setContPan(str,'warning',h_fig);
        else
            disp(sprintf(str));
        end

        [data,ok] = readTif(fullFname,1,fDat,h_fig,0);
        frameCur = data.frameCur;

    else
        if loading_bar('init',h_fig, frameLen,...
                'Import movie frames from file...');
            ok = 0;
            return;
        end
        h = guidata(h_fig);
        h.barData.prev_var = h.barData.curr_var;
        guidata(h_fig, h);
        
        if isMov==0
            % allocate new memory
            movie = zeros(pixelY,pixelX,frameLen);
            for i = 1:frameLen
                os = 0;
                if isfield(info(i,1),'ImageDescription')
                    strdat = str2num(info(i,1).ImageDescription);
                    if size(strdat,2) > 1
                        os = strdat(2); % negative intensity offset
                    end
                end
                movie(:,:,i) = double(imread(fullFname,'Index',i,'Info',...
                    info)) - os;
                
                if loading_bar('update', h_fig);
                    ok = 0;
                    return;
                end
            end
            
            frameCur = movie(:,:,1);
            
        else
            % re-use previously allocated memory
            h.movie.movie = zeros(pixelY,pixelX,frameLen);

            for i = 1:frameLen
                os = 0;
                if isfield(info(i,1),'ImageDescription')
                    strdat = str2num(info(i,1).ImageDescription);
                    if size(strdat,2) > 1
                        os = strdat(2); % negative intensity offset
                    end
                end
                h.movie.movie(:,:,i) = double(imread(fullFname,'Index',i,...
                    'Info',info)) - os;
                
                if loading_bar('update', h_fig);
                    ok = 0;
                    return;
                end
            end
            
            frameCur = h.movie.movie(:,:,1);
        end

        if ~isempty(h_fig)
            loading_bar('close', h_fig);
        end
    end
    
else
    if isMov==2
        frameCur = h.movie.movie(:,:,n);
    else
        os = 0;
        if isfield(info(n,1),'ImageDescription') && ...
                ~isempty(info(n,1).ImageDescription)
            strdat = str2num(info(n,1).ImageDescription);
            if size(strdat,2) > 1
                os = strdat(2); % negative intensity offset
            end
        end

        frameCur = double(imread(fullFname,'Index',n,'Info',info)) + os;
        movie = [];
    end
end
 
data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', [], ...
              'frameCur', frameCur, ...
              'movie', movie);
        
