function prm = setDefKmean(prm)

minval = prm.plot{1}(1,2);
maxval = prm.plot{1}(1,3);
J = prm.clst_start{1}(3);
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);

nTrs = getClusterNb(J,mat,clstDiag);
if ~mat
    J = ceil(sqrt(J));
end

delta = (maxval-minval)/(J+1);
mu = minval + delta*(1:J)';
tol = Inf*ones(J,1);

if mat
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
    prm.clst_start{2}(:,[1,2]) = [mu(j1),mu(j2)];
    prm.clst_start{2}(:,[3,4]) = [tol(j1),tol(j2)];
else
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,true,true);
    mu = [mu(j1),mu(j2)];
    tol = [tol(j1),tol(j2)];
    prm.clst_start{2}(:,[1,2]) = mu(1:nTrs,[1,2]);
    prm.clst_start{2}(:,[3,4]) = tol(1:nTrs,[1,2]);
end

