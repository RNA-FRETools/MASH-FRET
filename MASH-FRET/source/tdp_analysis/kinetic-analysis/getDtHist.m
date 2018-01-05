function hist_ref = getDtHist(dat, excl, wght)

mols = unique(dat(:,4));
nMol = numel(mols);

dt = cell(1,nMol);
w_vect = ones(nMol,1);
for m = 1:nMol
    dt{m} = dat(dat(:,4)==mols(m),1);
    if excl
        dt{m} = dt{m}(2:end,:);
    end
    if wght
        w_vect(m,1) = sum(dt{m}(:,1));
        if m == nMol
            w_vect = w_vect/sum(w_vect);
        end
    end
end

hist_ref = [];
for m = 1:nMol
    hist_ref = [hist_ref; [dt{m}(:,1) w_vect(m)*ones(size(dt{m},1),1)]];
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

