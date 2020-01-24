function plotTDP(h_axes, h_cb, TDP, plot_prm, clust_prm, h_fig)
% Plot transition density plot and clusters
% "h_axes" >> axes handle
% "h_cb" >> colorbar handle
% "plot_prm >> {1-by-5} cell array:
%  plot_prm{1} >> [m-by-n] TDP matrix
%  plot_prm{2} >> [2-by-2] x-limits and y-limits
%  plot_prm{3} >> 1 if TDP convolute with Gaussian filter, 0 otherwise
%  plot_prm{4} >> 1 if normalised densities, 0 otherwise
%  plot_prm{5} >> [J-by-3] RGB colours
% "clust_prm" >> {1-by-3} cell array:
%  clust_prm{1} >> [J-by-2] cluster centres
%  clust_prm{2} >> [N-by-5] clustered transitions (dwells before transition, 
%                  value before transition, value after transition, 
%                  molecule index, cluster index)
%  clust_prm{3} >> structure with fields "a" and "o" containing 2D-
%                  Gaussians amplitudes and standard deviations, used to 
%                  plot ellipses
% (optional) "varagin" >> MASH figure handle

% Last update by MH, 12.12.2019:
% >> give the colorbar's handle in plotTDP's input to prevent dependency on 
%  MASH main figure's handle and allow external use.
%
% update by MH, 29.11.2019
% >> remove systemic axes clearance to keep original properties (font size,
%  color bar etc..)
%
% update: 18th of March 2019 by Mélodie Hadzic
% >> update help section

lim = plot_prm{1};
bin = plot_prm{2};
gconv = plot_prm{3};
norm = plot_prm{4};
clr = plot_prm{5};

states = clust_prm{1};
clust = clust_prm{2};
gmm_prm = clust_prm{3};


%% TDP convolution with Gaussian filter
if gconv
    o2 = 0.0005;
    if lim(1,2)>2
        o2 = (4.4721*bin)^2;
    end
    TDP = convGauss(TDP, [o2,o2], [lim;lim]);
end

%% normalise transition densities
if norm
    try
        if sum(sum(TDP))>0
            TDP = TDP/sum(sum(TDP));
        end
    catch err % out of memory
        setContPan(cat(2,'Impossible to normalize TDP: ',err.message,...
            '\nIncreasing TDP binning might be a solution.'),'warning',...
            h_fig);
    end
end

%% draw TDP image
% cancelled by MH, 29.11.2019
% cla(h_axes);

imagesc(lim(1,:),lim(1,:),TDP,'Parent',h_axes,'HitTest','off',...
 'PickableParts','none');
if sum(sum(TDP))
    set(h_axes,'CLim',[min(min(TDP)) max(max(TDP))]);
else
    set(h_axes,'CLim',[0 1]);
end

%% plot y = x diagonal
set(h_axes, 'NextPlot', 'add');
plot(h_axes, lim(1,1:2), lim(1,1:2), 'LineStyle', '--', 'Color', ...
    [0.5 0.5 0.5]);


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
            iv = lim(1,1):bin(1):lim(1,2);
            iv = mean([iv(1:end-1);iv(2:end)],1);
            plot_elps(h_axes, states, sig, a, iv, iv, [], '-b');
        end
    end
end

%% adjust axis grid, limits and labels
grid(h_axes, 'on');
axis(h_axes, 'image');
xlabel(h_axes, 'Value before transition');
ylabel(h_axes, 'Value after transition');
set(h_axes, 'XAxisLocation', 'top', 'YAxisLocation', 'right', 'XLim', ...
    lim(1,:), 'YLim', lim(1,:), 'YDir', 'normal', 'NextPlot', ...
    'replacechildren');

if norm
    ylabel(h_cb, 'normalized occurrence');
else
    ylabel(h_cb, 'occurrence');
end

set([h_axes h_cb],'visible','on');





