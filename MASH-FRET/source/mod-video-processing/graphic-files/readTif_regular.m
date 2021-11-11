function [data,ok] = readTif_regular(fullFname, n, fDat, h_fig, useMov)

% defaults
ok = 1;
cycleTime = 1; % arbitrary time delay between each frame
data = [];
movie = [];
nbit = 4; % 1:int8, 2:int16, 4:single, 8:double

h = guidata(h_fig);
isMov = 0; % no movie variable was defined before (no memory is allocated)
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

if isempty(fDat)
    % get video infos
    fCurs = imfinfo(fullFname); % information array of .tif file
    frameLen = numel(fCurs); % number total of frames    
    txt = ['arbitrary ' num2str(cycleTime)];

    % If the *.tif file has been exported from SIRA, the cycletime is
    % stored in ImageDescription field of structure info.
    if isfield(fCurs,'ImageDescription')
        descr = fCurs(1,1).ImageDescription;
        strdat = str2num(descr);
        if ~isempty(strdat)
            cycleTime = strdat(1); % time delay between each frame
        end
        if ~isempty(cycleTime) && ~isnan(cycleTime)
            txt = num2str(cycleTime);
        end
    end
    pixelX = fCurs(1,1).Width; % width of the movie
    pixelY = fCurs(1,1).Height; % height of the movie
    
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
    fCurs = fDat{1};
    frameLen = fDat{3};
    pixelX = fDat{2}(1);
    pixelY = fDat{2}(2);
end

if strcmp(n,'all')
    
    if (isMov==0 || isMov==1) && ~memAlloc(pixelX*pixelY*(frameLen+1)*nbit)
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
            movie = repmat(uint16(0),pixelY,pixelX,frameLen);
            for i = 1:frameLen
                os = 0;
                if isfield(fCurs(i,1),'ImageDescription')
                    strdat = str2num(fCurs(i,1).ImageDescription);
                    if size(strdat,2) > 1
                        os = strdat(2); % negative intensity offset
                    end
                end
                movie(:,:,i) = imread(fullFname,'Index',i,'Info',fCurs)-os;
                
                if loading_bar('update', h_fig)
                    ok = 0;
                    return
                end
            end
            frameCur = movie(:,:,1);
            
        else
            % re-use previously allocated memory
            h.movie.movie = repmat(uint16(0),pixelY,pixelX,frameLen);

            for i = 1:frameLen
                os = 0;
                if isfield(fCurs(i,1),'ImageDescription') && ...
                        ischar(fCurs(i,1).ImageDescription)
                    strdat = str2num(fCurs(i,1).ImageDescription);
                    if size(strdat,2) > 1
                        os = strdat(2); % negative intensity offset
                    end
                end
                img = imread(fullFname,'Index',i,'Info',fCurs) - os;
                if size(img,3)>1
                    img = sum(img,3);
                end
                h.movie.movie(:,:,i) = img;
                if loading_bar('update', h_fig)
                    ok = 0;
                    return
                end
            end
            guidata(h_fig,h);
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
        if isfield(fCurs(n,1),'ImageDescription') && ...
                ~isempty(fCurs(n,1).ImageDescription)
            strdat = str2num(fCurs(n,1).ImageDescription);
            if size(strdat,2) > 1
                os = strdat(2); % negative intensity offset
            end
        end
        
        frameCur = imread(fullFname,'Index',n,'Info',fCurs) + os;
        if size(frameCur,3)>1
            frameCur = sum(frameCur,3);
        end
        movie = [];
    end
end
 
data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'frameCur', double(frameCur), ...
              'movie', movie);
data.fCurs = fCurs;
        
