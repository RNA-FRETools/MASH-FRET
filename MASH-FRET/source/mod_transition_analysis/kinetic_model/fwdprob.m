function [alpha,alpha_norm,logP] = fwdprob(seq,T,B,vals,ip0)

% build event observation matrices
[V,J] = size(B);
O = cell(1,V);
for v = 1:V
    O{v} = zeros(J);
    O{v}(~~eye(J)) = B(v,:);
end

% calculate forward probabilities
[alpha,alpha_norm,logP] = calcFwdProb(seq,T,O,vals,ip0);


function [alpha,alpha_norm,logP] = calcFwdProb(seq,T,O,vals,ip0)

logP = 0;
N = numel(seq);
J = numel(ip0);
alpha = cell(1,N);
alpha_norm = alpha;
for n = 1:N
    L = numel(seq{n});
    alpha{n} = zeros(L,J);
    for l = 1:L
        val = find(vals==seq{n}(l));
        if l==1
            alpha{n}(l,:) = ip0*T*O{val};
%             alpha_norm{n}(l,:) = alpha{n}(l,:);
        else
            alpha{n}(l,:) = alpha{n}(l-1,:)*T*O{val};
%             alpha_norm{n}(l,:) = alpha_norm{n}(l-1,:)*T*O{val};
        end
%         alpha_norm{n}(l,:) = alpha_norm{n}(l,:)/sum(alpha_norm{n}(l,:));
    end
    logP = logP + log(sum(alpha{n}(end,:)));
end

