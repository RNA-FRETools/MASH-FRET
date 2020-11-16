function [f_lj,f_lj_norm,cl] = fwdprob(seq,T,B,vals,f_0j)

% build event observation matrices
[V,J] = size(B);
O = cell(1,V);
for v = 1:V
    O{v} = zeros(J);
    O{v}(~~eye(J)) = B(v,:);
end

% calculate forward probabilities
[f_lj,f_lj_norm,cl] = calcFwdProb(seq,T,O,vals,f_0j);


function [f_lj,f_lj_norm,cl] = calcFwdProb(seq,T,O,vals,f_0j)

N = numel(seq);
J = numel(f_0j);
f_lj = cell(1,N);
f_lj_norm = f_lj;
cl = f_lj;
for n = 1:N
    L = numel(seq{n});
    f_lj{n} = zeros(L,J);
    for l = 1:L
        val = find(vals==seq{n}(l));
        if l==1
            f_lj{n}(l,:) = f_0j*T*O{val};
        else
            f_lj{n}(l,:) = f_lj{n}(l-1,:)*T*O{val};
        end
        cl{n}(l) = sum(f_lj{n}(l,:));
        f_lj_norm{n}(l,:) = f_lj{n}(l,:)/cl{n}(l);
    end
end

