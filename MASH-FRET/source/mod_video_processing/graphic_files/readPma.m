function [data,ok] = readPma(fullFname, n, fDat, h_fig, useMov)
% Read data from a .pma file (adapted from LoadPMA.m function in Traces
% software (https://github.com/stephlj/Traces/blob/master/tools/LoadPMA.m)

% defaults
data = [];
cycleTime = []; % time delay between each frame
movie = [];
ok = 1;
expT = 0.1;

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

f = fopen(fullFname, 'r');
if f<0
    disp('Invalid identifier.');
    fclose(f);
    ok = 0;
    return;
end

% first read
if isempty(fDat) 
    % Get the movie dimensions
    cycleTime = expT;
    
    pixelX = fread(f,1,'uint16');
    pixelY = fread(f,1,'uint16');

    % Get cursor position where graphic data begin
    fCurs = ftell(f);
    
    % Figure out how many frames are in this pma, based on the file size:
    fileinfo = dir(fullFname);
    if round(fileinfo.bytes/2)==fileinfo.bytes/2
        totbytes = fileinfo.bytes-4;
    else
        totbytes = fileinfo.bytes-5;
    end
    frameLen = totbytes/(pixelX*pixelY);
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

    if (isMov==0 || isMov==1) && ~memAlloc(frameLen*pixelX*pixelY)
        str = cat(2,'Out of memory: MASH is obligated to load the video ',...
            'one frame at a time to function\nThis will slow down all ',...
            'operations requiring video data, including the creation of ',...
            'time traces.');
        setContPan(str,'warning',h_fig);

        [data,ok] = readPma(fullFname,1,fDat,h_fig,0);
        frameCur = data.frameCur;

    else

        intrupt = loading_bar('init',h_fig,frameLen,'Import PMA video...');
        if intrupt
            ok = 0;
            return;
        end
        h = guidata(h_fig);
        h.barData.prev_var = h.barData.curr_var;
        guidata(h_fig, h);
        
        if ~exist('f','var')
            f = fopen(fullFname,'r');
        end
        
        fseek(f,fCurs,-1);
        if isMov==0
            movie = zeros([pixelY pixelX frameLen]);
            for i = 1:frameLen
                fseek(f, 2*i + pixelX*pixelY*(i-1), 0);
                movie(:,:,i) = reshape(fread(f, pixelX*pixelY, ...
                    'uint8=>single'), [pixelX pixelY])';

                intrupt = loading_bar('update', h_fig);
                if intrupt
                    ok = 0;
                    return;
                end
            end
            frameCur = movie(:,:,1); % Get image data of the input frame
        else
            h.movie.movie = zeros(pixelY,pixelX,frameLen,'single');
            for i = 1:frameLen 
                h.movie.movie(:,:,i) = flip(reshape(...
                    fread(f,pixelX*pixelY,'uint8=>single'),...
                    [pixelY,pixelX])',1); 

                intrupt = loading_bar('update', h_fig);
                if intrupt
                    ok = 0;
                    return
                end
            end
            guidata(h_fig,h);
            frameCur = h.movie.movie(:,:,1); % Get image data of the input frame
        end
        
        loading_bar('close', h_fig);
    end

else
    if isMov==2
        frameCur = h.movie.movie(:,:,n);
    else
        if ~exist('f','var')
            f = fopen(fullFname,'r');
        end
        fseek(f,fCurs,-1);
        fseek(f,2*n+pixelX*pixelY*(n-1),0);
        frameCur = reshape(fread(f,pixelX*pixelY,'uint8=>single'),...
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
              'frameCur', frameCur, ...
              'movie', movie);

