function [data ok] = readPma(fullFname, n, fDat, h_fig)
% Read data from bits in a *.sira file. Returns useful movie parameters and
% image data of all movie frames.
%
% Requires external functions: loading_bar, updateActPan, pleaseWait.

data = [];
ok = 1;

f = fopen(fullFname, 'r');
if f < 0
    if ~isempty(h_fig)
        updateActPan('Could not open the file, no file loaded.', h_fig, ...
            'error');
    else
        disp('Could not open the file, no file loaded.');
    end
    fclose(f);
    ok = 0;
    return;
end

if isempty(fDat) 
    
    % Get the movie dimensions
    answer = inputdlg({'frame rate:','X resolution:','Y resolution:'}, ...
        'Movie data:',1,{'1','512','512'});
    cycleTime = str2num(answer{1});
    pixelX = str2num(answer{2});
    pixelY = str2num(answer{3});
 
    fseek(f, 0, 1);
    frameLen = (ftell(f)- 4)/(pixelX*pixelY + 2);

    if ~isempty(h_fig)
        updateActPan(['PMA binary File(*.pma)\n' ...
            'Cycle time = ' answer{1} 's-1\n' ...
            'Movie dimensions = ' answer{2} 'x' answer{3} ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n'], h_fig);
    else
        fprintf(['\nPMA binary File(*.pma)\n' ...
            'Cycle time = ' answer{1} 's-1\n' ...
            'Movie dimensions = ' answer{2} 'x' answer{3} ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n'])
    end
    
    % Move the cursor through the file
    fseek(f, 4, -1);
    
    % Get cursor position where graphic data begin
    fCurs = ftell(f);
    
    if strcmp(n, 'all')
        if ~isempty(h_fig)
            pleaseWait('start', h_fig);
        else
            disp('Please wait ...');
        end
        movie = uint8(zeros([pixelY pixelX framesTot], 'uint8'));
        % Get image data of each movie frame
        try
            for i = 1:frameLen
                fseek(f, 2*i + pixelX*pixelY*(i-1), 0);
                movie(:,:,i) = uint8(reshape(fread(f, pixelX*pixelY, ...
                    'uint8'), [pixelX pixelY]))';          
            end
            frameCur = movie(:,:,1); % Get image data of the input frame

        catch exception
            if (strcmp(exception.identifier, 'MATLAB:nomem'))
                ok = 0;
                fclose(f);
                if ~isempty(h_fig)
                    pleaseWait('close', h_fig);
                    updateActPan('Out of memory, no file loaded.', ...
                        h_fig, 'error');
                else
                    disp('Out of memory, no file loaded.');
                end

                error('MATLAB:nomem', 'Memory too small for file size.');
            else
                throw(exception);
            end
        end
        
    else
        fseek(f, 2*n + pixelX*pixelY*(n-1), 0);
        frameCur = reshape(fread(f, pixelX*pixelY, 'uint8'), ...
            [pixelX pixelY])';
        movie = [];
    end
    
else
    fseek(f, fDat{1}, -1);
    s = fDat{2};
    frameLen = fDat{3};
    
    if strcmp(n, 'all')
        if ~isempty(h_fig)
            pleaseWait('start', h_fig);
        else
            disp('Please wait ...');
        end
        movie = zeros([s(2) s(1) frameLen], 'uint8');
        % Get image data of each movie frame
        try
            for i = 1:frameLen
                fseek(f, 2*i + prod(s)*(i-1), 0);
                movie(:,:,i) = reshape(fread(f, prod(s), 'uint8'), s)';          
            end
            frameCur = movie(:,:,1); % Get image data of the input frame

        catch exception
            if (strcmp(exception.identifier, 'MATLAB:nomem'))
                ok = 0;
                fclose(f);
                if ~isempty(h_fig)
                    pleaseWait('close', h_fig);
                    updateActPan('Out of memory, no file loaded.', ...
                        h_fig, 'error');
                else
                    disp('Out of memory, no file loaded.');
                end

                error('MATLAB:nomem', 'Memory too small for file size.');
            else
                throw(exception);
            end
        end
        
    else
        fseek(f, 2*n + prod(s)*(n-1), 0);
        frameCur = reshape(fread(f, prod(s), 'uint8'), s)';
        movie = [];
    end
    
    frameLen = []; % number total of frames
    cycleTime = []; % time delay between each frame
    pixelX = []; % Width of the movie
    pixelY = []; % Height of the movie
    fCurs = [];
    
end

fclose(f);

data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', fCurs, ...
              'frameCur', frameCur, ...
              'movie', movie);

