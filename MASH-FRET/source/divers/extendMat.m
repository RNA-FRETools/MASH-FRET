function mat = extendMat(mat0,R,val)
% Extend the nb. of rows of a matrix and fill new rows with input value.
%
% mat = extendMat(mat0,L,val)
%
% trace: matrix to extend
% R0: nb. of rows to which the matrix must be extended
% val: values to fill in

if R<=0
    return
end
if isa(val,'logical')
    if val
        mat0 = ...
            cat(1,mat0,true(R-size(mat0,1),size(mat0,2),size(mat0,3)));
    else
        mat0 = cat(1,mat0,...
            false(R-size(mat0,1),size(mat0,2),size(mat0,3)));
    end
else
    mat0 = ...
        cat(1,mat0,val*ones(R-size(mat0,1),size(mat0,2),size(mat0,3)));
end
mat = mat0;