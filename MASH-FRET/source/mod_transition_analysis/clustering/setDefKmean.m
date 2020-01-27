function prm = setDefKmean(prm)

Kmax = prm.clst_start{1}(3);
minval = prm.plot{1}(1,2);
maxval = prm.plot{1}(1,3);

delta = (maxval-minval)/(Kmax+1);

prm.clst_start{2}(:,1) = minval + delta*(1:Kmax)';
prm.clst_start{2}(:,2) = Inf*ones(Kmax,1);