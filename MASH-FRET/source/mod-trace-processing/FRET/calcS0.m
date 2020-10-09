function S_tr = calcS0(exc, chanExc, S, FRET, I_den, gamma, beta)

nS = size(S,1);
L = size(I_den,1);
S_tr = nan(L,nS);

for s = 1:nS
    don = S(s,1);
    acc = S(s,2);
    ldon = find(exc==chanExc(don),1);
    lacc = find(exc==chanExc(acc),1);
    
    fret = find(FRET(:,1)==don & FRET(:,2)==acc);

    I_DD = I_den(:,don,ldon);
    I_othersD = sum(I_den(:,[1:(don-1),(don+1):end],ldon),2);
    I_AA = I_den(:,acc,lacc);
    I_othersA = sum(I_den(:,[1:(acc-1),(acc+1):end],lacc),2);
    
    S_tr(:,s) = (gamma(:,fret).*I_DD+I_othersD)./(gamma(:,fret).*I_DD+...
        I_othersD+I_AA./beta(:,fret)+I_othersA);
end