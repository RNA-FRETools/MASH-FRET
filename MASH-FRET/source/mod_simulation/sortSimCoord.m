function [coord,errmsg] = sortSimCoord(coord_0, movDim, N_0)
% coord = sortSimCoord(coord_0, movDim, N_0)
%
% Sort molecule coordinates into donor and acceptor channels, initially contained in a [N-by-2 or 4] array and according to video dimensions.
%
% coord_0: [N-by-2 or 4] initial coordinates matrix
% movDim: [1-by-2] vector containing video dimensions in the x- and y-dimension
% N_0: 0 or the number of molecules defined in the preset file if any
% coord: [N_1-by-4] or [N_0-by-4] sorted coordinates 

% created by MH, 17.12.2019

% initialize output
coord = [];
errmsg = {};

% get video dimensions and channel limits
res_x = movDim(1);
res_y = movDim(2);
splt = round(res_x/2);

% initialize coordinates
x1 = []; y1 = []; x2 = []; y2 = [];

% sort x,y coordinates into channels (according to x)
for col = 1:2:size(coord_0,2) % x-coordinates
    idx1 = (coord_0(:,col)>0 & coord_0(:,col)<splt);
    idx2 = (coord_0(:,col)>=splt & coord_0(:,col)<res_x);
    x1 = [x1; coord_0(idx1,col)];
    y1 = [y1; coord_0(idx1,col+1)];
    x2 = [x2; coord_0(idx2,col)];
    y2 = [y2; coord_0(idx2,col+1)];
end

% discard coordinates with out-of-range y
idy1 = (y1>0 & y1<res_y);
idy2 = (y2>0 & y2<res_y);
y1 = y1(idy1);
x1 = x1(idy1);
y2 = y2(idy2);
x2 = x2(idy2);

% abort if no coordinates are valid
if isempty(x1) && isempty(x2)
    errmsg = {cat(2,'No coordinates imported: all coordinates are out of ',...
        'video dimensions.'),cat(2,'Please modify the video dimensions in',...
        ' panel "Video parameters" or load another coordinates file.')};
    return

% translate coordinates from left to right channel
elseif isempty(x2) && ~isempty(x1)
    disp(cat(2,'Coordinates in right channel automatically calculated.'));
    x2 = x1+round(res_x/2);
    y2 = y1;

% translate coordinates from right to left channel
elseif isempty(x1) && ~isempty(x2)
    disp(cat(2,'Coordinates in left channel automatically calculated.'));
    x1 = x2-round(res_x/2);
    y1 = y2;
end

% check consistency of sample size in left and right channel
Nl = numel(x1);
Nr = numel(x2);
if Nl ~= Nr
    errmsg = {cat(2,'No coordinates imported: the number of valid ',...
        'coordinates in the left (',num2str(Nl),') channel is ',...
        'inconsistent with the number in the right (',num2str(Nr),') ',...
        'channel.'),cat(2,'Please modify the video dimensions in panel ',...
        '"Video parameters" or load another coordinates file.')};
    return
end

% check consistency of sample size with imported presets
if N_0>0 && Nl<N_0
    errmsg = {cat(2,'No coordinates imported: the number of coordinates is',...
        ' not consistent with the number of molecules defined by the ',...
        'presets file.'),cat(2,'Please load another coordinates file or ',...
        'another preset file.')};
    return

elseif N_0>0 && Nl>N_0
    disp(cat(2,'The number of coordinates is larger than the number ',...
        'of molecules defined by the presets file: ',num2str(Nl-N_0),...
        ' extra coordinates will be ignored.'));
    x1 = x1(1:N_0,1);
    y1 = y1(1:N_0,1);
    x2 = x2(1:N_0,1);
    y2 = y2(1:N_0,1);
end

% return sorted coordinates
coord = [x1 y1 x2 y2];
