function mat = incrConstRowColSumMat(mat0,j1,j2,incr0,isFixed,sumConstr)
% mat = incrConstRowColSumMat(mat,j1,j2,incr,isFixed,sumConstr)
%
% Increment matrix element located at (j1,j2) and recalculate other elements to respect the constant cum of elements in each row and column.
%
% mat: [J-by-J] input matrix
% j1: row index in matrix of element to increment
% j2: columns index in matrix of element to increment
% incr: increment
% isFixed: [J-by-J] matrix indicating if an element is fixed (1) or can be varied (0)
% sumConstr: {J-by-J-by} cell matrix containg:
%   sumCnstr{j1,j2}: [J-by-J] matrix containing in cell (a1,a2) the sum of all elements to which the element (j1,j2) is constrainted to or (0) if not constrainted
% mat: re-calculated matrix

% defaults
Nmin = 0;

% initialize output
mat = mat0;

if isFixed(j1,j2)
    return
end

% get state indexes other than element
J = size(mat0,2);
js = (1:J);

% re-adjust increment
Nmax = min(min(sumConstr{j1,j2}(sumConstr{j1,j2}>0)));
if ~isinf(Nmax)
    incr = adjustIncr(incr0,mat0,j1,j2,sumConstr);
    if mat(j1,j2)>Nmin && (mat(j1,j2)+incr)<Nmin
        incr = -mat(j1,j2);
    end
    if incr==0 || (incr<0 && incr0>0) || (incr>0 && incr0<0)
        mat = [];
        return
    end
else
    incr = incr0;
    if mat(j1,j2)>Nmin && (mat(j1,j2)+incr)<Nmin
        incr = -mat(j1,j2);
    end
end

% increment element
% | 0 0 0 0 0 0 |
% | 0 0 0 0 0 0 |
% | 0 0 0 0 0 0 |
% | x 0 0 0 0 0 |
% | 0 0 0 0 0 0 |
% | 0 0 0 0 0 0 |
mat(j1,j2) = mat(j1,j2)+incr;

% varies an element contrained by sums
if ~isinf(Nmax)
    % re-calculate elements constraint by the particular row-sum
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    % | x 1 1 0 0 0 |
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    cnstr = ~~sumConstr{j1,j2}(j1,:);
    rowSum = unique(sumConstr{j1,j2}(j1,cnstr));
    if sum(mat(j1,cnstr))==0
        mat(j1,cnstr) = (rowSum-mat(j1,j2))/sum(cnstr);
    else
        mat(j1,cnstr) = ...
            (rowSum-mat(j1,j2)).*mat(j1,cnstr)./sum(mat(j1,cnstr));
    end
    
    % re-calculate elements constraint by the particular column-sum
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    % | x 0 0 0 0 0 |
    % | 1 0 0 0 0 0 |
    % | 1 0 0 0 0 0 |
    cnstr = ~~sumConstr{j1,j2}(:,j2);
    colSum = unique(sumConstr{j1,j2}(cnstr,j2));
    if sum(mat(cnstr,j2))==0
        mat(cnstr,j2) = (colSum-mat(j1,j2))/sum(cnstr);
    else
        mat(cnstr,j2) = ...
            (colSum-mat(j1,j2)).*mat(cnstr,j2)./sum(mat(cnstr,j2));
    end
    
    % re-calculate elements constrainted by the particular row-sum of each element previously varied
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    % | x 0 0 0 0 0 |
    % | 0 1 1 0 0 0 |
    % | 0 1 1 0 0 0 |
    j2s = js(~~sumConstr{j1,j2}(:,j2));
    for j = j2s
        cnstr = ~~sumConstr{j,j2}(j,:);
        rowSum = unique(sumConstr{j,j2}(j,cnstr));
        if sum(mat(j,cnstr))==0
            mat(j,cnstr) = (rowSum-mat(j,j2))/sum(cnstr);
        else
            mat(j,cnstr) =...
                (rowSum-mat(j,j2)).*mat(j,cnstr)./sum(mat(j,cnstr));
        end
    end
    
    % re-calculate elements constrainted by the row sum
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    % | x 1 1 0 0 0 |
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    j2s = js(~~sumConstr{j1,j2}(j1,:));
    for j = j2s
        cnstr = ~~sumConstr{j1,j}(:,j);
        colSum = unique(sumConstr{j1,j}(cnstr,j));
        mat(j1,j) = colSum-sum(mat(cnstr,j));
    end

