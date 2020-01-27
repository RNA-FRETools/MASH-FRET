function h_plot = plotEllipsisFromGM(h_axes, mu, oxy, a, x_iv, y_iv, ...
    h_plot, stl)

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
            Z = clim(2)*Z/max(max(Z));
            contour(h_axes,X,Y,Z,0.25*[clim(2) clim(2)],stl);
        end
    end
end

set(h_axes,'NextPlot',prevStatus,'Clim',clim);

