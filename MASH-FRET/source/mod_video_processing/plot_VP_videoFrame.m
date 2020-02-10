function h_img = plot_VP_videoFrame(h_axes, h_cb, img, chansplit, p)
% h_img = plot_VP_videoFrame(h_axes, h_cb, img, chansplit, l0, p)
%
% Plot current video frame after image filtering and spots coordinates after transformation or spot finfing
%
% h_axes: handle to axes 
% h_cb: handle to color bar
% img: current video frame
% chansplit: positions on x-axis of channel splitting
% p: structure containing processing paarmeters and spots coordinates
% h_img: handle to image plot

% defaults
mkstl = 'or';
mksz = 10;
chanstl = '--w';
chanlw = 2;

% get spots coordinates
spots = [];
switch p.coord2plot
    case 1 % spotfinder
        if ~isempty(p.SFres)
            for c = 1:p.nChan
                if size(p.SFres,2)>=c && ~isempty(p.SFres{2,c})
                    spots = cat(1, spots, p.SFres{2,c}(:,1:2));
                end
            end
        end
    case 2 % reference coordinates
        for c = 1:p.nChan
            if size(p.trsf_coordRef)>=(2*c)
                spots = cat(1, spots, p.trsf_coordRef(:,(2*c-1):(2*c)));
            end
        end
    case 3 % coordinates to tranform
        for c = 1:p.nChan
            if size(p.coordMol)>=(2*c)
                spots = cat(1, spots, p.coordMol(:,(2*c-1):(2*c)));
            end
        end
    case 4 % transformed coordinates
        for c = 1:p.nChan
            if size(p.coordTrsf)>=(2*c)
                spots = cat(1, spots, p.coordTrsf(:,(2*c-1):(2*c)));
            end
        end
    case 5 % transformed coordinates
        for c = 1:p.nChan
            if size(p.coordItg)>=(2*c)
                spots = cat(1, spots, p.coordItg(:,(2*c-1):(2*c)));
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
set(h_axes,'nextPlot','replacechildren','xlim',[0,w],'ylim',[0,h],'clim',...
    [min(min(img)),max(max(img))]);

% set colorbar label
if p.perSec
    ylabel(h_cb, 'intensity(counts /pix /s)');
else
    ylabel(h_cb, 'intensity(counts /pix)');
end
