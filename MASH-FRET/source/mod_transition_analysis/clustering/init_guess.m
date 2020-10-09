function [w, mu, sigma] = init_guess(J, v, t, mat, shape, lim, clstDiag)

% coefficient of each cluster w = 1/nTrs
nTrs = getClusterNb(J,mat,clstDiag);
w = ones(nTrs,1);
w = w/sum(w);
sigma = [];

% generate evenly spread centers over the TDP
max_x = max(v(1,:));
min_x = min(v(1,:));
max_y = max(v(2,:));
min_y = min(v(2,:));

if t==1
    d_x = (max_x-min_x)/(J+1);  d_y = (max_y-min_y)/(J+1);
    x_0 = d_x*(1:J)' + min_x;   y_0 = d_y*(1:J)' + min_y;
    if mat==1
        mu = x_0;
    else
        mu = [x_0 y_0];
    end
    
    % adjust initial cluster centers and populations with k-mean algorithm
    % tolR = repmat([(max_x-min_x)/(2*K) (max_y-min_y)/(2*K)],K,1);
    if mat==1
        tolR = Inf*ones(J,1);
    else
        tolR = Inf*ones(J,2);
    end

    [mu,o] = get_kmean(mu, tolR, 1000, v(3,:), v(1,:), v(2,:), mat, ...
        clstDiag, 1);
else
    if mat==1
        mu = zeros(J,1);
    else
        mu = zeros(J,2);
    end
    
    id = [];
    dat = unique(v([1 2],:)','rows');
    for j = 1:J
        [o,id_k] = max(rand(1,size(dat,1)));
        while ~(~sum(find(id==id_k)) && id_k>0 && id_k<=size(dat,1))
            [o,id_k] = max(rand(1,size(dat,1)));
        end
        id = cat(2,id,id_k);
        if mat==1
            mu(j,:) = dat(id_k,1);
        else
            mu(j,:) = dat(id_k,:);
        end
    end
end
if size(mu,1)~=J
    return
end

incl = true(size(mu,1),1);
if mat==1
    for j1 = 1:J
        for j2 = 1:J
            if j1==j2
                continue
            end
            if sum(abs(mu(j1,:)-mu(j2,:))<lim)
                incl([j1 j2]) = false;
            end
        end
    end
else
    for k = 1:size(mu,1)
        if abs(mu(k,1)-mu(k,2))<lim
            incl(k) = false;
        end
    end
end
mu = mu(incl,:);
if size(mu,1)~=J
    return
end

sig_x = (max_x - min_x)/(2*J*sqrt(2*log(2)));
sig_y = (max_y - min_y)/(2*J*sqrt(2*log(2)));
sig = mean([sig_x,sig_y]);

if strcmp(shape, 'spherical') || strcmp(shape, 'ellipsoid straight')
    sigma = repmat([sig^2,0;0,sig^2],[1,1,nTrs]);

elseif strcmp(shape,'ellipsoid diagonal')
    R = [cos(-pi/4),-sin(-pi/4);sin(-pi/4),cos(-pi/4)];
    varX = (R(1,1)^2 + R(1,2)^2)*sig_x^2;
    varY = (R(2,1)^2 + R(2,2)^2)*sig_y^2;
    covXY = (R(2,1)*R(1,1) + R(2,2)*R(1,2))*sig_x*sig_y;
    sigma = repmat([varX covXY;covXY varY],[1,1,nTrs]);

elseif strcmp(shape,'free')
    sigma = repmat([sig_x^2,0;0,sig_y^2],[1,1,nTrs]);
end

