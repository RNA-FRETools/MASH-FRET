function S_tr = calcS(exc, chanExc, S, FRET, I, g, b)

nS = size(S,1);
nFRET = size(FRET,1);
L = size(I,1);

% initializes output
S_tr = NaN(L,nS);

% get emitters
donors = unique(S(:,1),'stable')';
[o,redOrder] = sort(chanExc(donors),'descend');
donors = donors(redOrder);
[emitters,id,o] = unique(FRET,'stable');
K = numel(emitters);
S_0 = S;
p_0 = FRET;
for k = 1:K
    S(S_0==p_0(id(k))) = k;
    FRET(p_0==p_0(id(k))) = k;
end

% reshape correction factors
beta = ones(L,K,K);
gamma = ones(L,K,K);
for pair = 1:nFRET
    d = FRET(pair,1);
    a = FRET(pair,2);
    beta(:,emitters==d,emitters==a) = b(:,pair);
    gamma(:,emitters==d,emitters==a) = g(:,pair);
end

% get gamma-corrected FRET expression
S_expr = cell(K,K);
for idd = 1:(K-1)
    for ida = (idd+1:K)
        S_expr{idd,ida} = buildSExpr(idd,ida,K);
        S_expr{idd,ida} = replaceByArrays(S_expr{idd,ida},K,chanExc,exc);
    end
end

S_mat = NaN(L,K,K);

% solve Stoichiometry expression from reddest to greenest donor
for d = donors
    acceptors = S(S(:,1)==d,2)';
    for a = acceptors
        if isempty(S_expr{emitters==d,emitters==a}) || chanExc(d)==0  || ...
                chanExc(a)==0
            continue
        end
        S_mat(:,emitters==d,emitters==a) = ...
            eval(S_expr{emitters==d,emitters==a});
    end
end

% reorder FRET data
for pair = 1:nS
    d = S(pair,1);
    a = S(pair,2);
    S_tr(:,pair) = S_mat(:,emitters==d,emitters==a);
end

S_tr(isnan(S_tr))=0;



