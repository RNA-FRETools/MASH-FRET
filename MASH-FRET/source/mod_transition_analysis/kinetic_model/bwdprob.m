function beta = bwdprob(seq,T,B,vals,cl)
% build event observation matrices
% [V,J] = size(B);
% O = cell(1,V);
% for v = 1:V
%     O{v} = zeros(J);
%     O{v}(~~eye(J)) = B(v,:);
% end

% calculate forward probabilities
beta = calcBwdProb(seq,T,B,cl);


function beta = calcBwdProb(seq,T,B,cl)

N = numel(seq);
J = size(T,1);
beta = cell(1,N);
norm = ~isempty(cl);
ids = ~~B;
for n = 1:N
    L = numel(seq{n});
    beta{n} = zeros(J,L);
    for l = L:-1:1
%         val = find(vals==seq{n}(l));
        if l==L
            beta{n}(:,l) = sum(T(:,ids(seq{n}(l),:)),2);
%             beta{n}(:,l) = T*O{val}*ones(J,1);
        else
            beta{n}(:,l) = sum(T(:,ids(seq{n}(l),:)).*...
                repmat(beta{n}(ids(seq{n}(l),:),l+1)',[J,1]),2);
%             beta{n}(:,l) = T*O{val}*beta{n}(:,l+1);
            if norm
                beta{n}(:,l) = beta{n}(:,l)/cl{n}(l+1);
            end
        end
    end
end
