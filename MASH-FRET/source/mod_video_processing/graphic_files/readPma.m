function [data,ok] = readPma(fullFname, n, fDat, h_fig)
% Read data from bits in a *.sira file. Returns useful movie parameters and
% image data of all movie frames.
%
% Requires external functions: loading_bar, updateActPan.

% defaults
data = [];
cycleTime = []; % time delay between each frame
movie = [];
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
    answer = inputdlg({'frame rate:','X resolution:','Y resolution:'}, ...
        'Movie data:',1,{'1','512','512'});
    
    cycleTime = str2num(answer{1});
    pixelX = str2num(answer{2});
    pixelY = str2num(answer{3});
 
    fseek(f, 0, 1);
    frameLen = (ftell(f)- 4)/(pixelX*pixelY + 2);
    
    % Move the cursor through the file
    fseek(f, 4, -1);

    % Get cursor position where graphic data begin
    fCurs = ftell(f);

    if ~isempty(h_fig)
        updateActPan(['PMA binary File(*.pma)\n' ...
            'Cycle time = ' answer{1} 's\n' ...
            'Movie dimensions = ' answer{2} 'x' answer{3} ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n'], h_fig);
    else
        fprintf(['\nPMA binary File(*.pma)\n' ...
            'Cycle time = ' answer{1} 's\n' ...
            'Movie dimensions = ' answer{2} 'x' answer{3} ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n'])
    end
else
    fCurs = fDat{1};
    pixelX = fDat{2}(1);
    pixelY = fDat{2}(2);
    frameLen = fDat{3};
end

if strcmp(n, 'all')

    if isMov==0 && ~memAlloc(4*frameLen*pixelX*pixelY)
        str = cat(2,'Out of memory: MASH is obligated to load the video ',...
            'one frame at a time to function\nThis will slow down all ',...
            'operations requiring video data, including the creation of ',...
            'time traces.');
        setContPan(str,'warning',h_fig);

        [data,ok] = readPma(fullFname,1,fDat,h_fig);
        frameCur = data.frameCur;

    else

        intrupt = loading_bar('init',h_fig,100,'Import PMA video...');
        if intrupt
            ok = 0;
            return;
        end
        h = guidata(h_fig);
        h.barData.prev_var = h.barData.curr_var;
        guidata(h_fig, h);
        prevCount = 0;
        
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
                
                if i/frameLen>prevCount
                    intrupt = loading_bar('update', h_fig);
                    if intrupt
                        ok = 0;
                        return;
                    end
                    prevCount = prevCount+1/100;
                end
            end
            frameCur = movie(:,:,1); % Get image data of the input frame
        else
            h.movie.movie = zeros([pixelY pixelX frameLen]);
            for i = 1:frameLen
                fseek(f, 2*i + pixelX*pixelY*(i-1), 0);
                h.movie.movie(:,:,i) = reshape(fread(f, pixelX*pixelY, ...
                    'uint8=>single'), [pixelX pixelY])';
                
                if i/frameLen>prevCount
                    intrupt = loading_bar('update', h_fig);
                    if intrupt
                        ok = 0;
                        return;
                    end
                    prevCount = prevCount+1/100;
                end
            end
            guidata(h_fig,h);
            frameCur = h.movi.movie(:,:,1); % Get image data of the input frame
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
        fseek(f, 2*n + pixelX*pixelY*(n-1), 0);
        frameCur = reshape(fread(f, pixelX*pixelY, 'uint8=>single'), ...
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

