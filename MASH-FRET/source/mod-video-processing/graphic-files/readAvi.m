function [data ok] = readAvi(fullFname, n, h_fig)

data = [];
ok = 1;

if ~isempty(h_fig)
    pleaseWait('start', h_fig);
else
    disp('Please wait ...');
end

v = VideoReader(fullFname);
movie = [];
while hasFrame(v)
    img = readFrame(v);
    img = uint16(sum(img,3));
    movie = cat(3,movie,img);
end

if ~isempty(h_fig)
    pleaseWait('close', h_fig);
end

% Store useful movie data in hanldes.movie variable
frameLen = size(movie,3); % number total of frames
cycleTime = 1/v.FrameRate; % time delay between each frame
pixelX = size(movie, 2); % Width of the movie
pixelY = size(movie, 1); % Height of the movie

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
          
          