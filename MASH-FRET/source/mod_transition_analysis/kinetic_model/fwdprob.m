function P = fwdprob(seq,T,B,vals,f_0j)

% build event observation matrices
[V,J] = size(B);
O = cell(1,V);
for v = 1:V
    O{v} = zeros(J);
    O{v}(~~eye(J)) = B(v,:);
end

% calculate forward probabilities
P = calcFwdProb(seq,T,O,vals,f_0j);


function P = calcFwdProb(seq,T,O,vals,f_0j)

P = 0;
N = numel(seq);
J = numel(f_0j);
for n = 1:N
    L = numel(seq{n});
    f_lj = zeros(L,J);
    for l = 1:L
        val = find(vals==seq{n}(l));
        if l==1
            f_lj(l,:) = f_0j*T*O{val};
        else
            f_lj(l,:) = f_lj(l-1,:)*T*O{val};
        end
    end
    P = P + log(sum(f_lj(end,:)));
end

