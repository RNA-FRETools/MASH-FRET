function plotEllipsis(h_axes, mus, rad, theta, clr, lw)

% default
nsteps = 100; % number of x data points

if sum(rad==0)
    return
end

np = get(h_axes,'nextplot');

for i = 1:size(mus,1)
    % define x and y data
    xmin = mus(i,1)-max(rad(i,:));
    xmax = mus(i,1)+max(rad(i,:));
    ymin = mus(i,2)-max(rad(i,:));
    ymax = mus(i,2)+max(rad(i,:));
    x = xmin:(xmax-xmin)/(nsteps-1):xmax;
    y = ymin:(ymax-ymin)/(nsteps-1):ymax;

    xy = ellipsis(x,y,mus(i,:),rad(i,:),theta);
    xy{1}(isnan(xy{1}(:,1)),:) = [];
    xy{2}(isnan(xy{2}(:,1)),:) = [];
    
    plot(h_axes,xy{1}(:,1),xy{1}(:,2),'marker','.','color',clr,'linewidth',...
        lw);
    if i==1
        set(h_axes,'nextplot','add');
    end
    plot(h_axes,xy{2}(:,1),xy{2}(:,2),'marker','.','color',clr,'linewidth',...
        lw);
end

set(h_axes,'nextplot',np);
