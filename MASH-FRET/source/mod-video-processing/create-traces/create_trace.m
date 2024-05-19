function [coord,trace,err] = create_trace(coord, aDim, nPix, fDat,varargin)
% [coord,trace,err] = create_trace(coord, aDim, nPix, fDat)
% [coord,trace,err] = create_trace(coord, aDim, nPix, fDat, mute)
%
% Sort out single molecule coordinates and create corresponding intensity-time trace.
% Intensities are calculated as the sum of the brightest pixels in a square zone around the molecule coordinates.
%
% coord: [N-by-2*nChan] x- and y-coordinates of single moelcules to be sorted (in pixels)
% aDim: zone's pixel dimensions
% nPix: number of brightest pixels to sum up
% fDat: {1-by-4} video file data and meta data with:
%  fDat{1}: source video file
%  fDat{2}: {1-by-2} position in file where pixel data starts and full-length video data if loaded in memory (empty otherwise)
%  fDat{3}: [1-by-2] video dimensions in the x- and y- directions
%  fDat{4}: video length (in frames)
% mute: (1) to mute actions, (0) otherwise
% trace: [L-by-N*nChan] intensity-time traces
% err: error message if any

res_x = fDat{3}(1);
res_y = fDat{3}(2);

% Sum up pixel intensities in the integration areas
lim.Xinf = []; lim.Yinf = [];
nChan = size(coord,2)/2;
extr = floor(aDim/2);

lim_inf = ceil(coord) - extr;
excl_out = ~~sum(double(lim_inf(:,1:2:end) < 1 | ...
    lim_inf(:,1:2:end)+aDim-1 > res_x | lim_inf(:,2:2:end) <= 0 | ...
    lim_inf(:,2:2:end)+aDim-1 > res_y),2);

excl_dbl = ~exclude_doublecoord(1, coord);
excl = excl_dbl | excl_out;

if ~isempty(find(excl,1))
    disp('coordinates excluded:');
    if ~isempty(find(excl_out,1))
        disp(sprintf(['out of range: ' repmat('%5.1f ', ...
            [1,size(coord,2)]) '\n'], coord(excl_out,:)'));
    end
    if ~isempty(find(excl_dbl,1))
        disp(sprintf(['in double: ' repmat('%5.1f ', [1,size(coord,2)]) ...
            '\n'], coord(excl_dbl,:)'));
    end
end
coord(excl,:) = [];

nCoord = size(coord,1);
lim_inf = ceil(coord) - extr;

for c = 1:nCoord
    for i = 1:nChan
        lim.Xinf(numel(lim.Xinf)+1) = lim_inf(c,i*2-1);
        lim.Yinf(numel(lim.Yinf)+1) = lim_inf(c,i*2);
    end
end
if ~isempty(varargin)
    mute = varargin{1};
    [trace,err] = getIntTrace(lim, aDim, nPix, fDat, mute);
else
    [trace,err] = getIntTrace(lim, aDim, nPix, fDat);
end

             
