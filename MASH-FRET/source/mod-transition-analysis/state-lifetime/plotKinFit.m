function plotKinFit(h_axes,p,prm,tag,tpe,v,k,scl)

% default
markhist = '+';
lwhist = 5;
clrfit = 'r';
lwfit = 2;
stboba = '--';
clrboba = [1 0 0];
lwboba = 1.5;
xlbl = 'dwell-times (s)';
ylbl = 'normalised (1 - cum(P))';

% collect interface and default processing parameters
proj = p.curr_proj;
def = p.proj{proj}.TA.def{tag,tpe};

% get y-axis scale
if strcmp(scl, 'y-log scale')
    scl = 'linear';
elseif strcmp(scl, 'y-linear scale')
    scl = 'log';
else
    scl = 'linear';
end

% clear axes and make visible
set(h_axes, 'Visible', 'off');
cla(h_axes);

if ~(isfield(prm,'clst_res') && ~isempty(prm.clst_res{1}))
    return
end

set(h_axes, 'Visible', 'on');

hist_ref = prm.clst_res{4}{v,k};
if isempty(hist_ref)
    return
end

% collect processing parameters
boba = prm.lft_start{1}{v,1}(5);
strch = prm.lft_start{1}{v,1}(2);

% plot histogram
x_data = hist_ref(hist_ref(:,end)>0,1);
y_data = hist_ref(hist_ref(:,end)>0,end);
plot(h_axes, x_data, y_data, markhist, 'linewidth', lwhist);
grid(h_axes, 'on');

if isempty(x_data)
    x_lim = [0,1];
elseif x_data(1)==x_data(end)
    x_lim = x_data(1)+[-1,1];
else
    x_lim = x_data([1,end])';
end
y_min = min(y_data);
y_max = max(y_data);
if isempty(y_data)
    y_lim = [0,1];
elseif y_min==y_max
    y_lim = y_min+[-1,1];
else
    y_lim = [y_min,y_max];
end

if ~(size(prm.lft_res,1)>=v && ~isequal(prm.lft_res(v,:),def.lft_res))
    set(h_axes,'Visible','on','YScale',scl);
    xlim(h_axes,x_lim);
    ylim(h_axes,y_lim);
    xlabel(h_axes, xlbl);
    ylabel(h_axes, ylbl);
    return
end
lft_res = prm.lft_res(v,:);

set(h_axes, 'NextPlot', 'add');

% plot fits for reference and bootstrapped data
nExp = size(lft_res{2},1);

if strch % stretched exponential fit
    if boba
        A = lft_res{1}(1,1,k);
        tau = lft_res{1}(1,3,k);
        beta = lft_res{1}(1,5,k);
    else
        A = lft_res{2}(1,1,k);
        tau = lft_res{2}(1,2,k);
        beta = lft_res{2}(1,3,k);
    end

    plot_ref = A*exp(-(x_data/tau).^beta);
    
    plot(h_axes, x_data, plot_ref, clrfit, 'linewidth', lwfit);
    
    if boba
        A_inf = lft_res{3}(1,1,k);
        tau_inf = lft_res{3}(1,2,k);
        beta_inf = lft_res{3}(1,3,k);

        A_sup = lft_res{4}(1,1,k);
        tau_sup = lft_res{4}(1,2,k);
        beta_sup = lft_res{4}(1,3,k);

        plot_inf = A_inf*exp(-(x_data/tau_inf).^beta_inf);
        plot_sup = A_sup*exp(-(x_data/tau_sup).^beta_sup);
        
        plot(h_axes, x_data, plot_inf, stboba, 'Color', clrboba, ...
            'Linewidth', lwboba);
        plot(h_axes, x_data, plot_sup, stboba, 'Color', clrboba, ...
            'Linewidth', lwboba);
        
    end
    
else % single-/multiexponential fit
    plot_ref = zeros(size(x_data));
    if boba
        plot_inf = zeros(size(x_data));
        plot_sup = zeros(size(x_data));
    end
    
    if boba && size(lft_res{1},2)>=4
        A = lft_res{1}(:,1,k);
        tau = lft_res{1}(:,3,k);
        A_inf = lft_res{3}(:,1,k);
        tau_inf = lft_res{3}(:,2,k);
        A_sup = lft_res{4}(:,1,k);
        tau_sup = lft_res{4}(:,2,k);
    else
        A = lft_res{2}(:,1,k);
        tau = lft_res{2}(:,2,k);
    end

    for i = 1:nExp
        plot_ref = plot_ref + A(i)*exp(-x_data/tau(i));
        
        if boba && size(lft_res{1},2)>=4
            plot_inf = plot_inf + A_inf(i)*exp(-x_data/tau_inf(i));
            plot_sup = plot_sup + A_sup(i)*exp(-x_data/tau_sup(i));
        end        
    end
    
    plot(h_axes, x_data,plot_ref, clrfit, 'linewidth', lwfit);
    if boba && size(lft_res{1},2)>=4
        plot(h_axes, x_data, plot_inf, stboba, 'Color', clrboba, ...
            'Linewidth', lwboba);
        plot(h_axes, x_data, plot_sup, stboba, 'Color', clrboba, ...
            'Linewidth', lwboba);
    end
    
end

xlabel(h_axes, xlbl);
ylabel(h_axes, ylbl);
xlim(h_axes,x_lim);
ylim(h_axes,y_lim);
lim = get(h_axes, 'YLim');

set(h_axes, 'NextPlot', 'replacechildren', 'YLim', [min(y_data) lim(2)], ...
    'YScale', scl);

