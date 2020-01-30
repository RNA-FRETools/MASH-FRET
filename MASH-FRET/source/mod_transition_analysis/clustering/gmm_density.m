function p = gmm_density(mu, sigma, v, corr, clstDiag)

xy = v(1:2,:);
J = size(mu,1);
N = size(xy,2);
if corr
    if clstDiag
        nTrs = J^2;
    else
        nTrs = J*(J-1);
    end
else
    nTrs = J;
end
p = zeros(nTrs,N);

if corr
    k = 0;
    for j1 = 1:J
        for j2 = 1:J
            if j1==j2 && ~clstDiag
                continue
            end
            k = k+1;
            sig = sigma(:,:,k);
            det_sig = abs(det(sig));
            sig_inv = inv(sig); % [2-by-2]
            A = 1/(2*pi*sqrt(det_sig)); % norm. factor
            d = xy-repmat(mu([j1 j2],1),[1,N]); % [2-by-N]

            md2 = zeros(2,N);
            md2(1,:) = sum(d.*repmat(sig_inv(1,:)',[1 N]),1);
            md2(2,:) = sum(d.*repmat(sig_inv(2,:)',[1 N]),1); % [2-by-N]
            md2 = sum(d.*md2,1); % square Mahalanobis distance

            p(k,:) = A*exp(-0.5*md2);
        end
    end
else
    for k = 1:J
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

