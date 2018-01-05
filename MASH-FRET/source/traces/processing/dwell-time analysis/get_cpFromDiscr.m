function cp = get_cpFromDiscr(discr)

nSet = size(discr,2);
cp = cell(1,nSet);

for n = 1:nSet
    p = 1;
    next = 0;
    while ~isempty(next)
        [next,o,o] = find(discr((p+1):end-1,n) ~= discr(p,n));
        if ~isempty(next)
            p = p + next(1);
            cp{n} = [cp{n} p];
        end
    end
end