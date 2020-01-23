function [S,incl] = getCorrectSid(S_old,FRET,exc,chanExc)

nS_old = size(S_old,1);
S = [];
incl = false(1,nS_old);

for s = 1:nS_old
    don = S_old(s,1);
    fret = find(FRET(:,1)==don);
    if isempty(fret)
        continue
    end
    accs = FRET(fret,2);
    for acc = accs
        lacc = exc==chanExc(acc);
        ldon = exc==chanExc(don);
        if ~isempty(lacc) && ~isempty(ldon)
            S = cat(1,S,[don,acc]);
            incl(s) = true;
            break
        end
    end
end

