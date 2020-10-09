function [data,ok] = readSif(fullFname, n, fDat, h_fig, useMov)
% Read data from bits in a *.sif file. Returns useful movie parameters and
% the image data of the frame specified by the input frame number.
%
% Requires external functions: loading_bar, updateActPan.

% The position where graphic movie data begin is unknown

data = [];
ok = 1;
h =guidata(h_fig);
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

% initializes potentially undefined video data
cycleTime = [];
movie = [];

% first read
if isempty(fDat)
    
    % get sif version
    vers = getSifDat(fullFname,h_fig);
    if isempty(vers)
        return;
    end

    % Recent version (>=4.15065)
    if vers>=415065
        
        f = fopen(fullFname,'r');

        % Get frame rate
        for i=1:2
            fgetl(f); % skip
        end
        textscan(f,'%s',1); % skip
        str = textscan(f,'%s',14);
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
                'Cycle time = ' num2str(cycleTime) 's\n' ...
                'Movie dimensions = ' num2str(pixelX) 'x' ...
                num2str(pixelY) ' pixels\n' ...
                'Movie length = ' num2str(frameLen) ' frames\n'], h_fig);
        else
            fprintf(['\nAndor Video File(*.sif)\n' ...
                'Andor Solis Version N:°' num2str(vers) '\n' ...
                'Cycle time = ' num2str(cycleTime) 's\n' ...
                'Movie dimensions = ' num2str(pixelX) 'x' ...
                num2str(pixelY) ' pixels\n' ...
                'Movie length = ' num2str(frameLen) ' frames\n']);
        end

        if ((pixelX*pixelY)~=d(10) || (d(10)*frameLen)~=d(9))
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

    else % manage older versions with SIFImport
        
        % check for correct compilation of mex file for method SIFImport
        if ~exist('SIFImport')
            setContPan(cat(2,'SIF files of older versions can not be ',...
                'imported: problem with mex compilation.'),'error',h_fig);
            return;
        end
        
        [imgDat,dat] = SIFImport(fullFname);

        movie = imgDat;
        frameLen = size(imgDat, 3); % number total of frames
        cycleTime = dat.exposure; % time delay between each frame
        if strcmp(n,'all')
            frameCur = imgDat(:,:,1); 
        else
            frameCur = imgDat(:,:,n); 
        end
        pixelX = size(imgDat,2); % Width of the movie
        pixelY = size(imgDat,1); % Height of the movie
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

        data = struct('cycleTime', cycleTime, ...
          'pixelY', pixelY, ...
          'pixelX', pixelX, ...
          'frameLen', frameLen, ...
          'fCurs', fCurs, ...
          'frameCur', frameCur, ...
          'movie', movie);
        return;
    end
    
    fDat{1} = fCurs;
    fDat{2} = [pixelX,pixelY];
    fDat{3} = frameLen;

else
    fCurs = fDat{1};
    pixelX = fDat{2}(1); % Width of the movie
    pixelY = fDat{2}(2); % Height of the movie
    frameLen = fDat{3}; % number total of frames
end

% Get requested graphic data
if strcmp(n, 'all')
    if (isMov==0 || isMov==1) && ~memAlloc(pixelX*pixelY*(frameLen+1)*4)
         str = cat(2,'Out of memory: MASH is obligated to load the video ',...
             'one frame at a time to function\nThis will slow down all ',...
             'operations requiring video data, including the creation of ',...
            'time traces.');
        if ~isempty(h_fig)
            pleaseWait('close', h_fig);
            setContPan(str,'warning',h_fig);
        else
            disp(sprintf(str));
        end
        [data,ok] = readSif(fullFname,1,fDat,h_fig,0);
       	frameCur = data.frameCur;
        
    else
        
        intrupt = loading_bar('init',h_fig,100,'Import SIF video...');
        if intrupt
            ok = 0;
            return;
        end
        h = guidata(h_fig);
        h.barData.prev_var = h.barData.curr_var;
        guidata(h_fig, h);
        prevCount = 0;

        % get video pixel data
        if isMov==0
            movie = zeros(pixelY,pixelX,frameLen);
            if ~exist('f','var')
                f = fopen(fullFname,'r');
            end
            for l = 1:frameLen
                movie(:,:,l) = reshape(fread(f,pixelX*pixelY,...
                    'single=>single'),[pixelX,pixelY])';
                
                if l/frameLen>prevCount
                    intrupt = loading_bar('update', h_fig);
                    if intrupt
                        ok = 0;
                        return;
                    end
                    prevCount = prevCount+1/100;
                end
            end
            
            frameCur = movie(:,:,1);
            
        else
            h.movie.movie = zeros(pixelY,pixelX,frameLen);
            if ~exist('f','var')
                f = fopen(fullFname,'r');
            end
            for l = 1:frameLen
                h.movie.movie(:,:,l) = reshape(fread(f,pixelX*pixelY,...
                    'single=>single'),[pixelX,pixelY])';
                
                if l/frameLen>prevCount
                    intrupt = loading_bar('update', h_fig);
                    if intrupt
                        ok = 0;
                        return;
                    end
                    prevCount = prevCount+1/100;
                end
            end
            
            frameCur = h.movie.movie(:,:,1);
            guidata(h_fig,h);
        end

        loading_bar('close', h_fig);
    end
    
else
    if isMov==2
        frameCur = h.movie.movie(:,:,n)'; 
    else
        if ~exist('f','var')
            f = fopen(fullFname,'r');
        end

        % Move the cursor where data for requested video frame begin
        fseek(f,fCurs,-1);
        fseek(f,pixelX*pixelY*4*(n-1),0);

        frameCur = reshape(fread(f,pixelX*pixelY,'single=>single'),...
            [pixelX,pixelY])';
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


function vers = getSifDat(fullFname,h_fig)

vers = [];

% check if the movie can be read and is an Andor camera file
f = fopen(fullFname, 'r');
if f<0
    if ~isempty(h_fig)
        updateActPan(['Could not open the file, no file ' ...
            'loaded.'], h_fig, 'error');
    else
        disp('Could not open the file, no file loaded.');
    end
    fclose(f);
    return;
end
tline = fgetl(f);
if ~isequal(tline,'Andor Technology Multi-Channel File')
    if ~isempty(h_fig)
        updateActPan(['Not an Andor SIF graphic file, no ' ...
            'file loaded.'], h_fig, 'error');
    else
        disp('Not an Andor SIF graphic file, no file loaded.');
    end
    fclose(f);
    return;
end

fgetl(f);
str = textscan(f,'%s',1);
vers = hex2dec(str{1}{1});

fclose(f);

