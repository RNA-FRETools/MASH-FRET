function [mu,clust] = get_kmean(mu_0, tol_0, N, z, x, y, mat, clstDiag, ...
    shape)
% [mu,clust] = get_kmean(mu_0, tol_0, N, z, x, y, mat, clstDiag)
%
% mu_0: [J-by-1 or 2] initial guess of states or cluster (x,y) centers
% tol_0: [J-by-1 or 2] tolerance radius around states or cluster (x,y) centers
% N: max. number of iteration
% z: vector or matrix to cluster
% x: vector of x coordinates associated to z
% y: vector of y coordinates associated to z
% mat: (1) infer a matrix of clusters, (2) infer symmetrical clusters, (3) infer free-of-constrint clusters
% clustDiag: include diagonal clusters in cluster matrix
%
% mu: [J-by-1 or 2] states or cluster (x,y) centers
% clust: vector or matrix of cluster idexes associated to z

clust = zeros(size(z));
mu = [];

J = size(mu_0,1);
if mat==1 % matrix or symmetrical
    if J<2
        disp('Cluster matrix or symmetrical clusters requires J>=2.');
        return
    end
elseif mat~=1 && clstDiag
    disp('Diagonal clusters are only for the cluster matrix option.');
    clstDiag = false;
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

nTrs = getClusterNb(J,mat,clstDiag);
if mat==1 % matrix
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
    tol = [tol_0(j1,1),tol_0(j2,1)];
elseif mat==2 % symmetrical
    tol = [tol_0(1:J,[1,2]);tol_0(1:J,[2,1])];
else % free
    tol = tol_0;
end
mu = mu_0;

while ~ok && (n<N || (N==0 && n==N))
    
    if mat==1 % matrix
        mu = [mu(j1,1),mu(j2,1)];
    elseif mat==2 % symmetrical
        mu = [mu(:,[1,2]);mu(:,[2,1])];
    end
   
    % re-initialize cluster matrix
    clust = zeros(size(clust));
    
    % Initialise data pnts parameters for clustering
    dist = Inf(nTrs,size(xy,2)); % Distances from the centres
    
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

        % Calculation of mean squared distances from 
        % centres (a,b)
        % dist = sqrt((a - x)^2 + (b - y)^2);
        dist(k,c) = (sum(z)./z(1,c)).* ...
            sqrt(((mu(k,1)-xy(1,c)).^2)+((mu(k,2)-xy(2,c)).^2));
    end
    
    % Cluster where data pnts have the minimum distance
    [o,id_k] = min(dist,[],1);
    id_k(~~prod(double(isinf(dist)),1)) = NaN;
    
    % Exclude all data pnts that belong to no cluster
    cvg = true;
    
    if mat==1 % matrix
        sum_k = zeros(1,J);
        mu_new = zeros(J,1);
        for k = 1:nTrs
            xy_k = xy(:,id_k==k); z_k = z(:,id_k==k);
            mu_new(j1(k),1) = mu_new(j1(k),1) + sum(z_k.*xy_k(1,:));
            mu_new(j2(k),1) = mu_new(j2(k),1) + sum(z_k.*xy_k(2,:));
            sum_k(j1(k)) = sum_k(j1(k)) + sum(z_k);
            sum_k(j2(k)) = sum_k(j2(k)) + sum(z_k);
            clust(id_k==k) = k;
        end
        mu = mu_new./sum_k';
        
    elseif mat==2 % symmetrical
        sum_k = zeros(1,J);
        mu_new = zeros(J,2);
        for k = 1:nTrs
            if k<=J
                j = k;
                cols = [1,2];
            else
                j = k-J;
                cols = [2,1];
            end
            xy_k = xy(:,id_k==k); z_k = z(:,id_k==k);
            mu_new(j,cols) = mu_new(j,cols) + ...
                sum(repmat(z_k,[2,1]).*xy_k,2)';
            sum_k(j) = sum_k(j) + sum(z_k);
            clust(id_k==k) = k;
        end
        mu = mu_new./repmat(sum_k',[1,2]);
        
    else % free
        for k = 1:nTrs
            if ~isempty(find(isnan(tol(k,:)),1))
                continue
            end
            xy_k = xy(:,id_k==k); z_k = z(:,id_k==k);
            mu(k,:) = sum(repmat(z_k,[2,1]).*xy_k,2)'/sum(z_k);
            clust(id_k==k) = k;
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

[j_excl,o,o] = find(isnan(mu));
k_excl = [];
if mat==1 % matrix
    for k = 1:nTrs
        if sum(j_excl==j1(k)) || sum(j_excl==j2(k))
            k_excl = cat(2,k_excl,k);
        end
    end   
    
elseif mat==2 % symmetrical
    for k = 1:nTrs
        if sum(j_excl==k) || sum(j_excl==(k-J))
            k_excl = cat(2,k_excl,k);
        end
    end   
    
else
    k_excl = j_excl;
end

clust_new = clust;
for k = 1:numel(k_excl)
    clust_new(clust>=k_excl(k)) = clust_new(clust>=k_excl(k))-1;
end
clust = clust_new;
mu(j_excl',:) = [];

