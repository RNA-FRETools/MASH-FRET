function discr_ave = aveStates(tr, discr)
val = unique(discr);
discr_ave = nan(size(discr));
for i = 1:size(val,2)
    discr_ave(1,(discr(1,:) == val(i))) = ...
        mean(tr(1,(discr(1,:) == val(i))));
end