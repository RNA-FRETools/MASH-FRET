function prm = setDefKmean(prm)

minval = prm.plot{1}(1,2);
maxval = prm.plot{1}(1,3);
J = prm.clst_start{1}(3);
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);

nTrs = getClusterNb(J,mat,clstDiag);
if mat==2 % symmetrical
    Jcalc = ceil(0.5+sqrt(0.25+2*J));
elseif mat==3 % free
    Jcalc = ceil(0.5+sqrt(1+4*J)/2);
else % matrix
    Jcalc = J;
end

delta = (maxval-minval)/Jcalc;
mu = minval + delta*(0.5:(Jcalc-0.5))';
tol = delta*ones(Jcalc,1)/2;

if mat==1 % matrix
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,Jcalc,mat,clstDiag);
    prm.clst_start{2}(:,[1,2]) = [mu(j1),mu(j2)];
    prm.clst_start{2}(:,[3,4]) = [tol(j1),tol(j2)];
    
elseif mat==2 % symmetrical
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,Jcalc,true,false);
    mu = [mu(j1),mu(j2)];
    mu = mu(mu(:,1)<mu(:,2),:);
    tol = [tol(j1),tol(j2)];
    prm.clst_start{2}(:,[1,2]) = [mu(1:J,[1,2]);mu(1:J,[2,1])];
    prm.clst_start{2}(:,[3,4]) = [tol(1:J,[1,2]);tol(1:J,[2,1])];
    
else % free
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,Jcalc,true,false);
    mu = [mu(j1),mu(j2)];
    tol = [tol(j1),tol(j2)];
    prm.clst_start{2}(:,[1,2]) = mu(1:nTrs,[1,2]);
    prm.clst_start{2}(:,[3,4]) = tol(1:nTrs,[1,2]);
end

