function mat = setTransProb(mat,j1,j2,step,opt)
% mat = setTransProb(mat,j1,j2,step,opt)
%
% Increment one cell of the transition probability matrix and recalculate other cells accordingly
%
% mat: probability matrix
% j1: row index of cell to increment
% j2: column index of cell to increment
% step: increment (positive or negative)
% opt: 'w' if the matrix has zero diagonal probabilities or 'tp' otherwise

% default
pmax = 1;
pmin = 0;

J = size(mat,2);

switch opt
    case 'w'
        j2s = find((1:J)~=j2 & (1:J)~=j1);
    case 'tp'
        j2s = find((1:J)~=j2);
end

% increment current transition probability
if step>0
    if (mat(j1,j2)+step)>=pmax
        mat(j1,j2) = pmax;
    else
        mat(j1,j2) = mat(j1,j2)+step;
    end
else
    if (mat(j1,j2)+step)<=pmin
        mat(j1,j2) = pmin;
    else
        mat(j1,j2) = mat(j1,j2)+step;
    end
end

if sum(mat(j1,j2s))==0
    mat(j1,j2s) = (pmax-mat(j1,j2))/numel(j2s);
else
    mat(j1,j2s) = (pmax-mat(j1,j2))*mat(j1,j2s)/sum(mat(j1,j2s));
end

% cancel matrix leading to dead-end states or state equilibrium
w = mat;
w(~~eye(size(w))) = 0;
if sum(sum(w,2)==0) || sum(sum(w,1)==0)
    mat = [];
    return
end
w = w./repmat(sum(w,2),[1,size(w,2)]);
for j = 1:J
    if (sum(w(j,:)>0)==1 && sum(w(w(j,:)>0,:)>0)==1 && ...
            find(w(w(j,:)>0,:)>0)==j)
        mat = [];
        return
    end
end