function dbl = isdoublon(tp)
% dbl = isdoublon(tp)
%
% Checks if states equivalent in their transition probabilities exist.
%
% tp: [D-by-(D or D+1)] transition probability matrix

% defaults
maxdiff = 1E-4; % maximum transition probability gap between equivalent states
dbl = false;

% sorts states according to their lifetimes
D = size(tp,1);
id = sortStates(ones(1,D),1./(1-diag(tp(1:D,1:D))));
tp(1:D,1:D) = reorderMat(tp(1:D,1:D),id);

% checks for doublons
for d1 = 1:D
    for d2 = 1:D
        if d2==d1
            continue
        end
        
        % gets states indexes other than d1 and d2
        vs = 1:D+1;
        vs([d1,d2]) = [];
        
        % checks for at least one trans. prob. (d1->vs and d1->d1) that is 
        % sufficiently apart from (d2->vs and d2->d2).
        maxdiff12 = max(abs(tp(d1,[d1,vs])-tp(d2,[d2,vs])));
        if maxdiff12<maxdiff
            dbl = true;
            return
        end
    end
end
