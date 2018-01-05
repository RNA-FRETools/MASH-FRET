function cp_corr = correl_cp(cp, tol)

nSet = size(cp,2)/2;
cp_corr = cell(1,nSet);

for t = 1:nSet
    [o,min_np] = min([size(cp{t*2-1},2) size(cp{t*2},2)]);
    chan_in = t*2-(2-min_np);
    chan_cmp = t*2-abs(1-min_np);
    for p = 1:numel(cp{chan_in})
        [o,i_p,o] = find(cp{chan_cmp} <= (cp{chan_in}(p)+tol/2) & ...
            cp{chan_cmp} >= (cp{chan_in}(p)-tol/2));
        if ~isempty(i_p)
            new_cp = round(mean([cp{chan_in}(p) cp{chan_cmp}(i_p)]));
            cp_corr{t} = [cp_corr{t} new_cp];
            cp{chan_cmp}(i_p) = [];
        end
    end
end