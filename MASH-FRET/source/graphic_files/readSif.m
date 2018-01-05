function [data ok] = readSif(fullFname, n, fDat, h_fig)
% Read data from bits in a *.sif file. Returns useful movie parameters and
% the image data of the frame specified by the input frame number.
%
% Requires external functions: loading_bar, updateActPan.

% The position where graphic movie data begin is unknown

data = [];
ok = 1;

f = fopen(fullFname, 'r');

if isempty(fDat)

    % Get Andor Solis version
    for i = 1:2
        str = fgetl(f);
    end
    str = textscan(f, '%s', 1);
    vers = hex2dec(str{1}{1});
    
    % Recent version (>= 4.15065)
    if str2num(str{1}{1}) >= 65559
        
        % Get frame rate
        str = textscan(f, '%s', 14);
        cycleTime = str2num(str{1}{14});

        % Move the cursor through the file
        frewind(f);
        m = 0;
        while m < 2 && ~feof(f)
            str1 = fgetl(f);
            if strfind(str1, 'Pixel number')
                m = m+1;
            end
        end
        
        if feof(f)
            if ~isempty(h_fig)
               updateActPan('Impossible to extract pixel numbers.', ...
                   h_fig, 'error');
            else
                disp('Impossible to extract pixel numbers.');
            end
           fclose(f);
           ok = 0;
           return;
        end
        
        str2 = fgetl(f);
        str = [str1 ' ' str2];
        str = textscan(str, '%s', 17);
        c = str{1};
        for i = 3:size(c,1)
            d(i,1) = str2num(c{i,1});
        end
        
        % Get movie dimensions
        imageArea = [d(3) d(6) d(8);d(6) d(4) d(7)];
        frameArea = [d(12) d(15);d(14) d(13)];
        frameBins = [d(17) d(16)];
        s = (1 + diff(frameArea))./frameBins; % [x y]
        pixelY = s(2);
        pixelX = s(1);
        frameLen = 1 + diff(imageArea(5:6));
        
        % Print movie parameters
        if ~isempty(h_fig)
            updateActPan(['Andor Video File(*.sif)\n' ...
                'Andor Solis Version N:°' num2str(vers) '\n' ...
                'Cycle time = ' num2str(cycleTime) 's-1\n' ...
                'Movie dimensions = ' num2str(pixelX) 'x' ...
                num2str(pixelY) ' pixels\n' ...
                'Movie length = ' num2str(frameLen) ' frames\n'], h_fig);
        else
            fprintf(['\nAndor Video File(*.sif)\n' ...
                'Andor Solis Version N:°' num2str(vers) '\n' ...
                'Cycle time = ' num2str(cycleTime) 's-1\n' ...
                'Movie dimensions = ' num2str(pixelX) 'x' ...
                num2str(pixelY) ' pixels\n' ...
                'Movie length = ' num2str(frameLen) ' frames\n']);
        end

        if (pixelX * pixelY ~= d(10) || d(10)*frameLen ~= d(9))
            if ~isempty(h_fig)
                updateActPan('Inconsistent image header.', h_fig, 'error');
            else
                disp('Inconsistent image header.');
            end
            fclose(f);
            ok = 0;
            return;
        end

        % Move the cursor through the file
        for i = 1:(frameLen+1)
            fgetl(f);
        end

        % Get cursor position where graphic data begin
        fCurs = ftell(f);

        % Get requested graphic data
        fseek(f, fCurs, -1);

        if strcmp(n, 'all')
            
            if ~isempty(h_fig)
                % loading bar parameters-----------------------------------
                intrupt = loading_bar('init', h_fig, frameLen, ...
                    'Import movie frames from file...');
                if intrupt
                    ok = 0;
                    return;
                end

                h = guidata(h_fig);
                h.barData.prev_var = h.barData.curr_var;
                guidata(h_fig, h);
                % ---------------------------------------------------------
            end

            fseek(f, (pixelX*pixelY), -1);

            try
                movie1 = reshape(fread(f, frameLen*pixelX*pixelY, ...
                    'single=>single'), [pixelX pixelY frameLen]);

                for ii = 1:z
                    movie(:,:,ii) = movie1(:,:,ii)';
                    % loading bar updating---------------------------------
                    if ~intrupt && ~isempty(h_fig)
                        intrupt = loading_bar('update', h_fig);
                    elseif ~isempty(h_fig)
                        ok = 0;
                        fclose(f);
                        return;
                    end
                    % -----------------------------------------------------
                end
                frameCur = movie(:,:,h.movie.frameCurNb);
                if ~isempty(h_fig)
                    loading_bar('close', h_fig);
                end

            catch exception
                if (strcmp(exception.identifier, 'MATLAB:nomem'))
                    ok = 0;
                    fclose(f);
                    if ~isempty(h_fig)
                        loading_bar('close', h_fig);
                        updateActPan('Out of memory, no file loaded.', ...
                            h_fig, 'error');
                    else
                        disp('Out of memory, no file loaded.');
                    end

                    error('MATLAB:nomem', ...
                        'Memory too small for file size.');
                else
                    throw(exception);
                end
            end
            
        else
            fseek(f, (pixelX*pixelY*4*(n - 1)), 0);
            frameCur = reshape(fread(f, (pixelX * pixelY), ...
                'single=>single'), [pixelX pixelY]);
            movie = [];
        end
        
        fclose(f);
        
    else
        fclose(f);
        
        if ~isempty(h_fig)
            h = guidata(h_fig);
        end
        if ~exist('h','var') || (exist('h','var') && ...
                (~isfield(h.movie, 'movie') || ...
                (isfield(h.movie, 'movie') && isempty(h.movie.movie))))
            
            [imgDat, dat] = SIFImport([h.movie.path h.movie.file]);
            
            movie = imgDat;
            frameLen = size(imgDat, 3); % number total of frames
            cycleTime = dat.exposure; % time delay between each frame
            frameCur = imgDat(:, :, n)'; 
            pixelX = size(imgDat, 2); % Width of the movie
            pixelY = size(imgDat, 1); % Height of the movie
            fCurs = [];
            
            % Print movie parameters
            if ~isempty(h_fig)
                updateActPan(['Andor Video File(*.sif)\n' ...
                    'Andor Solis Version N:°' num2str(vers) '\n' ...
                    'Cycle time = ' num2str(cycleTime) 's-1\n' ...
                    'Movie dimensions = ' num2str(pixelX) 'x' ...
                    num2str(pixelY) ' pixels\n' ...
                    'Movie length = ' num2str(frameLen) ...
                    ' frames\n'], h_fig);
            else
                fprintf(['\nAndor Video File(*.sif)\n' ...
                    'Andor Solis Version N:°' num2str(vers) '\n' ...
                    'Cycle time = ' num2str(cycleTime) 's-1\n' ...
                    'Movie dimensions = ' num2str(pixelX) 'x' ...
                    num2str(pixelY) ' pixels\n' ...
                    'Movie length = ' num2str(frameLen) ...
                    ' frames\n']);
            end

        else
            frameCur = h.movie.movie(:,:,n)'; 
            movie = h.movie.movie;
            frameLen = h.movie.framesTot; % number total of frames
            cycleTime = h.movie.cyctime; % time delay between each frame
            pixelX = h.movie.pixelX; % Width of the movie
            pixelY = h.movie.pixelY; % Height of the movie
            fCurs = [];
        end
    end

else
    if ~isempty(h_fig)
        h = guidata(h_fig);
    end
    if ~exist('h','var') || (exist('h','var') && ...
            (isfield(h.movie, 'movie') && ~isempty(h.movie.movie)))
        fclose(f);
        movie = [];
        frameLen = []; % number total of frames
        cycleTime = []; % time delay between each frame
        frameCur = h.movie.movie(:,:,n)'; 
        pixelX = []; % Width of the movie
        pixelY = []; % Height of the movie
        fCurs = [];
        
    else
        % Move the cursor where the graphic data begin
        fseek(f, fDat{1}, -1);
        s = fDat{2}; % [x y]

        % Get image data of the input (displayed) frame
        fseek(f, prod(s)*4*(n - 1), 0);

        frameCur = (reshape(fread(f, prod(s), 'single=>single'), s))';
        movie = [];
        frameLen = []; % number total of frames
        cycleTime = []; % time delay between each frame
        pixelX = []; % Width of the movie
        pixelY = []; % Height of the movie
        fCurs = [];

        fclose(f);
    end
end

data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', fCurs, ...
              'frameCur', frameCur, ...
              'movie', movie);


