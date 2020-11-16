function err_cum = calcSeqError(dt_xp,dt_ref)

% find all possible sequence match
nSeg_xp = size(dt_xp,1);
nSeg_ref = size(dt_ref,1);
seg0 = 1:(nSeg_ref-nSeg_xp+1);
for s = 1:nSeg_xp
    seg0 = seg0(dt_ref(seg0+s-1,2)'==dt_xp(s,3));
end

% calculate cumulated error on dwell times
if isempty(seg0)
    err_cum = 1*nSeg_xp;
else
    err_cum = Inf;
    for s0 = seg0
        err = 0;
        for s = 1:nSeg_xp
            err = err + abs(dt_xp(s,1)-dt_ref(s0+s-1,1))/dt_xp(s,1);
        end
        if err<err_cum
            err_cum = err;
        end
    end
end
