function tr = binDiscrVal(tol, tr)
if tol > 0
    rev = 0;
    if size(tr,2) > size(tr,1)
        rev = 1;
        tr = tr';
    end
    [val,o,o] = unique(tr);
    over = 0;
    newVal = val;
    while ~over
        over = 1;
        for i = 1:size(val,1)
            [r1,c1,v1] = find(val ~= val(i,1) & val >= (val(i,1)-tol) & ...
                val <= (val(i,1)+tol));
            if ~isempty(r1)
                newVal(i,1) = mean([val(i,1);val(r1',1)]);
                [r,o,o] = find(tr == val(i,1));
                tr(r',1) = newVal(i,1);
                over = 0;
            end
        end
        [val,o,o] = unique(tr);
    end
    
    if rev
        tr = tr';
    end
end