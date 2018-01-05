function [data ok] = readSpe(fullFname, n, h_fig)

data = [];
ok = 1;

if ~isempty(h_fig)
    pleaseWait('start', h_fig);
else
    disp('Please wait ...');
end

[pname,o,o] = fileparts(fullFname);

cd(pname);
[A, info] = SPEImport(fullFname);

if ~isempty(h_fig)
    pleaseWait('close', h_fig);
end

% Store useful movie data in hanldes.movie variable
movie = double(A);
frameLen = size(A, 3); % number total of frames
cycleTime = info.exposure; % time delay between each frame
pixelX = size(A, 2); % Width of the movie
pixelY = size(A, 1); % Height of the movie

if strcmp(n, 'all')
    frameCur = double(movie(:,:,1)); % image data of input frame
else
    frameCur = double(movie(:,:,n)); 
end

data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', [], ...
              'frameCur', frameCur, ...
              'movie', movie);
          
          