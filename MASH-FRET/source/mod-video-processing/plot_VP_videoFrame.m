function [h_img,h_ave] = plot_VP_videoFrame(h_axes, h_cb, img, imgtrsf, coord, chansplit, persec, multichanvid)
% [h_img,h_ave] = plot_VP_videoFrame(h_axes, h_cb, img, imgtrsf, coord, chansplit, persec, multichanvid)
%
% Plot current video frame after image filtering and spots coordinates after transformation or spot finfing
%
% h_axes: handle to axes 
% h_cb: handle to color bar
% img: current video frame
% imgtrsf: transformed image
% coord: spots coordinates to plot
% chansplit: positions on x-axis of channel splitting
% persec: (1) if intensity units are in IC/second, (0) if they are in IC
% multichanvid: 1 for multi-channel video, 0 for single-channel videos
% h_img: handle to video frame plot
% h_ave: handle to average image plot

% defaults
mkstl = 'or';
mksz = 10;
chanstl = '--w';
chanlw = 2;

% set axes visible
set([h_axes,h_cb],'visible','on');

% plot video frame and average image
[h,w,~] = size(img);
h_img = imagesc(h_axes(1),[0.5 w-0.5],[0.5 h-0.5],img(:,:,1));
h_ave = imagesc(h_axes(2),[0.5 w-0.5],[0.5 h-0.5],img(:,:,2));

% plot transformed image
if numel(h_axes)>=3
    imagesc(h_axes(3),[0.5 w-0.5],[0.5 h-0.5],imgtrsf);
end

% plot spots coordinates
set(h_axes,'nextplot','add');
if ~isempty(coord)
    plot(h_axes(1),coord(:,1),coord(:,2),mkstl,'markersize',mksz,'hittest',...
        'off','pickableparts','none');
    plot(h_axes(2),coord(:,1),coord(:,2),mkstl,'markersize',mksz,'hittest',...
        'off','pickableparts','none');
end

% plot channel separation
if multichanvid
    for c = 1:size(chansplit,2)
        plot(h_axes(1), [chansplit(c),chansplit(c)],[0 h],chanstl,...
            'LineWidth',chanlw,'hittest','off','pickableparts','none');
        plot(h_axes(2), [chansplit(c),chansplit(c)],[0 h],chanstl,...
            'LineWidth',chanlw,'hittest','off','pickableparts','none');
        if numel(h_axes)>=3
            plot(h_axes(3), [chansplit(c),chansplit(c)],[0 h],chanstl,...
                'LineWidth', chanlw,'hittest','off','pickableparts',...
                'none');
        end
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
posaxes1 = getPixPos(h_axes(1));
postab1 = getPixPos(h_axes(1).Parent);
dy = postab1(4)-posaxes1(2);
postab2 = getPixPos(h_axes(2).Parent);
y2 = postab2(4)-dy;
setPixPos(h_axes(2),[posaxes1(1),y2,posaxes1([3,4])]);
if numel(h_axes)>=3
    postab3 = getPixPos(h_axes(3).Parent);
    y3 = postab3(4)-dy;
    setPixPos(h_axes(3),[posaxes1(1),y3,posaxes1([3,4])]);
end

% set colorbar label
if persec
    ylabel(h_cb, 'intensity(counts /pix /s)');
else
    ylabel(h_cb, 'intensity(counts /pix)');
end
