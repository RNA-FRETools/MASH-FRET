function [data ok] = readSira(fullFname, n, fDat, h_fig)
% Read data from bits in a *.sira file. Returns useful movie parameters and
% image data of all movie frames.
%
% Requires external functions: loading_bar, updateActPan, pleaseWait.

data = [];
ok = 1;

f = fopen(fullFname, 'r');
% Get SIRA version
tline = fgetl(f);
is_os = false; % intensity offset for each frame
is_sgl = false; % data written in single precision
if isempty(tline)
    vers = 'older than 1.001';
else
    vers = tline(length(['MASH smFRET exported binary graphic ' ...
        'Version: ']):end);
    if isempty(vers)
        vers = 'older than 1.003.37';
    else
        if str2num(vers(1:end-3)) == 1.003
            subvers = getValueFromStr('1.003.', vers);
            if subvers>=39
                is_os = true;
            end
            if subvers>=41
                is_sgl = true;
            end
        elseif str2num(vers) > 1.003
            is_os = true;
            is_sgl = true;
        end
    end
end


if is_sgl
    prec = 'single';
else
    prec = 'uint16';
end

if isempty(fDat)

    % Get the frame rate
    cycleTime = fread(f,1,'double');

    % Get movie dimensions
    pixelX = fread(f,1,prec);
    pixelY = fread(f,1,prec);
    frameLen = fread(f,1,prec);
    
    if ~isempty(h_fig) && (strcmp(n,'all') || n==1)
        updateActPan(['MASH smFRET Graphic File Format(*.sira)\n' ...
                      'MASH smFRET Version: ' vers '\n' ...
                      'Cycle time = ' num2str(cycleTime) 's-1\n' ...
                      'Movie dimensions = ' num2str(pixelX) 'x' ...
                      num2str(pixelY) ' pixels\n' ...
                      'Movie length = ' num2str(frameLen) ' frames'], ...
                      h_fig);
    elseif (strcmp(n,'all') || n==1)
        disp(sprintf(['MASH smFRET Graphic File Format(*.sira)\n' ...
                      'MASH smFRET Version: ' vers '\n' ...
                      'Cycle time = ' num2str(cycleTime) 's-1\n' ...
                      'Movie dimensions = ' num2str(pixelX) 'x' ...
                      num2str(pixelY) ' pixels\n' ...
                      'Movie length = ' num2str(frameLen) ' frames']));
    end

    % Get cursor position where graphic data begin
    fCurs = ftell(f);

    % Get requested graphic data
    fseek(f, fCurs, -1);
    
    if strcmp(n, 'all')
        
        if ~isempty(h_fig)
            pleaseWait('start', h_fig);
        else
            disp('Please wait ...');
        end

        % Get image data of each movie frame
        try
            if is_os
                movie = fread(f, frameLen*(1+pixelY*pixelX), ...
                    [prec '=>single']);
                id = (pixelY*pixelX+1):(pixelY*pixelX+1):numel(movie);
                os = single(movie(id));
                movie(id) = [];
                movie = reshape(movie, [pixelY pixelX frameLen]);
                for i = 1:frameLen
                    movie(:,:,i) = movie(:,:,i) - os(i);
                end
            else
                movie = reshape(fread(f, frameLen*pixelY*pixelX, ...
                    [prec '=>single']), [pixelY pixelX frameLen]);
                frameCur = movie(:,:,1);
                if ~isempty(h_fig)
                    pleaseWait('close', h_fig);
                end
            end

        catch exception
            if (strcmp(exception.identifier, 'MATLAB:nomem'))
                ok = 0;
                fclose(f);
                if ~isempty(h_fig)
                    pleaseWait('close', h_fig);
                    updateActPan('Out of memory, no file loaded.', ...
                        h_fig, 'error');
                else
                    disp('Error: out of memory, no file loaded.');
                end

                error('MATLAB:nomem', 'Memory too small for file size.');

            else
                throw(exception);
            end
        end
        
    else
        fseek(f, ((pixelX*pixelY+single(is_os))*2*(1+ ...
            single(is_sgl))*(n-1)),'cof');
        frameCur = fread(f, (pixelX*pixelY+double(is_os)), [prec ...
            '=>single']);
        frameCur = reshape(frameCur(1:end-double(is_os)), ...
            [pixelY pixelX]) - single(is_os)*frameCur(end);
        movie = [];
    end
    
    fclose(f);
    
else
    fseek(f, fDat{1}, -1);
    s = [fDat{2}(2) fDat{2}(1)]; % [y,x]
    frameLen = fDat{3};
    
    if strcmp(n, 'all')
        if ~isempty(h_fig)
            pleaseWait('start', h_fig);
        else
            disp('Please wait ...');
        end

        % Get image data of each movie frame
        try
            if is_os
                movie = fread(f, frameLen*(1+prod(s)), [prec '=>single']);
                os = single(movie((prod(s)+1):(prod(s)+1):end));
                movie((prod(s)+1):(prod(s)+1):end) = [];
                movie = reshape(movie,[s(:,1:2) frameLen]);
                for i = 1:frameLen
                    movie(:,:,i) = movie(:,:,i) - os(i);
                end
            else
                movie = reshape(fread(f, frameLen*prod(s), [prec ...
                    '=>single']), [s(:,1:2) frameLen]);
                frameCur = movie(:,:,1);
            end
            if ~isempty(h_fig)
                pleaseWait('close', h_fig);
            end

        catch exception
            if (strcmp(exception.identifier, 'MATLAB:nomem'))
                ok = 0;
                fclose(f);
                if ~isempty(h_fig)
                    pleaseWait('close', h_fig);
                    updateActPan('Out of memory, no file loaded.', h_fig);
                else
                    disp('Error: ut of memory, no file loaded.');
                end

                error('MATLAB:nomem', 'Memory too small for file size.');

            else
                throw(exception);
            end
        end
        
    else
        fseek(f, ((prod(s)+double(is_os))*2*(1+double(is_sgl))* ...
            (n-1)),'cof');
        frameCur = fread(f, (prod(s)+double(is_os)), [prec '=>single']);
        frameCur = reshape(frameCur(1:end-double(is_os)), s) - ...
            single(is_os)*frameCur(end);
        movie = [];
    end
    
    frameLen = fDat{3}; % number total of frames
    cycleTime = []; % time delay between each frame
    pixelX = s(2); % Width of the movie
    pixelY = s(1); % Height of the movie
    fCurs = fDat{1};
    
    fclose(f);
end

data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', fCurs, ...
              'frameCur', frameCur, ...
              'movie', movie);


