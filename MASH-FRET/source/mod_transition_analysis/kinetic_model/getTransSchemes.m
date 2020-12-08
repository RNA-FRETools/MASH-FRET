function trans_mat = getTransSchemes(J)
% Determines all possible transition schemes between J states
% Returns transition matrix filled with 0 (no transition) and 1 (transition occurs)

N_nod_max = J-1;

% get all possible combinations of number of transitions
trs = getConnexionComb(N_nod_max,J);
trs_sort = trs;

% select valid and unique combinations
trs_sum = sum(trs,2);
Sums = unique(trs_sum)';
cmb_all = [];
for Sum = Sums
    rows = find(trs_sum==Sum);
    for r_to = rows'
        for r_from = rows'
            cmb = [trs_sort(r_to,:);trs(r_from,:)];
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
n_cmb = size(cmb_all,3);
ok = false(1,n_cmb);
trans_mat = NaN(J,J,n_cmb);
for c = 1:n_cmb
    if all(all(cmb_all(:,:,c)==0))
        trans_mat(:,:,c) = false(J,J);
        ok(c) = true;
        continue
    end
    scheme = cmb_all(:,:,c);
    pth = false(J,J);
    for j1 = 1:J
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


function vects = getConnexionComb(Max,J)
% get all possible networks having J nods that can make a maximum number
% Max of connexions with other nods

vects = [];
if J<0
    return
end

for n = 0:Max
    vect = zeros(1,J);
    vect(1) = n;
    if (J-1)>0
        cmb = getConnexionComb(Max,J-1);
        vect = [repmat(n,size(cmb,1),1),cmb];
    end
    vects = cat(1,vects,vect);
end


function ok = isValidScheme(scheme0)

ok = true;
J = size(scheme0,2);

scheme = scheme0;
for j1 = 1:J
    j2s = circshift(1:J,[0,(j1-1)]); % with circular shift
    j2s(j2s==j1) = [];
    j2 = 0;
    while scheme(1,j1)>0 && j2<numel(j2s)
        j2 = j2+1;
        if scheme(2,j2s(j2))>=1
            scheme(2,j2s(j2)) = scheme(2,j2s(j2))-1;
            scheme(1,j1) = scheme(1,j1)-1;
        end
    end
end

if ~all(all(scheme==0))
    scheme = scheme0;
    for j1 = 1:J
        j2s = 1:J;
        j2s(j2s==j1) = []; % without circular shift
        j2 = 0;
        while scheme(1,j1)>0 && j2<numel(j2s)
            j2 = j2+1;
            if scheme(2,j2s(j2))>=1
                scheme(2,j2s(j2)) = scheme(2,j2s(j2))-1;
                scheme(1,j1) = scheme(1,j1)-1;
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



