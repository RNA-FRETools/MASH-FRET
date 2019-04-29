function [data,ok] = getFrames(fullFname, n, param, h_fig)

    % read video data and parameters from file
    [o,o,fext] = fileparts(fullFname);
    
    if strcmp(fext,'.coord') || strcmp(fext,'.spots')
        fext = '.crd';
    end
    
    switch lower(fext)
        case '.sira'
            % Create a structure containing data
            [data,ok] = readSira(fullFname, n, param, h_fig);
            return;
            
        case '.sif'
            % Create a structure containing data
            [data,ok] = readSif(fullFname, n, param, h_fig);
            return;
            
        case '.tif'
            % Create a structure containing data
            [data,ok] = readTif(fullFname, n, param, h_fig);
            return;
            
        case '.gif'
            % Create a structure containing data
            [data,ok] = readGif(fullFname, n, h_fig);
            return;
          
        case '.png'
            % Create a structure containing data
            [data,ok] = readPng(fullFname, n, param, h_fig);
            return;
            
        case '.pma'
            % Create a structure containing data
            [data,ok] = readPma(fullFname, n, param, h_fig);
            return;
            
        case '.spe'
            % Create a structure containing data
            [data,ok] = readSpe(fullFname, n, h_fig);
            return;
            
        case '.crd'
            % Create a structure containing data
            [data,ok] = readCrd(fullFname, h_fig);
            return;
            
        case '.avi'
            % Create a structure containing data
            [data,ok] = readAvi(fullFname, n, h_fig);
             return;
            
        otherwise
            updateActPan('File format not recognized.',h_fig,'error');
            ok = 0;
            data = [];
            return;
    end
end

