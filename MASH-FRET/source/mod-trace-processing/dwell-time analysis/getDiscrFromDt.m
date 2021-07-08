function discr = getDiscrFromDt(dt, expT)

% dt(:,1) = round(dt(:,1)/rate);
% discr(1:dt(1,1),1) = dt(1,2);
% for l = 2:size(dt,1)
%     discr((size(discr,1)+1):(size(discr,1)+dt(l,1)),1) = dt(l,2);
% end

dt(:,1) = dt(:,1)/expT;
states = unique(dt(:,2));
L = ceil(sum(dt(:,1)));
J = numel(states);
seq = zeros(J,L);
curs = 0;
nDt = size(dt,1);
for i = 1:nDt
    curr_l = ceil(curs);
    if curs==curr_l
        curr_l = curr_l+1;
    end
    
    tofill = 1-sum(seq(:,curr_l));
    if tofill>dt(i,1)
        tofill = dt(i,1);
    end
    fillup = floor(dt(i,1)-tofill);
    remains = dt(i,1)-tofill-fillup;
    j = find(states==dt(i,2));
    
    seq(j,curr_l) = tofill;
    if fillup>0
        seq(j,(curr_l+1):(curr_l+fillup)) = 1;
    end
    if remains>0 && (curr_l+fillup+1)<=L
        seq(j,curr_l+fillup+1) = remains;
    end
    
    curs = curs+dt(i,1);
end

[~,seq] = max(seq,[],1);
discr = states(seq,1);

