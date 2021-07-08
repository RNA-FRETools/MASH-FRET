function drawDiagram(h_axes,states,tp,tpmin,pop)

% default
r0_min = 0.05; % min circle radius
r0_max = 0.25; % max circle radius
r0_def = 0.1; % default circle radius
mg = 0.15; % padding in axes
lw_max = 12; % maximum arrow line witdh
lw_min = 0.01*lw_max; % minimum arrow line witdh (to be normalized by the number of states)
hw_min = 2; % minimum arrow head witdh
step = 0.03; % arrow shift (normalized units)
corr = 0; % y-offset correction

% draw states (circles)
h_axes.NextPlot = 'add';
h_axes.Units = 'normalized';
h_axes.XLimMode = 'manual';
h_axes.YLimMode = 'manual';
h_axes.XLim = [0,1];
h_axes.YLim = [0,1];
J = numel(states);
lw_min = lw_min/J;
h_pan = h_axes.Parent;
x0 = diff(h_axes.XLim)/2;
y0 = diff(h_axes.YLim)/2;
Rh = diff(h_axes.XLim)/2-mg;
Rv = diff(h_axes.YLim)/2-mg;
theta = 2*pi/J;
posrect = zeros(J,4);
r0 = r0_def*ones(1,J);
if ~isempty(pop)
    for j = 1:J
        r0(j) = r0_max*pop(j);
    end
end
for j = 1:J
    x = x0+Rh*cos((j-1)*theta)-r0(j);
    y = y0+Rv*sin((j-1)*theta)-r0(j);
    posrect(j,:) = [x y 2*r0(j) 2*r0(j)];
    
    rectangle(h_axes,'Position',posrect(j,:),'Curvature',[1 1]);
    text(h_axes,posrect(j,1)+r0(j),posrect(j,2)+r0(j),...
        sprintf('%0.2f',states(j)),'horizontalalignment','center',...
        'fontweight','bold','color','red');
end
if isempty(tp)
    return
end

% draw transitions (arrows)
tp(tp<tpmin) = 0;
k = tp;
k(~~eye(J)) = 0;
k = k/sum(sum(k));
lw = lw_max*k;
hw = lw*3;
hw(hw<hw_min) = hw_min;
h_arr = [];
r0_corr = r0;
r0_corr(r0_corr<r0_min) = r0_min;
for j1 = 1:J
    for j2 = (j1+1):J
        xy_1 = posrect(j1,[1,2])+r0(j1);
        xy_2 = posrect(j2,[1,2])+r0(j2);
        if k(j1,j2)>0
            if lw(j1,j2)>lw_min
                lstl = '-';
            else
                lstl = ':';
            end
            x_arr = [xy_1(1),xy_2(1)];
            y_arr = [xy_1(2),xy_2(2)];
            [x_arr,y_arr] = shortenArrow(x_arr,y_arr,r0_corr([j1,j2])+0.02);
            if k(j2,j1)>0
                [x_arr,y_arr] = shiftArrow(x_arr,y_arr,step);
            end
            xyarr1 = posAxesToFig([x_arr(1),y_arr(1)],h_pan,h_axes,'normalized');
            xyarr2 = posAxesToFig([x_arr(2),y_arr(2)],h_pan,h_axes,'normalized');
            h_arr = cat(2,h_arr,...
                annotation(h_pan,'arrow',[xyarr1(1),xyarr2(1)],...
                [xyarr1(2)+corr,xyarr2(2)+corr],'linewidth',lw(j1,j2),...
                'headwidth',hw(j1,j2),'linestyle',lstl));
        end
        if k(j2,j1)>0
            if lw(j2,j1)>lw_min
                lstl = '-';
            else
                lstl = ':';
            end
            x_arr = [xy_2(1),xy_1(1)];
            y_arr = [xy_2(2),xy_1(2)];
            [x_arr,y_arr] = shortenArrow(x_arr,y_arr,r0_corr([j2,j1])+0.02);
            if k(j1,j2)>0
                [x_arr,y_arr] = shiftArrow(x_arr,y_arr,-step);
            end
            xyarr1 = posAxesToFig([x_arr(1),y_arr(1)],h_pan,h_axes,'normalized');
            xyarr2 = posAxesToFig([x_arr(2),y_arr(2)],h_pan,h_axes,'normalized');
            h_arr = cat(2,h_arr,...
                annotation(h_pan,'arrow',[xyarr1(1),xyarr2(1)],...
                [xyarr1(2)+corr,xyarr2(2)+corr],'linewidth',lw(j2,j1),...
                'headwidth',hw(j2,j1),'linestyle',lstl));
        end
    end
end

h_axes.UserData = h_arr;
h_axes.Visible = 'off';
h_axes.NextPlot = 'replacechildren';


function [x,y] = shiftArrow(x0,y0,step)

[x0,ord] = sort(x0,'ascend');
y0 = y0(ord);
[~,ord0] = sort(ord,'ascend');

a = diff(y0)/diff(x0);
if isinf(a) % vertical
    dx = step;
    dy = 0;
elseif a>0
    theta = atan(1/a);
    dx = step*cos(theta);
    dy = step*sin(theta);
elseif a<0
    theta = atan(-a);
    dx = step*sin(theta);
    dy = step*cos(theta);
elseif a==0 % horizontal
    dx = 0;
    dy = step;
end

if isinf(a)
    x = x0+[dx,dx];
    y = y0;
elseif a>0
    x = x0+[-dx,-dx];
    y = y0+[dy,dy];
elseif a<0
    x = x0+[dx,dx];
    y = y0+[dy,dy];
elseif a==0
    x = x0;
    y = y0+[dy,dy];
end

x = x(ord0);
y = y(ord0);


function [x,y] = shortenArrow(x0,y0,dr)

[x0,ord] = sort(x0,'ascend');
y0 = y0(ord);
dr = dr(ord);
[~,ord0] = sort(ord,'ascend');

a = diff(y0)/diff(x0);
if a>0
    theta = pi-atan(1/a);
elseif a<0
    theta = atan(-1/a);
elseif a==0 % horizontal
    theta = pi/2;
end

dx = dr*sin(theta);
dy = dr*cos(theta);

x = x0+[dx(1),-dx(2)];
y = y0+[-dy(1),dy(2)];

x = x(ord0);
y = y(ord0);

