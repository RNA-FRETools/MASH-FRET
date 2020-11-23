function [alpha,cl] = fwdprob(seq,T,B,vals,ip0,norm)

% build event observation matrices
% [V,J] = size(B);
% O = cell(1,V);
% for v = 1:V
%     O{v} = zeros(J);
%     O{v}(~~eye(J)) = B(v,:);
% end

% calculate forward probabilities
[alpha,cl] = calcFwdProb(seq,T,B,ip0,norm);


function [alpha,cl] = calcFwdProb(seq,T,B,ip0,norm)

N = numel(seq);
J = numel(ip0);
alpha = cell(1,N);
cl = alpha;
ids = ~~B;
idsSum = sum(ids,2);
for n = 1:N
    L = numel(seq{n});
    alpha{n} = zeros(L,J);
    for l = 1:L
%         val = find(vals==seq{n}(l));
        if l==1
            alpha{n}(l,ids(seq{n}(l),:)) = ...
                sum(repmat(ip0',[1,idsSum(seq{n}(l))]).*...
                T(:,ids(seq{n}(l),:)),1);
%             alpha{n}(l,:) = ip0*T*O{val};
        else
            alpha{n}(l,ids(seq{n}(l),:)) = ...
                sum(repmat(alpha{n}(l-1,:)',[1,idsSum(seq{n}(l))]).*...
                T(:,ids(seq{n}(l),:)),1);
%             alpha{n}(l,:) = alpha{n}(l-1,:)*T*O{val};
        end
        if norm
            cl{n}(l) = sum(alpha{n}(l,:));
            alpha{n}(l,:) = alpha{n}(l,:)/cl{n}(l);
        end
    end
%     logP = logP + log(sum(alpha{n}(end,:)));
end

