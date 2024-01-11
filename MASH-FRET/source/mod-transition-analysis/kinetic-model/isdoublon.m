function dbl = isdoublon(tp)

% defaults
maxdiff = 1E-4; % maximum transition probability gap between different states

dbl = false;
V = size(tp,1);
for v1 = 1:V
    for v2 = 1:V
        if v2==v1
            continue
        end
        vs = 1:V;
        vs([v1,v2]) = [];
        maxdiff12 = max(abs(tp(v1,[v1,vs])-tp(v2,[v2,vs])));
        if maxdiff12<maxdiff
            dbl = true;
            return
        end
    end
end