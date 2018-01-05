function kin = getKinDat(dt)

kin = [];
dt = dt(1:(end-1),:); % remove last uknown state
dat = [];

val = unique(dt(:,2:3));
n = numel(val);

if size(dt,1) > 1 % more than one transition all in all
    for i = 1:n
        for j = 1:n
            if i ~= j
                [r,c,v] = find(dt(:,2) == val(i) & dt(:,3) == val(j));
                r(r==1) = [];
                n_trs = size(r,1);
                if n_trs > 0
                    t1_ij = sum(dt(r',1));
                else
                    t1_ij = 0;
                end
                tAv1_ij = t1_ij/n_trs;
                dat((size(dat,1)+1), 1:5) = [val(i) val(j) n_trs t1_ij ...
                    tAv1_ij];
            end
        end
    end

    for fwd = 1:size(dat,1)
        for bwd = 1:size(dat,1)
            if (fwd ~= bwd) && (dat(fwd,1) == dat(bwd,2)) && ...
                    (dat(fwd,2) == dat(bwd,1))
                kin((size(kin,1)+1),1:9) = [dat(fwd,1:3) dat(bwd,3) ...
                    dat(fwd,4) dat(bwd,4) dat(fwd,5) dat(bwd,5) ...
                    (dat(fwd,5)/dat(bwd,5))];
            end
        end
    end
end

