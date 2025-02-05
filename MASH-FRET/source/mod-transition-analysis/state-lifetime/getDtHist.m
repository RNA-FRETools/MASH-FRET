function hist_ref = getDtHist(clust_dat, j1, j2, mols, excl, wght)

hist_ref = [];

% check for at least one/two transition in histogram
if isempty(clust_dat)
    return
end
if j2==0
    clust_k = clust_dat(clust_dat(:,7)==j1,:);
else
    clust_k = clust_dat(clust_dat(:,7)==j1 & clust_dat(:,8)==j2,:);
end
if size(clust_k,1)<=excl
    return
end
 
if isempty(mols)
    mols = unique(clust_dat(:,4)); % all molecules
end
nMol = numel(mols);

dt_j1j2 = cell(1,nMol);
w_vect = ones(nMol,1);

% extract dwell time histogram for transition j1->j2 and for each molecule
for m = 1:nMol
    clst_m = clust_dat(clust_dat(:,4)==mols(m),:);
    if excl 
        % exclude first dwell time of trajectory
        clst_m = clst_m(2:end-1,:);
    end
    
    if j2==0
        dt_j1j2{m} = clst_m((clst_m(:,7)==j1),1:end-2);
    else
        dt_j1j2{m} = clst_m(clst_m(:,7)==j1 & clst_m(:,8)==j2,1:end-2);
    end

    if wght
        % weight histograms according to the number of dwell times included
        w_vect(m,1) = sum(dt_j1j2{m}(:,1));
        if m == nMol
            w_vect = w_vect/sum(w_vect);
        end
    end
end

% concatenate dwell time histograms
hist_ref = [];
for m = 1:nMol
    hist_ref = cat(1,hist_ref,...
        [dt_j1j2{m}(:,1),w_vect(m)*ones(size(dt_j1j2{m},1),1)]);
end

hist_ref = sortrows(hist_ref,1);

[o,ia,ja] = unique(hist_ref(:,1));
hist_ref = hist_ref(ia,:);
for j = ja'
    hist_ref(j,2) = numel(find(ja==j));
end
hist_ref = [[0 0]; hist_ref];
hist_ref(:,3) = hist_ref(:,2)/sum(hist_ref(:,2));
hist_ref(:,4) = cumsum(hist_ref(:,2));
hist_ref(:,5) = 1-cumsum(hist_ref(:,3));
hist_ref(end,5) = 0;

