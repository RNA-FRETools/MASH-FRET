function [data,ok] = readSira(fullFname, n, fDat, h_fig, useMov)
% Read data from bits in a *.sira file. Returns useful movie parameters and
% image data of all movie frames.
%
% Requires external functions: loading_bar, updateActPan, pleaseWait.

% defaults
data = [];
ok = 1;
isMov = 0; % no movie variable was defined before (no memory is allocated)
nbit = 4; % 8: double, 4: single

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

% identify already-opened loading bar
islb = isfield(h,'barData');

% initializes potentially undefined video data
cycleTime = []; % time delay between each frame
movie = [];

% first read
if isempty(fDat)
    
    % get MASH-FRET version & reading parameters
    [vers,is_os,is_sgl] = getSiraDat(fullFname,h_fig);
    if isempty(vers)
        return
    end

    % get precision of pixel values
    if is_sgl
        prec = 'single';
    else
        prec = 'uint16';
    end
    
    f = fopen(fullFname, 'r');
    if f<0
        disp('Invalid file identifer.')
        ok = 0;
        return;
    end
    fgetl_MASH(f);
%     fgetl(f);

    % Get the exposure time
    cycleTime = fread(f,1,'double');

    % Get movie dimensions
    pixelX = fread(f,1,prec);
    pixelY = fread(f,1,prec);
    frameLen = fread(f,1,prec);
    
    if ~isempty(h_fig) && (strcmp(n,'all') || n==1)
        updateActPan(['MASH smFRET Graphic File Format(*.sira)\n' ...
                      'MASH smFRET Version: ' vers '\n' ...
                      'Cycle time = ' num2str(cycleTime) 's\n' ...
                      'Movie dimensions = ' num2str(pixelX) 'x' ...
                      num2str(pixelY) ' pixels\n' ...
                      'Movie length = ' num2str(frameLen) ' frames'], ...
                      h_fig);
    elseif (strcmp(n,'all') || n==1)
        disp(sprintf(['MASH smFRET Graphic File Format(*.sira)\n' ...
                      'MASH smFRET Version: ' vers '\n' ...
                      'Cycle time = ' num2str(cycleTime) 's\n' ...
                      'Movie dimensions = ' num2str(pixelX) 'x' ...
                      num2str(pixelY) ' pixels\n' ...
                      'Movie length = ' num2str(frameLen) ' frames']));
    end

    % Get cursor position where graphic data begin
    fCurs = ftell(f);
    
    % copy file data in fDat for use in case MATLAB is out of memory
    fDat{1} = fCurs;
    fDat{2}(1) = pixelX; % Width of the movie
    fDat{2}(2) = pixelY; % Height of the movie
    fDat{3} = frameLen; % number total of frames
    
else
    fCurs = fDat{1};
    if iscell(fCurs)
        vers = fCurs{2}{1};
        is_os = fCurs{2}{2};
        is_sgl = fCurs{2}{3};
        if is_sgl
            prec = 'single';
        else
            prec = 'uint16';
        end
        fCurs = fCurs{1};
    end
    pixelX = fDat{2}(1); % Width of the movie
    pixelY = fDat{2}(2); % Height of the movie
    frameLen = fDat{3}; % number total of frames
end

