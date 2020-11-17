function [beta,beta_norm] = bwdprob(seq,T,B,vals)
% build event observation matrices
[V,J] = size(B);
O = cell(1,V);
for v = 1:V
    O{v} = zeros(J);
    O{v}(~~eye(J)) = B(v,:);
end

% calculate forward probabilities
[beta,beta_norm] = calcBwdProb(seq,T,O,vals);


function [beta,beta_norm] = calcBwdProb(seq,T,O,vals)

N = numel(seq);
J = size(T,1);
beta = cell(1,N);
beta_norm = beta;
for n = 1:N
    L = numel(seq{n});
    beta{n} = zeros(J,L);
    for l = L:-1:1
        val = find(vals==seq{n}(l));
        if l==L
            beta{n}(:,l) = T*O{val}*ones(J,1);
%             beta_norm{n}(:,l) = T*O{val}*ones(J,1);
        else
            beta{n}(:,l) = T*O{val}*beta{n}(:,l+1);
%             beta_norm{n}(:,l) = T*O{val}*beta_norm{n}(:,l+1);
        end
%         beta_norm{n}(:,l) = beta_norm{n}(:,l)/sum(beta_norm{n}(:,l));
    end
end
