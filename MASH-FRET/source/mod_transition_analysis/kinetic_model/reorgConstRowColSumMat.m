function mat = reorgConstRowColSumMat(mat,isFixed,row,col,Nsum)

isFixed = ~~isFixed;

maxIter = 1000;
err = Inf;
tol = 1;
tol_val = 1;
nIter = 0;
while err>tol
    mat_prev = mat;
    if sum(mat(~isFixed(:,col),col))==0
        mat(~isFixed(:,col),col) = Nsum(col)-sum(mat(isFixed(:,col),col));
    else
        mat(~isFixed(:,col),col) = ...
            (Nsum(col)-sum(mat(isFixed(:,col),col)))*...
            mat(~isFixed(:,col),col)/sum(mat(~isFixed(:,col),col));
    end
    if sum(mat(row,~isFixed(row,:)))==0
        mat(row,~isFixed(row,:)) = Nsum(row)-sum(mat(row,isFixed(row,:)));
    else
        mat(row,~isFixed(row,:)) = ...
            (Nsum(row)-sum(mat(row,isFixed(row,:))))*...
            mat(row,~isFixed(row,:))/sum(mat(row,~isFixed(row,:)));
    end
    
    err = max(abs([sum(mat(:,col))-Nsum(col),...
        sum(mat(row,:))-Nsum(row)]));
    diffMat = abs(mat-mat_prev);
    nIter = nIter+1;
    if (err>tol && ~sum(sum(diffMat>tol_val))) || nIter>=maxIter
        mat = [];
        return
    end
end





