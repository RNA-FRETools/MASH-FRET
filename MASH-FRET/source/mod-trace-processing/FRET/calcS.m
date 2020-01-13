function S = calcS(exc, chanExc, FRET, I_den, gamma, beta)

nFRET = size(FRET,1);
L = size(I_den,1);
S = nan(L,nFRET);

for fret = 1:nFRET
    don = FRET(fret,1);
    acc = FRET(fret,2);
    ldon = find(exc==chanExc(don),1);
    lacc = find(exc==chanExc(acc),1);

    I_DD = I_den(:,don,ldon);
    I_othersD = sum(I_den(:,[1:(don-1),(don+1):end],ldon),2);
    I_AA = I_den(:,acc,lacc);
    I_othersA = sum(I_den(:,[1:(acc-1),(acc+1):end],lacc),2);
    
    S(:,fret) = (gamma(:,fret).*I_DD+I_othersD)./(gamma(:,fret).*I_DD+...
        I_othersD+I_AA./beta(:,fret)+I_othersA);
end