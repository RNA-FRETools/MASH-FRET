function clr = getDefTrClr(nExc, exc, nChan, nFRET, nS)

clr = cell(1,3);

b = zeros(nChan,nExc);

exc(exc==0) = [];
[o,idExc] = sort(exc);

r_itt = zeros(1,nExc);
gprov = fliplr(linspace(0,1,nExc+1));
g_itt = gprov(1:nExc);
id_l = 0;
for l = idExc
    id_l = id_l + 1;
    g(1:nChan,l) = fliplr(linspace(0,g_itt(id_l),nChan));
    r(1:nChan,l) = fliplr(linspace(1/l,r_itt(id_l),nChan));
end

for l = 1:nExc
    for c = 1:nChan
        clr{1}{l,c} = [r(c,l) g(c,l) b(c,l)];
    end
end

[o,id] = sort(exc,'ascend');
clr_prev = clr{1};
for c = 1:nChan
    clr{1}(:,c) = clr_prev(id,c);
end

r_f = fliplr(linspace(0.8,0,nFRET));
g_f = fliplr(linspace(0.8,0,nFRET));
b_f = fliplr(linspace(0.8,0,nFRET));
for n = 1:nFRET
    clr{2}(n,:) = [r_f(n) g_f(n) b_f(n)];
end

r_s = fliplr(linspace(0,0,nS));
g_s = fliplr(linspace(1,0,nS));
b_s = fliplr(linspace(1,1,nS));
for n = 1:nS
    clr{3}(n,:) = [r_s(n) g_s(n) b_s(n)];
end

