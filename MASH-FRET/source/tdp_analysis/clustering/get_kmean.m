function [mu,clust] = get_kmean(mu_0, tol_0, N, z, x, y, corr)
% "mu_0" >> [J-by-2] initial guess of center
% "tol" >> tolerance radius around each center
% "N" >> max. number of iteration
% "z" >> [M-by-3] (x,y,z) data to cluster
% "mu" >> [J-by-2] converged values of the J centers
% "clust" >> {1-by-J}[M-by-3] clustered data

clust = zeros(size(z));
mu = [];

% Generate cluster for "static" transitions (k to k transitions)
clstStat = 1;

J = size(mu_0,1);
if corr
    if J<2
        disp('If coordinates are correlated, K_max>=2.');
        return;
    end
end

clust = reshape(clust,[1 numel(clust)]);

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

n = 0; % Nb of k-mean iteration
ok = 0;

if ~corr
    nTrs = J;
    mu = mu_0;
    tol = tol_0;
else
    nTrs = J^2;
    mu = mu_0;
    tol = NaN(J^2,2);
    k = 0;
    for j1 = 1:J
        for j2 = 1:J
            k = k+1;
            tol(k,1:2) = tol_0([j1 j2]);
        end
    end
end
    
while ~ok && (n<N || (N==0 && n==N))
    
    % Initialise data pnts parameters for clustering
    if corr
        dist = Inf(nTrs,size(xy,2)); % Distances from the centres
    else
        dist = Inf(nTrs,size(xy,2)); % Distances from the centres
    end
    
    if corr
        mu_0 = mu;
        mu = NaN(J^2,2);
        k = 0;
        for j1 = 1:J
            for j2 = 1:J
                k = k+1;
                mu(k,1:2) = mu_0([j1 j2],1)';
            end
        end
        
        k = 0;
        for j1 = 1:J
        for j2 = 1:J
            k = k+1;
            if (~clstStat && j1~=j2) || clstStat
                % Find data pnts lying in the tol. elipse of the cluster
                tol_x = tol(k,1);
                tol_y = tol(k,2);
                [o,c,o] = find(xy(2,:)<(tol_y* ...
                    sqrt(1-((xy(1,:)-mu(k,1))/tol_x).^2) + mu(k,2)) & ...
                    xy(2,:)>(-tol_y* ...
                    sqrt(1-((xy(1,:)-mu(k,1))/tol_x).^2) + mu(k,2)));

                % Calculation of mean squared distances from 
                % centres (a,b)
                % dist = sqrt((a - x)^2 + (b - y)^2);
                dist(k,c) = (sum(z)./z(1,c)).* ...
                    sqrt(((mu(k,1)-xy(1,c)).^2)+((mu(k,2)-xy(2,c)).^2));
            end
        end
        end
    else
        for k = 1:nTrs
            if isempty(find(isnan(tol(k,:))))
                % Find data pnts lying in the tol. elipse of the cluster
                tol_x = tol(k,1);
                tol_y = tol(k,2);
                [o,c,o] = find( ...
                    xy(2,:)<(tol_y* ...
                    sqrt(1-((xy(1,:)-mu(k,1))/tol_x).^2) + mu(k,2)) & ...
                    xy(2,:)>(-tol_y* ...
                    sqrt(1-((xy(1,:)-mu(k,1))/tol_x).^2) + mu(k,2)));

                % Calculation of mean squared distances from 
                % centres (a,b)
                % dist = sqrt((a - x)^2 + (b - y)^2);
                dist(k,c) = sqrt(((mu(k,1)-xy(1,c)).^2) + ...
                    ((mu(k,2)-xy(2,c)).^2));
            end
        end
    end
    
    % Cluster where data pnts have the minimum distance
    [o,id_k] = min(dist,[],1);
    id_k(~~prod(double(isinf(dist)),1)) = NaN;
    
    % Exclude all data pnts that belong to no cluster
    cvg = true;
    
    if corr
        sum_k = zeros(1,J);
        mu_new = zeros(J,1);
        k = 0;
        for j1 = 1:J
        for j2 = 1:J
            k = k+1;
            if (~clstStat && j1 ~=j2) || clstStat
                xy_k = xy(:,id_k==k); z_k = z(:,id_k==k);
                mu_new(j1,1) = mu_new(j1,1) + sum(z_k.*xy_k(1,:));
                mu_new(j2,1) = mu_new(j2,1) + sum(z_k.*xy_k(2,:));
                sum_k(j1) = sum_k(j1) + sum(z_k);
                sum_k(j2) = sum_k(j2) + sum(z_k);
                clust(id_k==k) = k;
            end
        end
        end
        mu = sort(mu_new./sum_k');
        
    else
        for k = 1:nTrs
            if isempty(find(isnan(tol(k,:))))
                xy_k = xy(:,id_k==k); z_k = z(:,id_k==k);
                mu(k,:) = sum(repmat(z_k,[2,1]).*xy_k,2)'/sum(z_k);
                clust(id_k==k) = k;
            end
        end
    end
        
    % Stop the iteration if same pnts are clustered together
    if ~(n>0 && isequal(clust,clust_prev))
        cvg = false;
    end
    
    % Stop k-mean process if the sum of the weights in each cluster doesn't
    % change or if the max. nb of iteration is reached
    if n == N || (n>0 && cvg)
        ok = 1;
    else
        clust_prev = clust;
        n = n+1;
    end
end

clust = reshape(clust, numel(unique(y)), numel(unique(x)));

[k_excl,o,o] = find(isnan(mu));
clust_new = clust;
if isempty(k_excl)
    k_excl = [];
end
for k = k_excl'
    clust_new(clust>k) = clust_new(clust>k)-1;
end
clust = clust_new;
mu(k_excl',:) = [];

