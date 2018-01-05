function [w, mu, sigma] = init_guess(K, v, t, corr, shape, lim)

mu = [];
sigma = [];
% coefficient of each cluster w = 1/nTrs
if corr
    nTrs = K^2;
    w = ones(nTrs,1);
else
    w = ones(K,1);
end
w = w/sum(w);
N = size(v,2);

% generate evenly spread centers over the TDP
max_x = max(v(1,:));
min_x = min(v(1,:));
max_y = max(v(2,:));
min_y = min(v(2,:));

if t == 1
    d_x = (max_x-min_x)/(K+1);  d_y = (max_y-min_y)/(K+1);
    x_0 = d_x*(1:K)' + min_x;   y_0 = d_y*(1:K)' + min_y;
    if corr
        mu = x_0;
    else
        mu = [x_0 y_0];
    end
    
    % adjust initial cluster centers and populations with k-mean algorithm
    % tolR = repmat([(max_x-min_x)/(2*K) (max_y-min_y)/(2*K)],K,1);
    if corr
        tolR = Inf*ones(K,1);
    else
        tolR = Inf*ones(K,2);
    end

    [mu,o] = get_kmean(mu, tolR, 1000, v(3,:), v(1,:), v(2,:), corr);
    

else
    if corr
        mu = zeros(K,1);
    else
        mu = zeros(K,2);
    end
    
    id = [];
    dat = unique(v([1 2],:)','rows');
    for k = 1:K
        [o,id_k] = max(rand(1,size(dat,1)));
        while ~(~sum(find(id==id_k)) && id_k>0 && id_k<=size(dat,1))
            [o,id_k] = max(rand(1,size(dat,1)));
        end
        id = [id id_k];
        if corr
            mu(k,:) = dat(id_k,1);
        else
            mu(k,:) = dat(id_k,:);
        end
    end
end

if size(mu,1)>1
    incl = true(size(mu,1),1);
    for k1 = 1:size(mu,1)
        for k2 = 1:size(mu,1)
            if k1~=k2
                if sum(abs(mu(k1,:)-mu(k2,:))<lim)
                    incl([k1 k2]) = false;
                end
            end
        end
    end
    mu = mu(incl,:);
end

if size(mu,1)==K
    sig_x = (max_x - min_x)/(2*K*sqrt(2*log(2)));
    sig_y = (max_y - min_y)/(2*K*sqrt(2*log(2)));
    sig = mean([sig_x,sig_y]);
    if corr
        nS = nTrs;
    else
        nS = K;
    end
    if strcmp(shape, 'spherical') || strcmp(shape, 'ellipsoid straight')
        sigma = repmat([sig^2,0;0,sig^2],[1,1,nS]);
        
    elseif strcmp(shape,'ellipsoid diagonal')
        R = [cos(-pi/4),-sin(-pi/4);sin(-pi/4),cos(-pi/4)];
        varX = (R(1,1)^2 + R(1,2)^2)*sig_x^2;
        varY = (R(2,1)^2 + R(2,2)^2)*sig_y^2;
        covXY = (R(2,1)*R(1,1) + R(2,2)*R(1,2))*sig_x*sig_y;
        sigma = repmat([varX covXY;covXY varY],[1,1,nS]);
        
    elseif strcmp(shape,'free')
        sigma = repmat([sig_x^2,0;0,sig_y^2],[1,1,nS]);
    end
end