if strcmp(n,'all')
    
    % Get requested graphic data
    if ~exist('f','var')
        f = fopen(fullFname,'r');
        if f<0
            disp('Invalid file identifier.');
            ok = 0;
            return;
        end
    end
    
	if (isMov==0 || isMov==1) && ...
            ~memAlloc(pixelX*pixelY*(frameLen+1)*nbit)
        str = cat(2,'Out of memory: MASH is obligated to load the video ',...
            'one frame at a time to function\nThis will slow down all ',...
            'operations requiring video data, including the creation of ',...
            'time traces.');
        if ~isempty(h_fig)
            setContPan(str,'warning',h_fig);
        else
            disp(sprintf(str));
        end

        [data,ok] = readSira(fullFname,1,fDat,h_fig,0);

        frameCur = data.frameCur;

    else
        if ~islb
            if loading_bar('init',h_fig,100,'Import SIRA video...')
                ok = 0;
                return
            end
            h = guidata(h_fig);
            h.barData.prev_var = h.barData.curr_var;
            guidata(h_fig, h);
        else
            setContPan('Import SIRA video...','',h_fig);
        end
        prevCount = 0;

        if ~exist('vers','var')
            % get MASH-FRET version & reading parameters
            [vers,is_os,is_sgl] = getSiraDat(fullFname,h_fig);
            if isempty(vers)
                return;
            end

            % get precision of pixel values
            if is_sgl
                prec = 'single';
            else
                prec = 'uint16';
            end
        end
    
        % get video pixel data
        fseek(f,fCurs,-1);
        
        if isMov==0
            
            % allocate new memory
            movie = repmat(single(0),pixelY,pixelX,frameLen);
            if is_os
                for l = 1:frameLen
                    movie(:,:,l) = reshape(fread(f,pixelY*pixelX,...
                        [prec '=>single']) + fread(f,1,[prec '=>single']),...
                        [pixelY pixelX]);
                    
                    if l/frameLen>prevCount
                        if ~islb && loading_bar('update', h_fig)
                            ok = 0;
                            return
                        end
                        prevCount = prevCount+1/100;
                    end
                end
            else
                for l = 1:frameLen
                    movie(:,:,l) = reshape(fread(f,pixelY*pixelX,...
                        [prec '=>single']),[pixelY pixelX]);
                    
                    if l/frameLen>prevCount
                        if ~islb && loading_bar('update', h_fig)
                            ok = 0;
                            return
                        end
                        prevCount = prevCount+1/100;
                    end
                end
            end
            frameCur = movie(:,:,1);
            
        else
            
            % re-use previously allocated memory
            h.movie.movie = repmat(single(0),pixelY,pixelX,frameLen);
            if is_os
                for l = 1:frameLen
                    h.movie.movie(:,:,l) = reshape(fread(f,pixelY*pixelX,...
                        [prec '=>single']) + fread(f,1,[prec '=>single']),...
                        [pixelY pixelX]);
                    
                    if l/frameLen>prevCount
                        if ~islb && loading_bar('update', h_fig)
                            ok = 0;
                            return
                        end
                        prevCount = prevCount+1/100;
                    end
                end
                
            else
                for l = 1:frameLen
                    h.movie.movie(:,:,l) = reshape(fread(f,pixelY*pixelX,...
                        [prec '=>single']),[pixelY pixelX]);
                    
                    if l/frameLen>prevCount
                        if ~islb && loading_bar('update', h_fig)
                            ok = 0;
                            return
                        end
                        prevCount = prevCount+1/100;
                    end
                end
            end
            
            guidata(h_fig,h);
            frameCur = h.movie.movie(:,:,1);
        end
        
        if ~islb
            loading_bar('close', h_fig);
        end
	end

else
    if isMov==2
        frameCur = h.movie.movie(:,:,n);
    else
        
        if ~exist('vers','var')
            % get MASH-FRET version & reading parameters
            [vers,is_os,is_sgl] = getSiraDat(fullFname,h_fig);
            if isempty(vers)
                return;
            end

            % get precision of pixel values
            if is_sgl
                prec = 'single';
            else
                prec = 'uint16';
            end
        end
        
        if ~exist('f','var')
            f = fopen(fullFname,'r');
            if f<0
                ok = 0;
                disp('Invalid file identifier.');
                return;
            end
        end

        fseek(f,fCurs,-1);
        fseek(f,((pixelX*pixelY+double(is_os))*2*(1+double(is_sgl))*(n-1)),...
            'cof');
        frameCur = fread(f,(pixelX*pixelY+double(is_os)),[prec '=>single']);
        frameCur = reshape(frameCur(1:end-double(is_os)),[pixelY,pixelX]) - ...
            single(is_os)*frameCur(end);
    end
end

if exist('f','var')
    fclose(f);
end

if exist('vers','var')
    fCurs = {fCurs,{vers,is_os,is_sgl}};
end

data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'frameCur', frameCur, ...
              'movie', movie);
data.fCurs = fCurs;



