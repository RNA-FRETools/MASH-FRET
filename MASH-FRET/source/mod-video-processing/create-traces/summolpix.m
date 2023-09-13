function pixsum = summolpix(img,coord,adim)
% pixsum = summolpix(img,coord,adim)
%
% Sums up the video pixel intensities within the single molecule 
% integration area.
% 
% img: [nRow-by-nCol] pixel intensities
% coord: [N-by-2] molecules' pixel position in the x- and y-direction 
%  (column and row number)
% adim: pixel dimensions of the square integration areas
% pixsum: [N-by-1] sums of pixel intensities

% determines area'a limits
coord0 = ceil(coord)-floor(adim/2);

% get average sub-image
N = size(coord0,1);
pixsum = zeros(N,1);
for n = 1:N
    idx = coord0(n,1):(coord0(n,1)+adim-1);
    idy = coord0(n,2):(coord0(n,2)+adim-1);
    pixsum(n,1) = sum(sum(img(idy,idx)));
end