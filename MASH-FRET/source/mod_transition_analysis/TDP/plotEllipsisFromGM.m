function h_plot = plotEllipsisFromGM(h_axes, mu, oxy, a, x_iv, y_iv, ...
    h_plot, stl)

nTrs = size(mu,1);

if ~isempty(h_plot)
    delete(h_plot);
end
h_plot = [];

prevStatus = get(h_axes, 'NextPlot');
set(h_axes, 'NextPlot', 'add');

clim = get(h_axes,'Clim');

[X,Y] = meshgrid(x_iv,y_iv);
x = X(:); y = Y(:);

for k = 1:nTrs
    obj = gmdistribution(mu(k,:), oxy(:,:,k), a(k));
    try
        Z = reshape(pdf(obj,[x y]),numel(y_iv),numel(x_iv));
    catch err
        if strcmp(err.identifier,...
                'stats:gmdistribution:wdensity:IllCondCov')
            disp(cat(2,'Gaussian of cluster ',num2str(k),' is too narrow ',...
                'to be shown on plot'))
            continue
        else
            throw(err)
        end
    end
    Z = clim(2)*Z/max(max(Z));
    contour(h_axes,X,Y,Z,0.25*[clim(2) clim(2)],stl);
end

set(h_axes,'NextPlot',prevStatus,'Clim',clim);

