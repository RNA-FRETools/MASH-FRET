function [schm,schm_tp] = PHschm_nfp(nfp,sumexp,Dmin,Dmax,schm_tp)
% [schm,schm_tp] = PHschm_nfp(nfp,sumexp,Dmax,schm_tp)
%
% Determine all valid transition schemes that use a specific number of free
% parameters.
% The number of free parameters include the number of strictly positive 
% initial (IP), non-diagonal transition (TP) and exit (EP) probabilities 
% and is calculated as: nfp = (IP-1) + TP + EP
%
% nfp: number of free PH parameters
% sumexp: 1 to return transition schemes only for hyperexponential PH, 0
%         otherwise
% Dmax: maximum number of states
% schm: {1-by-S} PH transition schemes
% schm_tp: {1-by-Dbig}{1-by-nbig} already calculated transition schemes
%          for transition probabilities only
% 
% example:
% >> schm = getTransSchemesWithNfreePrm(4,false,2)

% initialize output
schm = [];

% return hyperexponential scheme
if sumexp
    D = (nfp+1)/2;
    if round(D)~=D || D>Dmax
        return
    end
    schm = zeros(D+2,D+2);
    schm(1,2:end-1) = 1; % initial state probabilities
    schm(2:end-1,end) = 1; % exit probabilities
    schm = {schm};
    return
end

% determine bounds of state degeneracies
Dmax = min([nfp,Dmax]);
Dmin = max([Dmin,ceil((sqrt(4*(nfp+1))-1)/2)]);
if Dmax<Dmin
    schm = Inf;
    return
end

% collect already calculated schemes
if numel(schm_tp)<Dmax
    schm_tp = [schm_tp cell(1,Dmax-numel(schm_tp))];
end

% calculate transition schemes
for D = Dmin:Dmax
    [schm_D,schm_tp] = fillPHtransSchemeWithNprob(D,nfp+1,schm_tp);
    if isempty(schm_D)
        continue
    end
    for s = 1:size(schm_D,3)
        if isempty(schm)
            schm = {};
        end
        schm = cat(2,schm,schm_D(:,:,s));
    end
end


function [schm,schm_tp] = fillPHtransSchemeWithNprob(D,n,schm_tp)
% [schm,schm_tp] = fillPHtransMatWithNtrans(D,n,schm_tp)
% 
% Return all valid transition schemes for D degenerate states and n free 
% probabilities
%
% D: state degeneracy
% n: number of free probabilities (initial, transition and exit probabilities)
% schm: [(D+2)-by-(D+2)-by-S] transition schemes
% schm_tp: {1-by-Dbig}{1-by-nbig} transition schemes for transition probabilties only

% initializes output
schm = int8([]);

% collect already calculated transition schemes
n_tp_max = n-2;
if numel(schm_tp)<D
    schm_tp = [schm_tp,cell(D-numel(schm_tp))];
end
n_tp_0 = numel(schm_tp{D});
if n_tp_0<(n_tp_max+1)
    schm_tp{D} = [schm_tp{D},cell(1,n_tp_max+1-n_tp_0)];
end

