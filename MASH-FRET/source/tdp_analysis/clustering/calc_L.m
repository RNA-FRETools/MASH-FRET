function [BIC,L,I] = calc_L(w, mu, sig, v, corr, shape)
% w = [K-by-1]
% s = [K-by-2]
% sig = [2-by-2-by-K]
% v = [2-by-N]

L = -Inf;
BIC = Inf;
K = size(mu,1);
N = size(v,2);
if corr
    nTrs = K^2;
    I = false(nTrs,N);
else
    nTrs = K;
    I = false(K,N);
end

p = gmm_density(mu, sig, v, corr);
if isempty(p) || sum(sum(isnan(p)))
    return;
end

[x,i] = max(p,[],1);
i(:,sum(p,1)<=0) = 0;
P = zeros(1,N);

for k = 1:size(p,1)
    I(k,:) = (i==k);
    P = P + w(k)*p(k,:);
end

P(P<=0)=1;
L = sum((v(3,:).*log(P)),2);
if L == 0
    L = -Inf;
    BIC = Inf;
    I = false(K,N);
    return;
end

switch shape
    case 'spherical' % sig
        f_sig = nTrs;
    case 'ellipsoid straight' % sig_x, sig_y
        f_sig = 2*nTrs;
    case 'ellipsoid diagonal' % sig_x, sig_y
        f_sig = 2*nTrs;
    case 'free' % rho, sig_x, sig_y
        f_sig = 3*nTrs;
end
f_mu = K;
f_a = nTrs;

BIC = (f_mu+f_a+f_sig)*log(sum(v(3,:))) - 2*L;
% BIC = (1+K^2)*log(sum(v(3,:))) - 2*L;

