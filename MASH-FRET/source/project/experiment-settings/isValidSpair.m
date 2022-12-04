function ok = isValidSpair(pairs,FRETpairs,chanExc)
% ok = isValidSpair(pairs,chanExc)
%
% Check if experiment settings allow stoichiometry calculations for the 
% input donor-acceptor channel pair and return 1/0 upon validity/
% non-validity.
%
% pairs: [P-by-2] donor-acceptor channel indexes
% FRET pairs: [P2-by-2]  channel indexes of donor-acceptor used in FRET calculations
% chanExc: vector containing channel-specific laser wavelengths

% initialize output
P = size(pairs,1);
ok = false(1,P);

% check for existing FRET pair and acceptor-specific laser
P2 = size(FRETpairs,1);
for p = 1:P
    for p2 = (p+1):P2
        if isequal(pairs(p,:),FRETpairs(p2,:)) && ...
                isValidFRETpair(FRETpairs(p2,:),chanExc)
            ok(p) = true;
        end
    end
    if ~(chanExc(pairs(p,2))>0)
        ok(p) = false;
    end
end

% look for duplicates
for p = 1:P
    for p2 = (p+1):P
        if ok(p2) && ok(p) && isequal(pairs(p,:),pairs(p2,:))
            ok(p2) = false;
        end
    end
end
