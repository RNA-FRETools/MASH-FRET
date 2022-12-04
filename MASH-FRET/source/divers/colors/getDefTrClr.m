function clr = getDefTrClr(nExc, exc, nChan, nFRET, nS)

% Last update: by MH, 3.4.2019
% >> review default color calculation: (1) build a gradient from bright
%    green to bright red passing by bright orange made of 100 RGB colors
%    (2) select equally spaced channel-specific colors (3) build a gradient
%    from bright channel color to dark channel color for laser-specific
%    colors

grad_size = 100;

clr = cell(1,3);
clr{1} = cell(nExc,nChan);

% grad_size = 2*round(grad_size/2);

rgb_min = [0,1,0];
rgb_med = [1,0.5,0];
rgb_max = [1,0,0];

rgb_grad = [linspace(rgb_min(1),rgb_med(1),1+grad_size/2); ...
    linspace(rgb_min(2),rgb_med(2),1+grad_size/2); ...
    linspace(rgb_min(3),rgb_med(3),1+grad_size/2)];
rgb_grad(:,end) = [];
rgb_grad = cat(2,rgb_grad,...
    [linspace(rgb_med(1),rgb_max(1),grad_size/2); ...
    linspace(rgb_med(2),rgb_max(2),grad_size/2); ...
    linspace(rgb_med(3),rgb_max(3),grad_size/2)]);

if nChan>1
    iv = round((grad_size/(nChan-1))-1);
else
    iv = 0;
end

[o,id] = sort(exc,'ascend');
for c = 1:nChan
    for l = 1:nExc
        clr{1}{id(l),c} = (nExc/(nExc*l))*rgb_grad(:,1+(c-1)*iv);
    end
end

% b = zeros(nChan,nExc);
% 
% exc(exc==0) = [];
% [o,idExc] = sort(exc);
% 
% r_itt = zeros(1,nExc);
% gprov = fliplr(linspace(0,1,nExc+1));
% g_itt = gprov(1:nExc);
% id_l = 0;
% for l = idExc
%     id_l = id_l + 1;
%     g(1:nChan,l) = fliplr(linspace(0,g_itt(id_l),nChan));
%     r(1:nChan,l) = fliplr(linspace(1/l,r_itt(id_l),nChan));
% end
% 
% for l = 1:nExc
%     for c = 1:nChan
%         clr{1}{l,c} = [r(c,l) g(c,l) b(c,l)];
%     end
% end
% 
% [o,id] = sort(exc,'ascend');
% clr_prev = clr{1};
% for c = 1:nChan
%     clr{1}(:,c) = clr_prev(id,c);
% end

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

