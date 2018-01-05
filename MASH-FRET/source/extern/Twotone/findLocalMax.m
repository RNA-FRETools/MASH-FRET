function out=findLocalMax(im,th)
% finds local maxima in an image to pixel level accuracy.   
%  local maxima condition is >= rather than >
% inspired by Crocker & Griers algorithm, and also Daniel Blair & Eric Dufresne's implementation
%   im = input image for detection
%   th - detection threshold - pixels must be strictly greater than this value
% out : x,y coordinates of local maxima

%identify above threshold pixels
[y,x] = find(im>th);
%delete pixels identified at the boundary of the image
[imsizey, imsizex]= size(im);
edgepixel_idx = find( y==1 | y==imsizey | x==1 | x==imsizex);
y(edgepixel_idx) = [];
x(edgepixel_idx) = [];

%check if its a local maxima
subim = zeros(3,3);
islocalmaxima = zeros(numel(x),1);
for i = 1:numel(x)
  subim = im([y(i)-1:y(i)+1],[x(i)-1:x(i)+1]);
  islocalmaxima(i) = all(subim(2,2)>=subim(:));
end
%assign all above threshold pixels to out initially
out = [x,y];
%delete pixels which are not local maxima
out(find(~islocalmaxima),:) = [];