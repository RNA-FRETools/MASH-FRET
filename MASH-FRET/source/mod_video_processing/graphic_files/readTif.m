function [data ok] = readTif(fullFname, n, fDat, h_fig)

data = [];
ok = 1;

% Store useful movie data in hanldes.movie variable
info = imfinfo(fullFname); % information array of .tif file

if isempty(fDat)
    cycleTime = 1; % arbitrary time delay between each frame
    txt = ['arbitrary ' num2str(cycleTime)];
    frameLen = numel(info); % number total of frames
    pixelX = info(1,1).Width; % width of the movie
    pixelY = info(1,1).Height; % height of the movie
    % If the *.tif file has been exported from SIRA, the cycletime is
    % stored in ImageDescription field of structure info.
    if isfield(info, 'ImageDescription')
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
    cycleTime = []; % time delay between each frame
end

if strcmp(n, 'all')
    if ~isempty(h_fig)
        % loading bar parameters-------------------------------------------
        intrupt = loading_bar('init', h_fig, frameLen, ['Import movie ' ...
            'frames from file...']);
        if intrupt
            ok = 0;
            return;
        end

        h = guidata(h_fig);
        h.barData.prev_var = h.barData.curr_var;
        guidata(h_fig, h);
        % -----------------------------------------------------------------
    end

    try
        for i = 1:framesLen
            os = 0;
            if isfield(info, 'ImageDescription')
                strdat = str2num(info(i,1).ImageDescription);
                if size(strdat,2) > 1
                    os = strdat(2); % negative intensity offset
                end
            end
            movie(:,:,i) = double(imread(fullFname, 'Index', i, ...
                'Info', info)) - os;

            % loading bar updating-----------------------------------------
            if ~intrupt && ~isempty(h_fig)
                intrupt = loading_bar('update', h_fig);
            elseif ~isempty(h_fig)
                ok = 0;
                return;
            end
            % -------------------------------------------------------------
        end
        frameCur = movie(:,:,1);
        
        if ~isempty(h_fig)
            loading_bar('close', h_fig);
        end

    catch exception
        if (strcmp(exception.identifier, 'MATLAB:nomem'))
            ok = 0;
            if ~isempty(h_fig)
                loading_bar('close', h_fig);
                updateActPan('Out of memory, no file loaded.', h_fig, ...
                    'error');
            else
                disp('Out of memory, no file loaded.');
            end
            error('MATLAB:nomem', 'Memory too small for file size.');
            
        else
            throw(exception);
        end
    end
else
    os = 0;
    if isfield(info, 'ImageDescription') && ...
            ~isempty(info(n,1).ImageDescription)
        strdat = str2num(info(n,1).ImageDescription);
        if size(strdat,2) > 1
            os = strdat(2); % negative intensity offset
        end
    end
    frameCur = double(imread(fullFname, 'Index', n, 'Info', info)) + os;
    movie = [];
end
 
data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', [], ...
              'frameCur', frameCur, ...
              'movie', movie);
        
