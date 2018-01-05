function h_plot = plot_elps(h_axes, mu, oxy, a, x_iv, y_iv, h_plot, stl)

K = size(mu,1);

if ~isempty(h_plot)
    delete(h_plot);
end
h_plot = [];

prevStatus = get(h_axes, 'NextPlot');
set(h_axes, 'NextPlot', 'add');

clim = get(h_axes,'Clim');

[X,Y] = meshgrid(x_iv,y_iv);
x = X(:); y = Y(:);

k = 0;
for k1 = 1:K
    for k2 = 1:K
        k = k + 1;
        if k1~=k2
            obj = gmdistribution(mu([k1 k2],1)', oxy(:,:,k), a(k));
            Z = reshape(pdf(obj,[x y]),numel(y_iv),numel(x_iv));
            Z = Z/sum(sum(Z));
            [o,c] = contour(h_axes,X,Y,Z,stl);
            set(c,'LevelListMode','manual');
            lvl = get(c,'LevelList');
            set(c,'LevelList',clim(2)*ones(size(lvl)));
        end
    end
end

set(h_axes,'NextPlot',prevStatus,'Clim',clim);