function trans_mat = getTransSchemes(D)
% trans_mat = getTransSchemes(D)
%
% Returns all possible transition schemes between D states.
% Transition schemes consist of matrices filled with 0 (no transition) and 
% 1 (transition occurs).
%
% D: number of states
% Ntr_max: maximum number of transitions allowed
% trans_mat: [D-by-D-by-S] possible transition schemes

% get all possible combinations of number of transitions
cxcmb = getConnexionComb(D-1,D);

% sort connexion number combinations by total sums
cxcmb = sortrows([cxcmb,sum(cxcmb,2)],D+1);
Ntr_cnx = cxcmb(:,end);
cxcmb = cxcmb(:,1:(end-1));

% select valid and unique combinations of number of transitions
cmb_all = [];
for Ntr = unique(Ntr_cnx)'
    rows = find(Ntr_cnx==Ntr);
    for r_to = rows'
        for r_from = rows'
            cmb = cxcmb([r_to,r_from],:);
            if ~isValidScheme(cmb)
                continue
            end

            [~,ord2] = sort(cmb(2,:));
            cmb = cmb(:,ord2');
            [~,ord1] = sort(cmb(1,:));
            cmb = cmb(:,ord1');
            duplicate = false;
            for k = 1:size(cmb_all,3)
                if isequal(cmb_all(:,:,k),cmb)
                    duplicate = true;
                    break
                end
            end
            if duplicate
                continue 
            end
            cmb_all = cat(3,cmb_all,cmb);
        end
    end
end

% find corresponding transition matrices
C = size(cmb_all,3);
ok = false(1,C);
trans_mat = NaN(D,D,C);
for c = 1:C
    
    % include no-transition matrix
    if all(all(cmb_all(:,:,c)==0))
        trans_mat(:,:,c) = false(D,D);
        ok(c) = true;
        continue
    end
    
    %
    scheme = cmb_all(:,:,c);
    pth = false(D,D);
    for j1 = 1:D
        if ~isempty(scheme) && all(all(scheme==0))
            break
        end
        if scheme(1,j1)==0
            continue
        end
        pth_prev = pth;
        scheme_prev = scheme;
        [pth,scheme] = getTransPath(scheme,pth,j1);
        if isempty(pth)
            pth = pth_prev;
            scheme = scheme_prev;
        end
    end
    if ~isempty(scheme) && all(all(scheme==0))
        trans_mat(:,:,c) = pth;
        ok(c) = true;
    end
end


function vects = getConnexionComb(nCxd_max,D)
% vects = getConnexionComb(nCxd_max,D)
%
% Returns all possible combinations of numbers of connexions between D 
% states that can make no more than a maximum number of connexions with 
% other states.
%
% nCxd_max: maximum number of connexion from a single state
% D: number of states
% vects: [nCmb-by-D] possible combinations of number of connexions

vects = [];
if D<0
    return
end

for nCxj = 0:nCxd_max
    vect = zeros(1,D);
    vect(1) = nCxj;
    if (D-1)>0
        cmb = getConnexionComb(nCxd_max,D-1);
        vect = [repmat(nCxj,size(cmb,1),1),cmb];
    end
    vects = cat(1,vects,vect);
end


function ok = isValidScheme(scheme0)
% ok = isValidScheme(scheme0)
%
% Determine if a combination of number of state connexions is valid or not.
%
% scheme0: [2-by-D] numbers of connexions between states 1 (1st row) and 
%  states 2 (2nd row)
% ok: 0 (invalid scheme) or 1 (valid scheme)

ok = true;
D = size(scheme0,2);

scheme = scheme0;
for d1 = 1:D
    % select all possible states 2
    d2s = circshift(1:D,[0,d1-1]); % with circular shift
    d2s(d2s==d1) = [];
    
    % subtract state 1's connexions to states 2's
    i2 = 0;
    while scheme(1,d1)>0 && i2<(D-1)
        i2 = i2+1;
        if scheme(2,d2s(i2))>=1
            scheme(2,d2s(i2)) = scheme(2,d2s(i2))-1;
            scheme(1,d1) = scheme(1,d1)-1;
        end
    end
end

if ~all(all(scheme==0))
    scheme = scheme0;
    for d1 = 1:D
        d2s = 1:D;
        d2s(d2s==d1) = []; % without circular shift
        i2 = 0;
        while scheme(1,d1)>0 && i2<numel(d2s)
            i2 = i2+1;
            if scheme(2,d2s(i2))>=1
                scheme(2,d2s(i2)) = scheme(2,d2s(i2))-1;
                scheme(1,d1) = scheme(1,d1)-1;
            end
        end
    end
end

if ~all(all(scheme==0))
    ok = false;
    return
end


function [pth,scheme] = getTransPath(scheme,pth,j1)

J = size(scheme,2);
j2s = [(j1+1):J,1:(j1-1)];
for j2 = j2s
    scheme_prev = scheme;
    pth_prev = pth;
    if pth(j1,j2)==true % cell in transition matrix already occupied
        scheme = scheme_prev;
        pth = pth_prev;
        continue
    end
    scheme(1,j1) = scheme(1,j1)-1;
    scheme(2,j2) = scheme(2,j2)-1;
    pth(j1,j2) = true;
    if all(all(scheme==0))
        break
    end
    if sum(sum(scheme<0)) || ...% negative number of remaining transitions
            (sum(scheme(1,:)>0)==1 && sum(scheme(2,:)>0)==1 && ...
            isequal(scheme(1,:),scheme(2,:)))% only 1->1 transition possible
        scheme = scheme_prev;
        pth = pth_prev;
        continue
    end

    j1_next = j1+1;
    if j1_next>J
        j1_next = 1;
    end
    while scheme(1,j1_next)==0
        j1_next= j1_next+1;
        if j1_next>J
            j1_next = 1;
        end
    end
    [pth,scheme] = getTransPath(scheme,pth,j1_next);

    if ~isempty(scheme) && all(all(scheme==0))
        break
    end
    if isempty(scheme) || ...
            sum(sum(scheme<0)) || ...% negative number of remaining transitions
            (sum(scheme(1,:)>0)==1 && sum(scheme(2,:)>0)==1 && ...
            isequal(scheme(1,:),scheme(2,:)))% only 1->1 transition possible
        scheme = scheme_prev;
        pth = pth_prev;
    end
end
if isequal(scheme,scheme_prev) % dead end
    pth = [];
    scheme = [];
end



