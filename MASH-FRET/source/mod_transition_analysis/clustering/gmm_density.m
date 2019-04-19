function p = gmm_density(mu, sigma, v, corr)
xy = v(1:2,:);
K = size(mu,1);
N = size(xy,2);
if corr
    nTrs = K^2;
    p = zeros(nTrs,N);
else
    p = zeros(K,N);
end

if corr
    k = 0;
    for k1 = 1:K
        for k2 = 1:K
            k = k+1;
            sig = sigma(:,:,k);
            det_sig = abs(det(sig));
            sig_inv = inv(sig); % [2-by-2]
            A = 1/(2*pi*sqrt(det_sig)); % norm. factor
            d = xy-repmat(mu([k1 k2],1),[1,N]); % [2-by-N]

            md2 = zeros(2,N);
            md2(1,:) = sum(d.*repmat(sig_inv(1,:)',[1 N]),1);
            md2(2,:) = sum(d.*repmat(sig_inv(2,:)',[1 N]),1); % [2-by-N]
            md2 = sum(d.*md2,1); % square Mahalanobis distance

            p(k,:) = A*exp(-0.5*md2);
        end
    end
else
    for k = 1:K
        sig = sigma(:,:,k);
        det_sig = abs(det(sig));
        sig_inv = inv(sig); % [2-by-2]
        A = 1/(2*pi*sqrt(det_sig)); % norm. factor
        d = xy-repmat(mu(k,:)',[1,N]); % [2-by-N]

        md2 = zeros(2,N);
        md2(1,:) = sum(d.*repmat(sig_inv(1,:)',[1 N]),1);
        md2(2,:) = sum(d.*repmat(sig_inv(2,:)',[1 N]),1); % [2-by-N]
        md2 = sum(d.*md2,1); % square Mahalanobis distance

        p(k,:) = A*exp(-0.5*md2);
    end
end

