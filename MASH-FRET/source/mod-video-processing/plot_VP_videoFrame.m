function h_img = plot_VP_videoFrame(h_axes, h_cb, img, chansplit, prm)
% h_img = plot_VP_videoFrame(h_axes, h_cb, img, chansplit, l0, p)
%
% Plot current video frame after image filtering and spots coordinates after transformation or spot finfing
%
% h_axes: handle to axes 
% h_cb: handle to color bar
% img: current video frame
% chansplit: positions on x-axis of channel splitting
% prm: processing parameters
% h_img: handle to image plot

% defaults
mkstl = 'or';
mksz = 10;
chanstl = '--w';
chanlw = 2;

% collect processing parameters
persec = prm.plot{1}(1);
toplot = prm.plot{1}(3);
coordsf = prm.res_crd{1};
coordref = prm.res_crd{3};
coord2tr = prm.res_crd{1};
coordtr = prm.res_crd{4};
coordsm = prm.res_crd{4};
imgtrsf = prm.res_plot{3};

% get spots coordinates
nChan = numel(chansplit)+1;
spots = [];
switch toplot
    case 1 % spotfinder
        if ~isempty(coordsf)
            for c = 1:nChan
                if size(coordsf,2)>=c && ~isempty(coordsf{c})
                    spots = cat(1, spots, coordsf{c}(:,1:2));
                end
            end
        end
    case 2 % reference coordinates
        for c = 1:nChan
            if size(coordref)>=(2*c)
                spots = cat(1, spots, coordref(:,(2*c-1):(2*c)));
            end
        end
    case 3 % coordinates to tranform
        for c = 1:nChan
            if size(coord2tr)>=(2*c)
                spots = cat(1, spots, coord2tr(:,(2*c-1):(2*c)));
            end
        end
    case 4 % transformed coordinates
        for c = 1:nChan
            if size(coordtr)>=(2*c)
                spots = cat(1, spots, coordtr(:,(2*c-1):(2*c)));
            end
        end
    case 5 % coordinates for intensity integration
        for c = 1:nChan
            if size(coordsm)>=(2*c)
                spots = cat(1, spots, coordsm(:,(2*c-1):(2*c)));
            end
        end
end

% set axes visible
set([h_axes,h_cb],'visible','on');

% plot video frame
[h,w,~] = size(img);
h_img = imagesc(h_axes(1),[0.5 w-0.5],[0.5 h-0.5],img(:,:,1));

% plot average image
imagesc(h_axes(2),[0.5 w-0.5],[0.5 h-0.5],img(:,:,2));

% plot transformed image
if numel(h_axes)>=3
    imagesc(h_axes(3),[0.5 w-0.5],[0.5 h-0.5],imgtrsf);
end

% plot spots coordinates
set(h_axes,'nextplot','add');
if ~isempty(spots)
    plot(h_axes(1),spots(:,1),spots(:,2),mkstl,'markersize',mksz,'hittest',...
        'off','pickableparts','none');
    plot(h_axes(2),spots(:,1),spots(:,2),mkstl,'markersize',mksz,'hittest',...
        'off','pickableparts','none');
end

% plot channel separation
for c = 1:size(chansplit,2)
    plot(h_axes(1), [chansplit(c),chansplit(c)],[0 h],chanstl,'LineWidth', ...
        chanlw,'hittest','off','pickableparts','none');
    plot(h_axes(2), [chansplit(c),chansplit(c)],[0 h],chanstl,'LineWidth', ...
        chanlw,'hittest','off','pickableparts','none');
    if numel(h_axes)>=3
        plot(h_axes(3), [chansplit(c),chansplit(c)],[0 h],chanstl,...
            'LineWidth', chanlw,'hittest','off','pickableparts','none');
    end
end

% set axes limits
if min(min(img,[],1),[],2)==max(max(img,[],1),[],2)
    img_min = 0;
    img_max = 1;
else
    img_min = min(min(img,[],1),[],2);
    img_max = max(max(img,[],1),[],2);
end
set(h_axes(1),'nextPlot','replacechildren','xlim',[0,w],'ylim',[0,h],...
    'clim',[img_min(1),img_max(1)]);
set(h_axes(2),'nextPlot','replacechildren','xlim',[0,w],'ylim',[0,h],...
    'clim',[img_min(2),img_max(2)]);
if numel(h_axes)>=3
    set(h_axes(3),'nextPlot','replacechildren','xlim',[0,w],'ylim',[0,h]);
end

% align axes positions
h_axes(2).Position = h_axes(1).Position;
if numel(h_axes)>=3
    h_axes(3).Position = h_axes(1).Position;
end

% set colorbar label
if persec
    ylabel(h_cb, 'intensity(counts /pix /s)');
else
    ylabel(h_cb, 'intensity(counts /pix)');
end
