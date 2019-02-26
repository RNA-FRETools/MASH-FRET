function plotTDP(h_axes, TDP, plot_prm, clust_prm, varargin)
% Plot transition density plot and clusters
% "h_axes" >> axes handle
% "TDP" >> [m-by-n] TDP matrix
% "lim" >> [2-by-2] x-limits and y-limits
% "gconv" >> 1 if TDP convolute with Gaussian filter, 0 otherwise
% "norm" >> 1 if normalised densities, 0 otherwise
% "mu" >> [J-by-2] cluster centres
% "clust" >> [N-by-5] clustered transitions (dwells before transition, 
%            value before transition, value after transition, molecule nb, 
%            cluster nb)
% "clr" >> [J-by-3] RGB colours
% (optional) "varagin" >> MASH figure handle

lim = plot_prm{1};
bins = plot_prm{2};
gconv = plot_prm{3};
norm = plot_prm{4};
clr = plot_prm{5};

states = clust_prm{1};
clust = clust_prm{2};
gmm_prm = clust_prm{3};

if ~isempty(varargin)
    h_fig = varargin{1};
end

%% TDP convolution with Gaussian filter
if gconv
    bin_x = (lim(1,2)-lim(1,1))/size(TDP,2);
    bin_y = (lim(2,2)-lim(2,1))/size(TDP,1);
    o2 = [0.0005 0.0005];
    if lim(1,2)>2
        o2(1) = (4.4721*bin_x)^2;
    end
    if lim(2,2)>2
        o2(2) = (4.4721*bin_y)^2;
    end
    TDP = convGauss(TDP, o2, lim);
end

%% normalise transition densities
if norm
    try
        TDP = TDP/sum(sum(TDP));
    catch err % out of memory
        h_err = errordlg({['Normalization of TDP impossible: ' ...
            err.message] '' ...
            'Increasing TDP binning might be a solution.'}, ...
            'TDP error', 'modal');
        uiwait(h_err);
    end
end

%% draw TDP image
cla(h_axes);
im = imagesc(lim(1,:), lim(2,:), TDP, 'Parent', h_axes);
set(h_axes,'CLim',[min(min(TDP)) max(max(TDP))]);

%% plot y = x diagonal
set(h_axes, 'NextPlot', 'add');
minVal = min(lim(1:2,1)); maxVal = max(lim(1:2,2));
plot(h_axes, [minVal maxVal], [minVal maxVal], 'LineStyle', '--', ...
    'Color', [0.5 0.5 0.5]);


%% plot clustered data with resp. colour code
J = size(states,1);
if J>0
    mu = zeros(J*(J-1),2);
    j = 0;
    for j1 = 1:J
    for j2 = 1:J
    if j1 ~= j2
        j = j+1;
        mu(j,:) = states([j1 j2],1)';
    end
    end
    end

    if ~isempty(clust)
        j = 0;
        for j1 = 1:J
        for j2 = 1:J
        if j1 ~= j2
            j = j+1;
            clust_k = clust((clust(:,end-1)==j1 & clust(:,end)==j2),:);
            if ~isempty(clust_k)
                plot(h_axes, clust_k(:,2), clust_k(:,3), 'Marker', '+', ...
                    'MarkerEdgeColor', clr(j,:), 'MarkerSize', 5, ...
                    'LineWidth', 1, 'LineStyle', 'none');
            end
        end
        end
        end
    end

    for j = 1:J*(J-1)
        plot(h_axes, mu(j,1), mu(j,2), 'Marker', '+', 'MarkerEdgeColor', ...
            clr(j,:), 'MarkerSize', 13, 'LineWidth', 2);
    end

    if ~isempty(gmm_prm) && isstruct(gmm_prm)
        a = gmm_prm.a; sig = gmm_prm.o;
        if ~isempty(a) && ~isempty(sig)
            x_iv = lim(1,1):bins(1):lim(1,2);
            x_iv = mean([x_iv(1:end-1);x_iv(2:end)],1);
            y_iv = lim(2,1):bins(2):lim(2,2);
            y_iv = mean([y_iv(1:end-1);y_iv(2:end)],1);
            plot_elps(h_axes, states, sig, a, x_iv, y_iv, [], '-b');
        end
    end
end

%% adjust axis grid, limits and labels
grid(h_axes, 'on');
axis(h_axes, 'image');
xlabel(h_axes, 'Value before transition');
ylabel(h_axes, 'Value after transition');
set(h_axes, 'XAxisLocation', 'top', 'YAxisLocation', 'right', 'XLim', ...
    lim(1,:), 'YLim', lim(2,:), 'YDir', 'normal', 'NextPlot', ...
    'replacechildren', 'Visible', 'on');
if exist('h_fig', 'var')
    set([h_axes im], 'ButtonDownFcn', {@target_centroids, h_fig});
end

%% add density colorbar
colorbar(h_axes,'off');
h_c = colorbar('peer', h_axes);
if norm
    ylabel(h_c, 'normalized occurrence');
else
    ylabel(h_c, 'occurrence');
end