% varies an element not constrained by sum (row- and column-sums are re-defined after increment)
else
    % incr. elements constrained by row- and column-sum
    % | 0 0 x 0 0 0 | > N
    % | 1 0 0 0 0 0 |
    % | 1 1 0 1 0 0 |
    % | 1 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    %   v
    %   N
    js = [j1,j2,find(sum(sumConstr{j1,j2},1))];
    js = min(js):max(js);
    js1 = find(js==j1);
    js2 = find(js==j2);
    Nsum0 = sum(mat0(js,js),1);
    isFixed = ~sumConstr{j1,j2};
    isFixed(j1,:) = true;
    isFixed(:,j2) = true;
    Nsum = zeros(1,size(js,2));
    Nsum(js1) = sum(mat(j1,js));
    Nsum(js2) = sum(mat(js,j2));

    mat_js = reorgConstRowColSumMat(mat(js,js),isFixed(js,js),js2,js1,Nsum);
    if isempty(mat_js)
        mat = [];
        return
    end
    mat(js,js) = mat_js;
    
    % re-calculate all other elements 
    % | 0 0 x 0 0 0 |
    % | 0 0 0 1 0 0 | > N1
    % | 0 0 0 0 0 0 |
    % | 0 1 0 0 0 0 | > N2
    % | 0 0 0 0 0 0 |
    % | 0 0 0 0 0 0 |
    %     v   v
    %     N1  N2
    isFixed(js2,:) = true;
    isFixed(:,js1) = true;
    jid = js~=j1 & js~=j2;
    Nsum(jid) = sum(sum(mat(jid,js)))*Nsum0(jid)/sum(Nsum0(jid));
    
    for row = js(jid)
        for col = js(jid)
            if row==col
                continue
            end
            mat_js = reorgConstRowColSumMat(mat(js,js),isFixed(js,js),row,...
                col,Nsum);
            if isempty(mat_js)
                mat = [];
                return
            end
        end
    end
    mat(js,js) = mat_js;
end

% cancel matrix leading to dead-end states or state equilibrium
if ~isempty(mat)
    for j = 1:J
        % cancel matrix leading to isolated state equilibrium
        if (sum(mat(j,:)>0)==1 && sum(mat(mat(j,:)>0,:)>0)==1 && ...
                find(mat(mat(j,:)>0,:)>0)==j) || sum(mat(j,:))==0 || ...
                sum(mat(:,j))==0
            mat = [];
            return
        end
    end
end


function incr = adjustIncr(incr,mat0,j1,j2,sumConstr)

J = size(mat0,2);
incrMax = Inf(J);
incrMin = -Inf(J);

el0 = mat0(j1,j2);
cnstr = ~~sumConstr{j1,j2}(j1,:);
rowSum0 = unique(sumConstr{j1,j2}(j1,cnstr));
cnstr = ~~sumConstr{j1,j2}(:,j2);
colSum0 = unique(sumConstr{j1,j2}(cnstr,j2));
incrMin(j1,j2) = -el0;

incrMax(j1,j2) = min([colSum0,rowSum0])-el0;
% incrMax(j1,j2) = rowSum0-el0;

cnstr = ~~sumConstr{j1,j2}(:,j2);
j2s = find(cnstr');
incrMax(j2s,j2) = colSum0-el0;
sum1 = sum(mat0(cnstr,j2));
for j = j2s
    el1 = mat0(j,j2);
    if sum1==0
        fract1 = 1/sum(cnstr);
    else
        fract1 = el1/sum1;
    end
    cnstr = ~~sumConstr{j,j2}(j,:);
    rowSum1 = unique(sumConstr{j,j2}(j,cnstr));
    incrMin(j,j2) = colSum0-el0-rowSum1/fract1;
    
    j3s = find(cnstr);
    incrMin(j,j3s) = colSum0-el0-rowSum1/fract1;
    sum2 = sum(mat0(j,cnstr));
    for k = j3s
        el2 = mat0(j,k);
        if sum2==0
            fract2 = 1/sum(cnstr);
        else
            fract2 = el2/sum2;
        end
        cnstr = ~~sumConstr{j,k}(:,k);
        colSum2 = unique(sumConstr{j,k}(cnstr,k));
        incrMax(j,k) = colSum0-el0-(rowSum1-colSum2/fract2)/fract1;
    end
end

incrMax = min(min(incrMax));
if incr>incrMax
    incr = incrMax;
end
incrMin = max(max(incrMin));
if incr<incrMin
    incr = incrMin;
end

