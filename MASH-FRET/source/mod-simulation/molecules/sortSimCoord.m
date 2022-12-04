function [ferr,coord,errmsg] = sortSimCoord(coord_0, movDim, N_0)
% [coord,errmsg] = sortSimCoord(coord_0, movDim, N_0)
%
% Sort molecule coordinates into donor and acceptor channels, initially contained in a [N-by-2 or 4] array and according to video dimensions.
%
% coord_0: [N-by-2 or 4] initial coordinates matrix
% movDim: [1-by-2] vector containing video dimensions in the x- and y-dimension
% N_0: 0 or the number of molecules defined in the preset file if any
% ferr: failure due to file data
% coord: [N_1-by-4] or [N_0-by-4] sorted coordinates 
% errmsg: error messages upon import failure

% update by MH, 19.12.2019: identify out-of-range coordinates with external function iswithinbound (2) distinguish failure due to file from failure due to too no valid coordinates by returning file error in "ferr" and error messages in "errmsg"
% created by MH, 17.12.2019

% initialize output
ferr = 0;
coord = [];
errmsg = {};

if isempty(coord_0)
    return
end

% get video dimensions and channel limits
res_x = movDim(1);
res_y = movDim(2);
splt = round(res_x/2);

% initialize coordinates
xy1 = []; xy2 = [];

% sort x,y coordinates into channels (according to x)
for col = 1:2:size(coord_0,2) % x-coordinates
    xy1 = [xy1; coord_0(coord_0(:,col)<splt,[col,col+1])];
    xy2 = [xy2; coord_0(coord_0(:,col)>=splt,[col,col+1])];
end

% abort if no coordinates are valid
if isempty(xy1) && isempty(xy2)
    errmsg = cat(2,'No coordinates imported: invalid format.');
    ferr = 1;
    return

% translate coordinates from left to right channel
elseif isempty(xy2) && ~isempty(xy1)
    disp(cat(2,'Coordinates in right channel automatically calculated.'));
    xy2 = [xy1(:,1)+splt,xy1(:,2)];

% translate coordinates from right to left channel
elseif isempty(xy1) && ~isempty(xy2)
    disp(cat(2,'Coordinates in left channel automatically calculated.'));
    xy1 = [xy2(:,1)-splt,xy2(:,2)];
end

% check consistency of sample size in left and right channel
Nl = size(xy1,1);
Nr = size(xy2,1);
if Nl ~= Nr
    errmsg = {cat(2,'No coordinates imported: the number of valid ',...
        'coordinates in the left (',num2str(Nl),') channel is ',...
        'inconsistent with the number in the right (',num2str(Nr),') ',...
        'channel.'),cat(2,'Please modify the video dimensions in panel ',...
        '"Video parameters" or load another coordinates file.')};
    return
end

% discard coordinates out-of video range
coord = [xy1,xy2];
excl = find(~iswithinbounds(res_x,res_y,coord));
for n = excl'
    disp(cat(2,'coordinates ',num2str(coord(n,:)),' excluded (out of ',...
        'video dimensions)'));
end
coord(excl,:) = [];
N = size(coord,1);
if N==0
    errmsg = {cat(2,'No coordinates imported: all coordinates are out of ',...
        'video dimensions.'),cat(2,'Please modify the video dimensions in',...
        ' panel "Video parameters" or load another coordinates file.')};
    return
end

% check consistency of sample size with imported presets
if N_0>0 && N<N_0
    coord = [];
    errmsg = {cat(2,'No coordinates imported: the number of coordinates is',...
        ' not consistent with the number of molecules defined by the ',...
        'presets file.'),cat(2,'Please load another coordinates file or ',...
        'another preset file.')};
    return
elseif N_0>0 && N>N_0
    disp(cat(2,'The number of coordinates is larger than the number ',...
        'of molecules defined by the presets file: ',num2str(N-N_0),...
        ' extra coordinates will be ignored.'));
    xy1 = xy1(1:N_0,:);
    xy2 = xy2(1:N_0,:);
end
