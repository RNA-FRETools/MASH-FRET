function [img_final ok] = constrTrafoImage(tr, img, h_fig)
% Build the superposition of the donor base image (red) and the transformed
% acceptor image into donor chanel (green): First an array containing all
% coordinates which exist in the half base image is build and
% transformation inverse of tform_2 (SIRA) or tform_1 (Twotone) is
% performed on it. Base intensities are attributed to each transformed
% coordinates and image of the transformed acceptor in donor chanel is
% build.
%
% Requires external function: loading_bar.

img_final = [];
ok = 1;

[res_y res_x res_n] = size(img);
if res_n > 1
    img = img(:,:,1);
end

nChan = 0.5*(sqrt(1 + 4*size(tr,1)) + 1);
lim = [0 (1:nChan-1)*round(res_x/nChan) res_x];

for i = 1:nChan
    [X,Y] = meshgrid(lim(i)+0.5:lim(i+1), 0.5:res_y);
    grid{i} = [reshape(X,[numel(X) 1]) reshape(Y,[numel(Y) 1])];
end

if ~isempty(tr{1,2}.forward_fcn)
    for i = 1:nChan
        grid_trsf{i}{i} = grid{i};
        for j = 1:size(tr,1)
            chan_input = tr{j,1}(1);
            if chan_input == i
                chan_output = tr{j,1}(2);
                tr_ij = tr{j,2};
                grid_trsf{chan_output}{i} = tformfwd(tr_ij, grid{i});
            end
        end
    end
    
elseif ~isempty(tr{1,2}.inverse_fcn)
    for i = 1:nChan
        grid_trsf{i}{i} = grid{i};
        for j = 1:size(tr,1)
            chan_output = tr{j,1}(2);
            if chan_output == i
                chan_input = tr{j,1}(1);
                tr_ij = tr{j,2};
                grid_trsf{chan_input}{i} = tforminv(tr_ij, grid{i});
            end
        end
    end
    
else
    updateActPan(['Empty transform matrices.\nPlease check the import ' ...
        'options.'], h_fig, 'error');
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
    for j = 1:size(grid_trsf{i},2)
        grid_trsf{i}{j} = ceil(grid_trsf{i}{j});
        grid{j} = ceil(grid{j});
        for k = 1:size(grid_trsf{i}{j},1)
            x_0 = grid{j}(k,1);
            y_0 = grid{j}(k,2);
            x = grid_trsf{i}{j}(k,1);
            y = grid_trsf{i}{j}(k,2);
            if x > lim(i) && x <= lim(i+1) && y > 0 && y <= res_y
                img_final(y,x,j) = img(y_0,x_0);
            end
        end
    end
end


