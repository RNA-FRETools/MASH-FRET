function [BIC,L,I] = calc_L(w, mu, sig, v, corr, shape, lklhd, clstDiag)
% w = [K-by-1]
% s = [K-by-2]
% sig = [2-by-2-by-K]
% v = [2-by-N]

L = -Inf;
BIC = Inf;
J = size(mu,1);
N = size(v,2);
if corr
    if clstDiag
        nTrs = J^2;
    else
        nTrs = J*(J-1);
    end
else
    nTrs = J;
end
I = false(nTrs,N);

p = gmm_density(mu, sig, v, corr, clstDiag);
if isempty(p) || sum(sum(isnan(p)))
    return
end

[x,i] = max(p,[],1);
i(:,sum(p,1)<=0) = 0;
P = zeros(1,N);

for k = 1:size(p,1)
    I(k,:) = (i==k);
    if lklhd==1
        P(I(k,:)) = P(I(k,:)) + w(k)*p(k,I(k,:)); % to calculate complete-data likelihood 
    else
        P = P + w(k)*p(k,:); % to calculate incomplete-data likelihood 
    end
end

L = sum((v(3,(P>0)).*log(P(P>0))),2);

if L == 0
    L = -Inf;
    BIC = Inf;
    I = false(nTrs,N);
    return
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
if corr
    f_mu = J;
else
    f_mu = 2*nTrs;
end
f_w = nTrs-1; % when n-1 coefficients are known, the n-th coefficient is known as 1-sum(n coefficients)

BIC = (f_mu+f_w+f_sig)*log(sum(v(3,:))) - 2*L;
% BIC = (1+K^2)*log(sum(v(3,:))) - 2*L;

