function plotKinMdl(h_axes,prm,v_res)

% default
r0_min = 0.05; % min circle radius
r0_max = 0.25; % max circle radius
r0_def = 0.1; % default circle radius
mg = 0.15; % padding in axes
lw_max = 12; % maximum arrow line witdh
lw_min = 0.01*lw_max; % minimum arrow line witdh (to be normalized by the number of states)
hw_min = 2; % minimum arrow head witdh
step = 0.03; % arrow shift (normalized units)
corr = 0.025; % y-offset correction

% clear axes
for ax = 1:numel(h_axes)
    cla(h_axes(ax));
end
if ~isempty(h_axes(1).UserData)
    delete(h_axes(1).UserData);
end

% collect results
if ~(isfield(prm,'mdl_res'))
    mdl_res = [];
else
    mdl_res = prm.mdl_res;
end
if isempty(mdl_res)
    states = [];
else
    tp = mdl_res{1};
    tp_err = mdl_res{2};
    ip = mdl_res{3};
    simdat = mdl_res{4};
    states = mdl_res{5};
    BICres = mdl_res{6};
end

% draw state diagram (circles)
if isempty(states)
    return
end
h_axes(1).NextPlot = 'add';
h_axes(1).Units = 'normalized';
h_axes(1).XLimMode = 'manual';
h_axes(1).YLimMode = 'manual';
h_axes(1).XLim = [0,1];
h_axes(1).YLim = [0,1];
J = numel(states);
lw_min = lw_min/J;
h_pan = h_axes(1).Parent;
x0 = diff(h_axes(1).XLim)/2;
y0 = diff(h_axes(1).YLim)/2;
Rh = diff(h_axes(1).XLim)/2-mg;
Rv = diff(h_axes(1).YLim)/2-mg;
theta = 2*pi/J;
posrect = zeros(J,4);
r0 = r0_def*ones(1,J);
if ~isempty(simdat)
    dtSum = sum(simdat.dt(:,1));
    for j = 1:J
        popj = sum(simdat.dt(simdat.dt(:,3)==j,1))/dtSum;
        r0(j) = r0_max*popj;
    end
end
for j = 1:J
    x = x0+Rh*cos((j-1)*theta)-r0(j);
    y = y0+Rv*sin((j-1)*theta)-r0(j);
    posrect(j,:) = [x y 2*r0(j) 2*r0(j)];
    
    rectangle(h_axes(1),'Position',posrect(j,:),'Curvature',[1 1]);
    text(h_axes(1),posrect(j,1)+r0(j),posrect(j,2)+r0(j),...
        sprintf('%0.2f',states(j)),'horizontalalignment','center',...
        'fontweight','bold','color','red');
end

% plot BIC results
if ~isempty(BICres)
    nCmb = size(BICres,1);
    BIC = BICres(:,end)';
    incl = ~isinf(BIC);
    BIC = BIC(incl);
    cmbs = 1:nCmb;
    cmbs = cmbs(incl);
    scatter(h_axes(5),cmbs,BIC,'+');

    cmb = BICres(:,1:end-1);
    cmb = cmb(incl,:);
    [BICmin,cmbopt] = min(BIC);
    h_axes(5).NextPlot = 'add';
    scatter(h_axes(5),cmbs(cmbopt),BIC(cmbopt),'+','linewidth',2);
    h_axes(5).NextPlot = 'replacechildren';
    cmblow = cmbopt-3;
    if cmblow<1
        cmblow = 1;
    end
    nCmb = numel(cmbs);
    cmbup = cmbopt+6-(cmbopt-cmblow);
    if cmbup>nCmb
        cmbup = nCmb;
    end
    h_axes(5).XLim = [cmblow-0.5,cmbup+0.5];
    BICmax = max(BIC(cmblow:cmbup));
    ylim(h_axes(5),[BICmin,BICmax]);
    h_axes(5).XTick = cmblow:cmbup;
    xlbl = compose(repmat('%i',1,size(cmb,2)),cmb)';
    h_axes(5).XTickLabel = xlbl(cmblow:cmbup);
