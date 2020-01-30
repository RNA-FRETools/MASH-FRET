function clust = manualClustering(z,x,y,mu,tol,shape)

if size(z,1)~=1 && size(z,2)~=1
    % vectorize martix data (x,y,z)
    if isempty(x)
        x = mean([1:size(z,2)-1;1:size(z,2)],1);
    end
    if isempty(y)
        y = mean([0:size(z,1)-1;1:size(z,1)],1);
    end
    [X,Y] = meshgrid(x,y);
    x_v = reshape(X,[numel(X),1]);	y_v = reshape(Y,[numel(Y),1]);
else
    if size(x,2)==1
        x_v = x;
    elseif size(x,1)==1
        x_v = x';
    end
    if size(y,2)==1
        y_v = y;
    elseif size(y,1)==1
        y_v = y';
    end
end
data = [x_v y_v reshape(z,[numel(z) 1])]';

xy = data(1:2,:); z = data(3,:);

clust = zeros(size(z));

nTrs = size(mu,1);
for k = 1:nTrs
    % Find data pnts lying in the tol. elipse of the cluster
    switch shape
        case 1 % square
            c = findInSquare(xy(1,:),xy(2,:),mu(k,1),mu(k,2),2*tol(k,1),...
                2*tol(k,2));
        case 2 % straight ellipse
            c = findInEllipse(xy(1,:),xy(2,:),mu(k,1),mu(k,2),2*tol(k,1),...
                2*tol(k,2),0);
        case 3 % diagonal ellipse
            c = findInEllipse(xy(1,:),xy(2,:),mu(k,1),mu(k,2),2*tol(k,1),...
                2*tol(k,2),pi/4);
    end
    clust(c) = k;
end

clust = reshape(clust, numel(unique(y)), numel(unique(x)));
