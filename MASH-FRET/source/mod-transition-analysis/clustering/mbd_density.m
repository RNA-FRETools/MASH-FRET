function prob = mbd_density(s, o, v)
% s = [1-by-K]
% o = [2-by-1]
% v = [2-by-N]
% prob_s = [(K*(K-1)/2)-by-N]

N = size(v,2);
K = size(s,2);
prob = zeros(K*(K-1)/2,N);

o_x = o(1); o_y = o(2);
A = 1/(o_x*o_y*2*pi);

k = 0;
for k1 = 1:K
    for k2 = 1:K
        if s(k1) < s(k2) % superior diagonal half
            k = k+1;
            p_hm = exp((-1/(4*(o_x^2)))*(((v(1,:)-s(k1)).^2) - ...
                2*(v(1,:)-s(k1)).*(v(2,:)-s(k2)) + ...
                (v(2,:)-s(k2)).^2));
            p_ht = exp((-1/(4*(o_y^2)))*(((v(1,:)-s(k1)).^2) + ...
                2*(v(1,:)-s(k1)).*(v(2,:)-s(k2)) + ...
                (v(2,:)-s(k2)).^2));
            peak = A*p_hm.*p_ht;
            prob(k,:) = peak;
        end
    end
end