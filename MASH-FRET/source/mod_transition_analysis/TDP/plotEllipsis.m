function plotEllipsis(h_axes,mus,rad,type)

% default
clr = [1,1,1]; % line color

if sum(rad==0)
    return
end

switch type
    case 'diagonal'
        theta = pi()/4;
    case 'straight'
        theta = 0;
end

np = get(h_axes,'nextplot');

for i = 1:size(mus,1)
    xy = ellipsis(mus(i,:),rad(i,:),theta);
    plot(h_axes,xy(:,1),xy(:,2),'marker','.','color',clr);
    if i==1
        set(h_axes,'nextplot','add');
    end
    plot(h_axes,xy(:,3),xy(:,4),'marker','.','color',clr);
end

set(h_axes,'nextplot',np);
