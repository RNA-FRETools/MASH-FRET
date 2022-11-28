function [data,ok] = readPma(fullFname, n, fDat, h_fig, useMov)
% Read data from a .pma file (adapted from LoadPMA.m function in Traces
% software (https://github.com/stephlj/Traces/blob/master/tools/LoadPMA.m)

% defaults
data = [];
cycleTime = []; % time delay between each frame
movie = [];
ok = 1;
expT = 0.1;
nbit = 1;
fmt = 'old';
skpiv = 2;
skpbt = 0;

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

% identify already-opened loading bar
islb = isfield(h,'barData');

f = fopen(fullFname, 'r');
if f<0
    disp('Invalid identifier.');
    fclose(f);
    ok = 0;
    return;
end

if isempty(fDat)
    pixelX = fread(f,1,'uint16');
    pixelY = fread(f,1,'uint16');
else
    pixelX = fDat{2}(1);
    pixelY = fDat{2}(2);
end

% Figure out how many frames are in this pma, based on the file size:
fileinfo = dir(fullFname);
totbytes = fileinfo.bytes-4;
frameLen = totbytes/(pixelX*pixelY);
if round(frameLen)~=frameLen
    fmt = 'new';
    skpbt = 1;
    skpiv = 1;
    frameLen = totbytes/(2*(pixelX*pixelY+skpiv));
end

% first read
if isempty(fDat) 
    % Get the movie dimensions
    cycleTime = expT;

    % Get cursor position where graphic data begin
    fCurs = ftell(f);
    
    clear totbytes fileinfo
    
    if round(frameLen)~=frameLen
        setContPan(['LoadPMA: Cannot get a complete set of frames out of ',...
            'this file. Something is wrong.'],'warning',h_fig);
        ok = 0;
        return
    end

    if ~isempty(h_fig)
        updateActPan(['PMA binary File(*.pma)\n' ...
            'Cycle time = ' num2str(cycleTime) 's\n' ...
            'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
            ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n'], h_fig);
    else
        fprintf(['\nPMA binary File(*.pma)\n' ...
            'Cycle time = ' num2str(cycleTime) 's\n' ...
            'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
            ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n'])
    end
else
    fCurs = fDat{1};
    pixelX = fDat{2}(1);
    pixelY = fDat{2}(2);
    frameLen = fDat{3};
end

if strcmp(n, 'all')

    if (isMov==0 || isMov==1) && ~memAlloc(frameLen*pixelX*pixelY*nbit)
        str = cat(2,'Out of memory: MASH is obligated to load the video ',...
            'one frame at a time to function\nThis will slow down all ',...
            'operations requiring video data, including the creation of ',...
            'time traces.');
        setContPan(str,'warning',h_fig);

        [data,ok] = readPma(fullFname,1,fDat,h_fig,0);
        frameCur = data.frameCur;

    else

        if ~islb
            if loading_bar('init',h_fig,frameLen,'Import PMA video...')
                ok = 0;
                return
            end
            h = guidata(h_fig);
            h.barData.prev_var = h.barData.curr_var;
            guidata(h_fig, h);
        else
            setContPan('Import PMA video...','',h_fig);
        end
        
        if ~exist('f','var')
            f = fopen(fullFname,'r');
        end
        
        fseek(f,fCurs,-1);
        if isMov==0
            movie = repmat(uint8(0),[pixelY pixelX frameLen]);
            for i = 1:frameLen
                switch fmt
                    case 'new'
                        fseek(f,(skpiv*(2*i-1) + 2*pixelX*pixelY*(i-1)),0);
                    case 'old'
                        fseek(f,pixelX*pixelY*(i-1),0);
                end
                movie(:,:,i) = reshape(fread(f, pixelX*pixelY, ...
                    'uint8=>single',skpbt), [pixelX pixelY])';
                
                intrupt = loading_bar('update', h_fig);
                if intrupt
                    ok = 0;
                    return
                end
            end
            frameCur = movie(:,:,1); % Get image data of the input frame
        else
            h.movie.movie = zeros(pixelY,pixelX,frameLen,'single');
            for i = 1:frameLen
                switch fmt
                    case 'new'
                        fseek(f,(skpiv*(2*i-1) + 2*pixelX*pixelY*(i-1)),0);
                    case 'old'
                        fseek(f,pixelX*pixelY*(i-1),0);
                end
                h.movie.movie(:,:,i) = flip(reshape(...
                    fread(f,pixelX*pixelY,'uint8=>single'),...
                    [pixelY,pixelX])',skpbt);

                if ~islb && loading_bar('update', h_fig)
                    ok = 0;
                    return
                end
            end
            guidata(h_fig,h);
            frameCur = h.movie.movie(:,:,1); % Get image data of the input frame
        end
        
        if ~islb
            loading_bar('close', h_fig);
        end
    end

else
    if isMov==2
        frameCur = h.movie.movie(:,:,n);
    else
        if ~exist('f','var')
            f = fopen(fullFname,'r');
        end
        fseek(f,fCurs,-1);
        switch fmt
            case 'new'
                fseek(f,(skpiv*(2*n-1) + 2*pixelX*pixelY*(n-1)),0);
            case 'old'
                fseek(f,pixelX*pixelY*(n-1),0);
        end
        frameCur = reshape(fread(f,pixelX*pixelY,'uint8=>single',skpbt),...
            [pixelX pixelY])';
    end
end

if exist('f','var')
    fclose(f);
end

data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', fCurs, ...
              'frameCur', double(frameCur), ...
              'movie', movie);

