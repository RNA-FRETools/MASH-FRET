function p = gmm_density(mu, sigma, v, mat, clstDiag)

xy = v(1:2,:);
J = size(mu,1);
N = size(xy,2);
nTrs = getClusterNb(J,mat,clstDiag);
p = zeros(nTrs,N);

[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);

for k = 1:nTrs
    sig = sigma(:,:,k);
    det_sig = abs(det(sig));
    sig_inv = inv(sig); % [2-by-2]
    A = 1/(2*pi*sqrt(det_sig)); % norm. factor
    if mat==1
        d = xy-repmat(mu([j1(k) j2(k)],1),[1,N]); % [2-by-N]
    elseif mat==2
        if k<=J
            j = k;
            cols = [1,2];
        else
            j = k-J;
            cols = [2,1];
        end
        d = xy-repmat(mu(j,cols)',[1,N]); % [2-by-N]
    else
        d = xy-repmat(mu(k,:)',[1,N]); % [2-by-N]
    end

    md2 = zeros(2,N);
    md2(1,:) = sum(d.*repmat(sig_inv(1,:)',[1 N]),1);
    md2(2,:) = sum(d.*repmat(sig_inv(2,:)',[1 N]),1); % [2-by-N]
    md2 = sum(d.*md2,1); % square Mahalanobis distance

    p(k,:) = A*exp(-0.5*md2);
end


