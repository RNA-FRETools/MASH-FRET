function [data,ok] = readPng(fullFname, n, fDat, h_fig)

% Last update: 20.4.2019 by Mélodie Hadzic
% >> fix error occuring when loading background image for simulation

data = [];
ok = 1;

% Store useful movie data in hanldes.movie variable
info = imfinfo(fullFname); % information array of .tif file

if isempty(fDat)
    frameLen = numel(info); % number total of frames
    pixelX = info(1,1).Width; % width of the movie
    pixelY = info(1,1).Height; % height of the movie
    % If the *.tif file has been exported from SIRA, the cycletime is
    % stored in ImageDescription field of structure info.
    cycleTime = 1; % arbitrary time delay between each frame
    max_img = 1;
    min_img = 0;
    max_bit = 1;
    if isfield(info, 'Description')
        % time delay between each frame
        descr = info(1,1).Description;
        if isempty(descr) || (numel(str2num(descr))==1 && ...
                isnan(str2num(descr)))
            txt = ['arbitrary ' num2str(cycleTime)];
        else
            descr = str2num(descr);
            cycleTime = descr(1);
            if size(descr,2)==3
                max_img = descr(2);
                min_img = descr(3);
                max_bit = 65535;
            end
            txt = num2str(cycleTime);
        end
    else
        txt = ['arbitrary ' num2str(cycleTime)];
    end

    if ~isempty(h_fig)
        updateActPan(['Portable Network Graphics(*.png)\n' ...
            'Cycle time = ' txt 's-1\n' ...
            'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
            ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n'], h_fig);
    else
        fprintf(['\nPortable Network Graphics(*.png)\n' ...
            'Cycle time = ' txt 's-1\n' ...
            'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
            ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n']);
    end
else
    max_img = 1;
    min_img = 0;
    max_bit = 1;
    if isfield(info, 'Description')
        % time delay between each frame
        descr = info(1,1).Description; 
        if ~isnan(str2num(descr))
            descr = str2num(descr);
            if size(descr,2) == 3
                max_img = descr(2);
                min_img = descr(3);
                max_bit = 65535;
            end
        end
    end
    pixelX = fDat{2}(1);
    pixelY = fDat{2}(2);
    frameLen = fDat{3};
    cycleTime = []; % time delay between each frame
    fCurs = [];
end

frameCur = round(min_img+(double(imread(fullFname))/max_bit)* ...
    (max_img-min_img));
movie = [];
 
data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', [], ...
              'frameCur', frameCur, ...
              'movie', movie);
        
