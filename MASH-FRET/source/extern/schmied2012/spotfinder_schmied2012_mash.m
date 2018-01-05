% dat...m x n matrix of the current image
% thr...threshold value for the algorithm
% lim...pixels excluded (distance to boarder), by default = 10 
function [coordinates_xy] = spotfinder_schmied2012_mash(dat,thr,lim)
% function spotfinder_dk()
% fmt_s = imformats('tif');
% thr = 1.4;
% lim =10; added for this paper
% roisz = 5; % not used
% dat = double(myimread('testimage.tif',fmt_s));

%[szx,szy] = size(dat);
imr = forloop(dat,thr,lim);

CC = bwconncomp(imr);
S = regionprops(CC,'Centroid');
[ssx,~] = size(S);

% figure(1)
% imshow(uint16(dat), [ min(min(dat)), max(max(dat)) ] );

coordinates_xy = zeros(ssx,2);
for i=1:ssx
%     xko = S(i).Centroid(1);
%     yko = S(i).Centroid(2);
%     figure(1)
%     hold on;
%     plot(xko,yko,'+','color','red');
    coordinates_xy (i,1:2) = [S(i).Centroid(1) S(i).Centroid(2)];
end
% disp(coordinates_xy)
%end