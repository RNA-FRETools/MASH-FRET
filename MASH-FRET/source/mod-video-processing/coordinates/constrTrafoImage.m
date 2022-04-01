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

% defaults
bgtol = 1;
bghtfact = 3;

nMov = numel(img);
multichanvid = nMov==1;
img_final = cell(1,nMov);
isblack = cell(1,nMov);

nChan = 0.5*(sqrt(1 + 4*size(tr,1)) + 1);
xy = cell(1,nChan);
res_x = zeros(1,nMov);
res_y = zeros(1,nMov);

for mov = 1:nMov
    [res_y(mov),res_x(mov),res_z] = size(img{mov});
    if res_z>1
        img{mov} = img{mov}(:,:,1);
    end
end

if multichanvid
    lim = [0 (1:nChan-1)*round(res_x(1)/nChan) res_x(1)];
end
for i = 1:nChan
    if multichanvid
        [X,Y] = meshgrid(lim(i)+0.5:lim(i+1), 0.5:res_y(1));
    else
        [X,Y] = meshgrid(0.5:res_x(i),0.5:res_y(i));
    end
    xy{i} = [reshape(X,[numel(X) 1]) reshape(Y,[numel(Y) 1])];
end

[xy_tr,ok] = transformPoints(tr,xy,nChan,h_fig);
if ~ok
    return
end

for mov = 1:nMov
    isblack{mov} = true(res_y(mov),res_x(mov));
    img_final{mov} = zeros([res_y(mov) res_x(mov) 3]);
    img{mov} = double(img{mov});
end

% mormalize pixel values in each channel
for i = 1:nChan
    if multichanvid
        img(:,lim(i)+1:lim(i+1)) = (img(:,lim(i)+1:lim(i+1)) - ...
            min(min(img(:,lim(i)+1:lim(i+1)))))/ ...
            (max(max(img(:,lim(i)+1:lim(i+1))))-...
            min(min(img(:,lim(i)+1:lim(i+1)))));
    else
        img{i} = (img{i}-min(min(img{i})))/...
            (max(max(img{i}))-min(min(img{i})));
    end
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
            if multichanvid && ...
                    x>lim(i) && x<=lim(i+1) && y>0 && y<=res_y
                img_final{1}(y,x,j) = img{1}(y_0,x_0);
            elseif ~multichanvid && ...
                    x>0 && x<=res_x(i) && y>0 && y<=res_y(i)
                img_final{i}(y,x,j) = img{j}(y_0,x_0);
            end
        end
        
        isblack{i} = isblack{i} & ...
            img_final{i}(:,:,j)<median(img_final{i}(:,:,j))*(1+bgtol);
    end
    
    % erase background and increase brightness
    for j = 1:3
        pxj = img_final{i}(:,:,j);
        pxj(isblack{i}) = 0;
        pxj(~isblack{i}) = pxj(~isblack{i})*bghtfact;
        pxj(pxj>1) = 1;
        img_final{i}(:,:,j) = pxj;
    end
end