end

% draw state transitions (arrows)
if isempty(tp)
    return
end
tp(tp<1E-5) = 0;
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
            xyarr1 = posAxesToFig([x_arr(1),y_arr(1)],h_pan,h_axes(1),'normalized');
            xyarr2 = posAxesToFig([x_arr(2),y_arr(2)],h_pan,h_axes(1),'normalized');
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
            xyarr1 = posAxesToFig([x_arr(1),y_arr(1)],h_pan,h_axes(1),'normalized');
            xyarr2 = posAxesToFig([x_arr(2),y_arr(2)],h_pan,h_axes(1),'normalized');
            h_arr = cat(2,h_arr,...
                annotation(h_pan,'arrow',[xyarr1(1),xyarr2(1)],...
                [xyarr1(2)+corr,xyarr2(2)+corr],'linewidth',lw(j2,j1),...
                'headwidth',hw(j2,j1),'linestyle',lstl));
        end
    end
end

h_axes(1).UserData = h_arr;
h_axes(1).Visible = 'off';
h_axes(1).NextPlot = 'replacechildren';

% plot experimental vs simulation
if isempty(simdat)
    return
end

% plot state value populations
vals = unique(states);
V = numel(vals);
bar(h_axes(2),1:V,[simdat.pop(1,:)',simdat.pop(2,:)']);
h_axes(2).XLim = [0.5,V+0.5];
h_axes(2).XTick = 1:V;
xtklbl = cell(1,V);
for v = 1:V
    xtklbl{v} = sprintf('%0.2f',vals(v));
end
h_axes(2).XTickLabel = xtklbl;
ylim(h_axes(2),'auto');
legend(h_axes(2),'exp','sim','location','northoutside');

% plot number of transitions
bar(h_axes(3),1:V*(V-1),[simdat.ntrs(1,:)',simdat.ntrs(2,:)']);
h_axes(3).XLim = [0.5,V*(V-1)+0.5];
h_axes(3).XTick = 1:V*(V-1);
xtklbl = cell(1,V*(V-1));
v = 0;
for v1 = 1:V
    for v2 = 1:V
        if v1==v2
            continue
        end
        v = v+1;
        xtklbl{v} = sprintf('%0.2f\\newline%0.2f',vals(v1),vals(v2));
    end
end
h_axes(3).XTickLabel = xtklbl;
ylim(h_axes(3),'auto');
legend(h_axes(3),'exp','sim','location','northoutside');

% plot dwell time histograms
scatter(h_axes(4),simdat.cumdstrb{v_res}(1,:),simdat.cumdstrb{v_res}(2,:),...
    '+k');
h_axes(4).NextPlot = 'add';
scatter(h_axes(4),simdat.cumdstrb{v_res}(1,:),simdat.cumdstrb{v_res}(3,:),...
    '+r');
h_axes(4).NextPlot = 'replacechildren';
h_axes(4).XLim = simdat.cumdstrb{v_res}(1,[1,end]);
ylim(h_axes(4),'auto');
legend(h_axes(4),'exp','sim','location','east');




function [x,y] = shiftArrow(x0,y0,step)

[x0,ord] = sort(x0,'ascend');
y0 = y0(ord);
[~,ord0] = sort(ord,'ascend');

a = diff(y0)/diff(x0);
if a>0
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
elseif isinf(a) % vertical
    dx = step;
    dy = 0;
end

if a>0
    x = x0+[-dx,-dx];
    y = y0+[dy,dy];
elseif a<0
    x = x0+[dx,dx];
    y = y0+[dy,dy];
elseif a==0
    x = x0;
    y = y0+[dy,dy];
elseif isinf(a)
    x = x0+[dx,dx];
    y = y0;
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
elseif isinf(a) % vertical
    theta = 0;
end

dx = dr*sin(theta);
dy = dr*cos(theta);

x = x0+[dx(1),-dx(2)];
y = y0+[-dy(1),dy(2)];

x = x(ord0);
y = y(ord0);

