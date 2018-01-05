function [coord trace] = create_trace(coord, aDim, nPix, fDat)
% Create intensity-time trace of input single molecule by summing up
% the pixel intensity values as indicated in the GUI. The intensity
% extraction takes in account applied background corrections.
%
% Requires external functions: getIntTrace, updateBgCorr.

res_y = fDat{3}(1);
res_x = fDat{3}(2);

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
trace = getIntTrace(lim, aDim, nPix, fDat);
             