% build PH transition schemes
cmb_all = uint8([]);
sum_cmb = uint8([]);
for n_ip = 1:D 
    
    % add all possible initial state schemes
    ip = ~~getFromTransNbRepart(1,n_ip,D);
    for c_ip = 1:size(ip,1)

        for n_ep = 1:D 
            n_tp = n-n_ip-n_ep; % state transition probabilities
            if n_tp<0 || n_tp>(D*(D-1))
                continue
            end

            % get all possible transition schemes
            id = n_tp+1;
            if isempty(schm_tp{D}{id})
                schm_tp{D}{id} = getTransSchemesForNtrans(D,n_tp);
            end
            
            for s = 1:size(schm_tp{D}{id},3)
                
                % check for non-connected states
                if ~all(sum([ip(c_ip,:);schm_tp{D}{id}(:,:,s)],1))
                    continue
                end

                % add all possible exit schemes
                ep = ~~getFromTransNbRepart(1,n_ep,D);
                for c_ep = 1:size(ep,1)

                    % check for absorbing states
                    if ~all(sum([schm_tp{D}{id}(:,:,s),ep(c_ep,:)'],2))
                        continue
                    end
                    
                    % check transition path
                    schm_s = uint8(cat(1,[0,ip(c_ip,:),0],...
                        [zeros(D,1),schm_tp{D}{id}(:,:,s),ep(c_ep,:)'],...
                        false(1,D+2)));
                    if ~isValidTransPath(schm_s)
                        continue
                    end

                    % check if valid state connectivity is already saved
                    cmb = [schm_s(1,2:end-1);schm_s(2:end-1,end)';...
                        sum(schm_s(2:end-1,2:end-1),1);...
                        sum(schm_s(2:end-1,2:end-1),2)'];
                    [~,ord2] = sort(cmb(3,:));
                    cmb = cmb(:,ord2');
                    [~,ord1] = sort(cmb(4,:));
                    cmb = cmb(:,ord1');
                    
                    duplicate = false;
                    if ~isempty(sum_cmb) 
                        issamesum = all(sum_cmb==sum(cmb,2),1);
                        if any(issamesum)
                            for shft = 0:D-1
                                ds = circshift(1:D,shft);
                                cmbshft = [cmb([1,2],ds);cmb([3,4],:)];
                                if any(all(cmb_all(:,:,issamesum)==cmbshft,...
                                        [1,2]))
                                    duplicate = true;
                                    break
                                end
                            end
                        end
                    end
                    if duplicate
                        continue 
                    end

                    % save scheme
                    cmb_all = cat(3,cmb_all,cmb);
                    sum_cmb = cat(2,sum_cmb,sum(cmb,2));
                    schm = cat(3,schm,schm_s);
                end
            end
        end
    end
end


function schm = getTransSchemesForNtrans(D,n)
        
% get all transition repartition possibilities
rprt = getFromTransNbRepart(D-1,n,D);

% select valid and unique state connectivities
R = size(rprt,1);
cn_all = int8([]);
for to = 1:R
    for from = 1:R

        % state connectivity
        cn = rprt([to,from],:);

        % check if state connectivity is coherent
        if ~isValidConnect(cn)
            continue
        end

        % sort states by transition numbers (1st: to, 2nd: from)
        [~,ord_to] = sort(cn(2,:));
        cn = cn(:,ord_to');
        [~,ord_from] = sort(cn(1,:));
        cn = cn(:,ord_from');

        % check if valid state connectivity is already saved
        duplicate = false;
        if ~isempty(cn_all) && any(all(cn_all==cn,[1,2]))
            duplicate = true;
        end
        if duplicate
            continue 
        end

        % save state conectivity
        cn_all = cat(3,cn_all,cn);
    end
end

% find corresponding transition matrices
C = size(cn_all,3);
ok = false(1,C);
schm = int8(false(D,D,C));
for c = 1:C
    % include no-transition matrix
    if all(cn_all(:,:,c)==0,[1,2])
        schm(:,:,c) = int8(false(D,D,C));
        ok(c) = true;
        continue
    end

    cn = cn_all(:,:,c);
    pth = false(D,D);
    for j1 = 1:D
        if ~isempty(cn) && all(all(cn==0))
            break
        end
        if cn(1,j1)==0
            continue
        end
        pth_prev = pth;
        cn_prev = cn;
        [pth,cn] = getTransPath(cn,pth,j1);
        if isempty(pth)
            pth = pth_prev;
            cn = cn_prev;
        end
    end
    if ~isempty(cn) && all(all(cn==0))
        schm(:,:,c) = int8(~~pth);
        ok(c) = true;
    end
end
schm = schm(:,:,ok);


function vects = getFromTransNbRepart(nTrd_max,nTr,D)
% vects = getFromTransNbRepart(nTrd_max,nTr,D)
%
% Returns all possible repartitions of a constant number of transitions 
% from D that can make no more than a maximum number of transition each.
%
% nTrd_max: maximum number of transitions from a single state
% nTr: total number of connexions to partition
% D: number of states
% vects: [nCmb-by-D] possible repartitions of transitions

vects = [];
if nTr<0 || nTrd_max<0 || D<=0
    return
end

% control maximum number of transitions to partition
if (nTr/nTrd_max)>D
    fprintf(['Too many transitions (%i) for %i states with max. %i ',...
        'transitions each.\n'],nTr,D,nTrd_max);
    return
end

for nCxj = min([nTrd_max,nTr]):-1:0
    % control sufficient number of states to partition leftover transitions
    if (nTr-nCxj)>((D-1)*nTrd_max)
        continue
    end
    
    % set transition number for current state
    vect = zeros(1,D);
    vect(1) = nCxj;
    
    % repeat with next states
    if (D-1)>0 && (nTr-nCxj)>=0
        cmb = getFromTransNbRepart(nTrd_max,nTr-nCxj,D-1);
        vect = [repmat(nCxj,size(cmb,1),1),cmb];
    end
    
    % append possible transition repartitions
    vects = cat(1,vects,vect);
end


function ok = isValidConnect(cn0)
% ok = isValidConnect(cn)
%
% Determine whether state connectivities are coherent
%
% cn: [2-by-D] state connectivities (1st: transition from, 2nd: transitions to)
% ok: 1 if state connectivities are valid, 0 otherwise

ok = true;
D = size(cn0,2);

% test state connectivities with circular shift
cn = cn0;
for d1 = 1:D
    % select all possible recieving states
    d2s = circshift(1:D,[0,d1-1]);
    d2s(d2s==d1) = [];
    
    % subtract state 1's connexions to states 2's
    i2 = 0;
    while cn(1,d1)>0 && i2<(D-1)
        i2 = i2+1;
        if cn(2,d2s(i2))>=1
            cn(2,d2s(i2)) = cn(2,d2s(i2))-1;
            cn(1,d1) = cn(1,d1)-1;
        end
    end
end
if all(all(cn==0)) % all connections are fullfilled
    return
end

% test state connectivities without shift
cn = cn0;
for d1 = 1:D
    d2s = 1:D;
    d2s(d2s==d1) = [];
    i2 = 0;
    while cn(1,d1)>0 && i2<(D-1)
        i2 = i2+1;
        if cn(2,d2s(i2))>=1
            cn(2,d2s(i2)) = cn(2,d2s(i2))-1;
            cn(1,d1) = cn(1,d1)-1;
        end
    end
end
if all(all(cn==0)) % all connections are fullfilled
    return
end

% not all state conenctions are fullfilled: incoherent model
ok = false;


function [pth,schm] = getTransPath(schm,pth,d1)

D = size(schm,2);
d2s = [(d1+1):D,1:(d1-1)];
for d2 = d2s
    schm_prev = schm;
    pth_prev = pth;
    if pth(d1,d2)==true % cell in transition matrix already occupied
        schm = schm_prev;
        pth = pth_prev;
        continue
    end
    schm(1,d1) = schm(1,d1)-1;
    schm(2,d2) = schm(2,d2)-1;
    pth(d1,d2) = true;
    if all(all(schm==0))
        break
    end
    if sum(sum(schm<0)) || ...% negative number of remaining transitions
            (sum(schm(1,:)>0)==1 && sum(schm(2,:)>0)==1 && ...
            isequal(schm(1,:),schm(2,:)))% only 1->1 transition possible
        schm = schm_prev;
        pth = pth_prev;
        continue
    end
    
    d1_next = d1+1;
    if d1_next>D
        d1_next = 1;
    end
    while schm(1,d1_next)==0
        d1_next= d1_next+1;
        if d1_next>D
            d1_next = 1;
        end
    end
    [pth,schm] = getTransPath(schm,pth,d1_next);

    if ~isempty(schm) && all(all(schm==0))
        break
    end
    if isempty(schm) || sum(sum(schm<0)) || ...% negative number of remaining transitions
            (sum(schm(1,:)>0)==1 && sum(schm(2,:)>0)==1 && ...
            isequal(schm(1,:),schm(2,:)))% only 1->1 transition possible
        schm = schm_prev;
        pth = pth_prev;
    end
end
if isequal(schm,schm_prev) % dead end
    pth = [];
    schm = [];
end


function ok = isValidTransPath(schm0)
% ok = isValidTransPath(schm)
%
% Check if the transition scheme allows to reach and exit all states.
%
% schm: [D+2-by-D+2] PH transition scheme
% ok: 1 if scheme is valid, 0 otherwise

% initializes output
ok = false;

D = size(schm0,1)-2;
rched = false(1,D); % 1 if state can be reached, 0 otherwise
exted = false(1,D); % 1 if state can exit, 0 otherwise

% get entry and exit states
d0s = find(schm0(1,2:(end-1)));
exted(~~schm0(2:(end-1),end)') = true;

% follow all possible paths
schm_prev = false(size(schm0));
[rched,exted,~] = followTransPath(0,d0s,schm0,schm_prev,rched,exted);

% check for convergence
if all([rched,exted])
    ok = true;
end


function [rched,exted,schm] = followTransPath(d1,d2s,schm0,schm_prev,rched,...
    exted)

schm = schm_prev;
for d2 = d2s
    
    % mark transition as tested
    schm(d1+1,d2+1) = 1;
    
    % mark states as reached
    D = size(schm0,1)-2;
    d_next = find(schm0(d2+1,2:end));
    rched(d2) = true;
    rched(d_next(d_next<(D+1))) = true;

    % mark states as exited
    if any(d_next==(D+1))
        schm(d2+1,D+2) = 1;
        exted(d2) = true;
        d_next(d_next==(D+1)) = []; % remove absorbing state
    end
    if any(exted(d_next))
        exted(d2) = true;
    end

    % check for convergence
    if all([rched,exted])
        return
    end

    % continue
    if all(schm==schm_prev)
        continue
    end
    schm_prev = schm;

    % follow all possible path
    if isempty(d_next)
        continue
    end
    [rched,exted,schm] = followTransPath(d2,d_next,schm0,schm_prev,rched,...
        exted);
    if d1>0 && any(exted(d_next))
        exted(d1) = true;
    end
end


