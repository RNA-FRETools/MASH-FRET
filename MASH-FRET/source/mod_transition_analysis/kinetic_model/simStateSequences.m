function res = simStateSequences(tp,ip,Ls)
% res = simStateSequences(tp,ip,Ls)
%
% Generate state sequences from probability-based parameters
%
% tp: [J-by-J] transition probability matrix
% r: [1-by-J] restricted rate constants (in frame-1)
% Ls: [1-by-N] trajectory lengths (in frame)
% ip: [1-by-J] initial state probabilities
% res: resturned results as a structure containing fields:
%  res.dt: [nDt-by-4] dwell times (molecule index, state durations (frames), state values before and after transition)
%  res.tp_exp: [J-by-J] transition probability matrix calculated from data
%  res.r_exp: [J-by-J] restricted rate matrix calculated from data
%  res.w_exp: [J-by-J] weighing factors calculated from data
%  res.n_exp: [J-by-J] numbers of transitions calculated from data

% initialize output
res = [];

J = size(tp,2);
N = numel(Ls);

% calculate initial state probabilities
r = sum(tp,2)-diag(tp);
r(r==0) = 1E-6;

Js = 1:J;
w = tp;
w(~~eye(size(tp))) = 0;
w = w./repmat(sum(w,2),[1,J]);
w(isnan(w)) = 0;

% generate state sequence in a frame-wise fashion
dt = [];
for j = 1:J
    j2s = Js(Js~=j);
    tp(j,j) = 1-exp(-sum(tp(j,j2s),2));
end
for n = 1:N
    seq = zeros(Ls(n),1);
    draw0 = rand(1);
    id = find(cumsum(ip)>draw0);
    state1 = id(1);
    seq(1,1) = state1;
    for l = 2:Ls(n)
        draw1 = rand(1);
        istrans = draw1<=tp(state1,state1);
        if istrans
            draw2 = rand(1);
            states2 = Js(Js~=state1);
            id = find(cumsum(w(state1,states2))>draw2);
            if ~isempty(id)
                state2 = states2(id(1));
            else
                state2 = state1;
            end
        else
            state2 = state1;
        end
        seq(l,1) = state2;
        state1 = state2;
    end
    dt_n = getDtFromDiscr(seq,1);
    dt = cat(1,dt,[dt_n(:,1),repmat(n,[size(dt_n,1),1]),dt_n(:,2:end)]);
end
    
% generate state sequence in a dwell time-wise fashion
% dt = [];
% l = 0;
% while l<L
%     if ~isinf(r(state1))
%         % draw a dwell time (in number of data points)
%         dl = random('exp',1/(r(state1)));
%         if (l+dl)>L
%             dl = L-l;
%         end
%         l = l+dl;
%     end
%     if sum(w(state1,:))==0
%         state2 = state1;
%     else
%         draw = rand(1);
%         states2 = Js(Js~=state1);
%         id = find(cumsum(w(state1,states2))>draw);
%         if isempty(id)
%             state2 = states2(end);
%         else
%             state2 = states2(id(1));
%         end
% %         state2 = randsample(1:J,1,true,w(state1,:));
%     end
%     dt = cat(1,dt,[dl,state1,state2]);
%     state1 = state2;
% end
% seq = getDiscrFromDt(dt,1);
% 
% % get dwell times from state sequences
% dt = [];
% l2 = 0;
% for n = 1:N
%     L = Ls(n);
%     l1 = l2+1;
%     l2 = l2+L;
%     dt_n = getDtFromDiscr(seq(l1:l2),1);
%     dt = cat(1,dt,[dt_n(:,1),repmat(n,[size(dt_n,1),1]),dt_n(:,2:end)]);
% end

% recover experimental probabilities and transition numbers
k_exp = zeros(J);
n_exp = zeros(J);
for j1 = 1:J
    dt_j1 = dt(dt(:,3)==j1,:);
    for j2 = 1:J
        if j1==j2
            continue
        end
        dt_j1j2 = dt_j1(dt_j1(:,4)==j2,1);
        n_exp(j1,j2) = numel(dt_j1j2);
        k_exp(j1,j2) = n_exp(j1,j2)/sum(dt_j1(:,1));
    end
end
if size(ip,1)>1
    ip = ip';
end
res.ip = ip;
res.dt = dt;
res.k_exp = k_exp;
res.n_exp = n_exp;
res.w_exp = n_exp./repmat(sum(n_exp,2),[1,J]);
res.tp_exp = k_exp;
res.tp_exp(~~eye(size(k_exp))) = 1-sum(k_exp,2);



