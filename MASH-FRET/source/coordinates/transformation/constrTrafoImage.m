function [img_final,ok] = constrTrafoImage(tr, img, h_fig)
% Build the superposition of the donor base image (red) and the transformed
% acceptor image into donor chanel (green): First an array containing all
% coordinates which exist in the half base image is build and
% transformation inverse of tform_2 (SIRA) or tform_1 (Twotone) is
% performed on it. Base intensities are attributed to each transformed
% coordinates and image of the transformed acceptor in donor chanel is
% build.
%
% Requires external function: loading_bar.

% MH, last update 27.03.2019
% >> adapt the function for newer versions of MATLAB: transformation were
%    calculated using the MATLAB's fitgeotrans function (see createTrafo.m)
%    and must be handle with MATLAB's transformPointsForward and
%    transformPointsInverse functions

img_final = [];
ok = 1;

[res_y,res_x,res_n] = size(img);
if res_n > 1
    img = img(:,:,1);
end

nChan = 0.5*(sqrt(1 + 4*size(tr,1)) + 1);
lim = [0 (1:nChan-1)*round(res_x/nChan) res_x];
xy = cell(1,nChan);

for i = 1:nChan
    [X,Y] = meshgrid(lim(i)+0.5:lim(i+1), 0.5:res_y);
    xy{i} = [reshape(X,[numel(X) 1]) reshape(Y,[numel(Y) 1])];
end

[xy_tr,ok] = transformPoints(tr,xy,nChan,h_fig);

if ~ok
    return;
end

img_final = zeros([res_y res_x 3]);

img = double(img);
for i = 1:nChan
    img(:,lim(i)+1:lim(i+1)) = (img(:,lim(i)+1:lim(i+1)) - ...
        min(min(img(:,lim(i)+1:lim(i+1)))))/ ...
        max(max(img(:,lim(i)+1:lim(i+1))));
end

for i = 1:nChan
    % img transform from channel i
    for j = 1:size(xy_tr{i},2)
        xy_tr{i}{j} = ceil(xy_tr{i}{j});
        xy{j} = ceil(xy{j});
        for k = 1:size(xy_tr{i}{j},1)
            x_0 = xy{j}(k,1);
            y_0 = xy{j}(k,2);
            x = xy_tr{i}{j}(k,1);
            y = xy_tr{i}{j}(k,2);
            if x > lim(i) && x <= lim(i+1) && y > 0 && y <= res_y
                img_final(y,x,j) = img(y_0,x_0);
            end
        end
    end
end


