function [data ok] = getFrames(fullFname, n, param, h_fig)
    
    ok = 1;
    data = [];
    [o,o,fext] = fileparts(fullFname);
    
    if strcmp(fext,'.coord') || strcmp(fext,'.spots')
        fext = '.crd';
    end
    
    switch lower(fext)
        case '.sira'
            
            % check if the movie can be read and is from SIRA
            f = fopen(fullFname, 'r');
            if f < 0
                if ~isempty(h_fig)
                    updateActPan( ...
                        'Could not open the file, no file loaded.', ...
                        h_fig, 'error');
                else
                    disp(['Error: could not open the file, no file ' ...
                        'loaded.']);
                end
                fclose(f);
                ok = 0;
                return;
            end
            tline = fgetl(f);
            if isempty(strfind(tline,'SIRA exported binary graphic'))
                if isempty(strfind(tline, ...
                        'MASH smFRET exported binary graphic'))
                    if ~isempty(h_fig)
                        updateActPan(['Not a SIRA exported graphic ' ...
                            'file, no file loaded.'], h_fig, 'error');
                    else
                        disp(['Not a SIRA exported graphic file, no ' ...
                            'file loaded.']);
                    end
                    ok = 0;
                    fclose(f);
                    return;
                end
            end
            fclose(f);
            
            % Create a structure containing data
            [data ok] = readSira(fullFname, n, param, h_fig);
            if ~ok
                fclose(f);
                ok = 0;
                return;
            end
            
        case '.sif'
            
            % check if the movie can be read and is an Andor camera file
            f = fopen(fullFname, 'r');
            if f < 0
                if ~isempty(h_fig)
                    updateActPan(['Could not open the file, no file ' ...
                        'loaded.'], h_fig, 'error');
                else
                    disp('Could not open the file, no file loaded.');
                end
                fclose(f);
                ok = 0;
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
                ok = 0;
                return;
            end
            fclose(f);
            
            % Create a structure containing data
            [data ok] = readSif(fullFname, n, param, h_fig);
            if ~ok
                return;
            end
            
        case '.tif'
            
            % Create a structure containing data
            [data ok] = readTif(fullFname, n, param, h_fig);
            
        case '.gif'
            
            % Create a structure containing data
            [data ok] = readGif(fullFname, n, h_fig);
          
        case '.png'
            
            % Create a structure containing data
            [data ok] = readPng(fullFname, n, param, h_fig);
            
        case '.pma'

            % Create a structure containing data
            [data ok] = readPma(fullFname, n, param, h_fig);
            
        case '.spe'
            
            % Create a structure containing data
            if ~isempty(h_fig)
                h = guidata(h_fig);
                if isfield(h, 'movie') && isfield(h.movie, 'movie') && ...
                    ~isempty(h.movie.movie)
                    if ~strcmp(n, 'all')
                        n = 1;
                    end
                    data.frameCur = double(h.movie.movie(:, :, n));
                    data.movie = [];
                    data.frameLen = []; % number total of frames
                    data.cycleTime = []; % time delay between each frame
                    data.pixelX = []; % Width of the movie
                    data.pixelY = []; % Height of the movie
                    data.fCurs = [];
                else
                    [data ok] = readSpe(fullFname, n, h_fig);
                end
            else
                [data ok] = readSpe(fullFname, n, h_fig);
            end
            
        case '.crd'
            % Create a structure containing data
            if ~isempty(h_fig)
                h = guidata(h_fig);
                if isfield(h, 'movie') && isfield(h.movie, 'movie') && ...
                        ~isempty(h.movie.movie)
                    data.frameCur = double(h.movie.movie);
                    data.movie = h.movie.movie;
                    data.frameLen = h.movie.framesTot; % number total of frames
                    data.cycleTime = h.movie.cyctime; % time delay between each frame
                    data.pixelX = h.movie.pixelX; % Width of the movie
                    data.pixelY = h.movie.pixelY; % Height of the movie
                    data.fCurs = h.movie.speCursor;
                else
                    [data ok] = readCrd(fullFname, h_fig);
                end
            else
                [data ok] = readCrd(fullFname, h_fig);
            end
        case '.avi'
            
            % Create a structure containing data
            if ~isempty(h_fig)
                h = guidata(h_fig);
                if isfield(h, 'movie') && isfield(h.movie, 'movie') && ...
                    ~isempty(h.movie.movie)
                    data.frameCur = double(h.movie.movie(:, :, n));
                    data.movie = h.movie.movie;
                    data.frameLen = h.movie.framesTot; % number total of frames
                    data.cycleTime = h.movie.cyctime; % time delay between each frame
                    data.pixelX = h.movie.pixelX; % Width of the movie
                    data.pixelY = h.movie.pixelY; % Height of the movie
                    data.fCurs = h.movie.speCursor;
                else
                    [data ok] = readAvi(fullFname, n, h_fig);
                end
            else
                [data ok] = readAvi(fullFname, n, h_fig);
            end
            
        otherwise
            if ~isempty(h_fig)
                updateActPan('File format not recognized.', h_fig, ...
                    'error');
            else
                disp('File format not recognized.');
            end
            ok = 0;
            return;
    end
end

