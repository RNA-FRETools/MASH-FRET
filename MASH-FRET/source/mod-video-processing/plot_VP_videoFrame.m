function h_img = plot_VP_videoFrame(h_axes, h_cb, img, chansplit, prm)
% h_img = plot_VP_videoFrame(h_axes, h_cb, img, chansplit, l0, p)
%
% Plot current video frame after image filtering and spots coordinates after transformation or spot finfing
%
% h_axes: handle to axes 
% h_cb: handle to color bar
% img: current video frame
% chansplit: positions on x-axis of channel splitting
% p: structure containing processing parameters and spots coordinates
% h_img: handle to image plot

% defaults
mkstl = 'or';
mksz = 10;
chanstl = '--w';
chanlw = 2;

% get spots coordinates
nChan = numel(chansplit)+1;
spots = [];
switch prm.coord2plot
    case 1 % spotfinder
        if ~isempty(prm.SFres)
            for c = 1:nChan
                if size(prm.SFres,2)>=c && ~isempty(prm.SFres{2,c})
                    spots = cat(1, spots, prm.SFres{2,c}(:,1:2));
                end
            end
        end
    case 2 % reference coordinates
        for c = 1:nChan
            if size(prm.trsf_coordRef)>=(2*c)
                spots = cat(1, spots, prm.trsf_coordRef(:,(2*c-1):(2*c)));
            end
        end
    case 3 % coordinates to tranform
        for c = 1:nChan
            if size(prm.coordMol)>=(2*c)
                spots = cat(1, spots, prm.coordMol(:,(2*c-1):(2*c)));
            end
        end
    case 4 % transformed coordinates
        for c = 1:nChan
            if size(prm.coordTrsf)>=(2*c)
                spots = cat(1, spots, prm.coordTrsf(:,(2*c-1):(2*c)));
            end
        end
    case 5 % transformed coordinates
        for c = 1:nChan
            if size(prm.coordItg)>=(2*c)
                spots = cat(1, spots, prm.coordItg(:,(2*c-1):(2*c)));
            end
        end
end

% set axes visible
set([h_axes,h_cb],'visible','on');

% plot image
[h,w] = size(img);
h_img = imagesc(h_axes,[0.5 w-0.5],[0.5 h-0.5],img);

% plot spots coordinates
set(h_axes,'nextplot','add');
if ~isempty(spots)
    plot(h_axes,spots(:,1),spots(:,2),mkstl,'markersize',mksz);
end

% plot channel separation
for c = 1:size(chansplit,2)
    plot(h_axes, [chansplit(c) chansplit(c)], [0 h], chanstl, 'LineWidth', ...
        chanlw);
end

% set axes limits
if min(min(img))==max(max(img))
    img_min = 0;
    img_max = 1;
else
    img_min = min(min(img));
    img_max = max(max(img));
end
set(h_axes,'nextPlot','replacechildren','xlim',[0,w],'ylim',[0,h],'clim',...
    [img_min,img_max]);

% set colorbar label
if prm.perSec
    ylabel(h_cb, 'intensity(counts /pix /s)');
else
    ylabel(h_cb, 'intensity(counts /pix)');
end
