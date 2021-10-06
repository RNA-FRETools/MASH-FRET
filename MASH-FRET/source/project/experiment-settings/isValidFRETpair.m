function ok = isValidFRETpair(pairs,chanExc)
% ok = isValidFRETpair(pairs,chanExc)
%
% Check if experiment settings allow FRET calculations for the input
% donor-acceptor channel pair and return 1/0 upon validity/non-validity.
%
% pairs: [P-by-2] donor-acceptor channel indexes
% chanExc: vector containing channel-specific laser wavelengths

% initialize output
P = size(pairs,1);
ok = false(1,P);

% check for donor-specific laser and red-shifted acceptor excitation
for p = 1:P
    if chanExc(pairs(p,1))>0 && (chanExc(pairs(p,1))<chanExc(pairs(p,2)) || ...
            chanExc(pairs(p,2))==0)
        ok(p) = true;
    end
end

% look for duplicates
for p1 = 1:P
    for p2 = (p1+1):P
        if ok(p2) && ok(p1) && isequal(pairs(p1,:),pairs(p2,:))
            ok(p2) = false;
        end
    end
end