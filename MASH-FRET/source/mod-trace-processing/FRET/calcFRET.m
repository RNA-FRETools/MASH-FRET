function fret_tr = calcFRET(nChan, nExc, exc, chanExc, FRET, I, g)

nFRET = size(FRET,1);
L = size(I,1);

% initializes output
fret_tr = NaN(L,nFRET);

% get emitters
donors = unique(FRET(:,1),'stable')';
[o,redOrder] = sort(chanExc(donors),'descend');
donors = donors(redOrder);
[emitters,id,o] = unique(FRET,'stable');
K = numel(emitters);
p_0 = FRET;
for k = 1:K
    FRET(p_0==p_0(id(k))) = k;
end

% reshape gamma factors
gamma = ones(L,K,K);
for pair = 1:nFRET
    d = FRET(pair,1);
    a = FRET(pair,2);
    gamma(:,emitters==d,emitters==a) = g(:,pair);
end

% get gamma-corrected FRET expression
E_expr = cell(K,K);
for idd = 1:(K-1)
    for ida = (idd+1:K)
        E_expr{idd,ida} = buildFretExpr(idd,ida,K);
        E_expr{idd,ida} = replaceByArrays(E_expr{idd,ida},K,chanExc,exc);
    end
end

E = zeros(L,K,K);

% solve FRET expression from reddest to greenest donor
for d = donors
    acceptors = FRET(FRET(:,1)==d,2)';
    for a = acceptors
        if isempty(E_expr{emitters==d,emitters==a})
            continue
        end
        E(:,emitters==d,emitters==a) = ...
            eval(E_expr{emitters==d,emitters==a});
    end
end

% reorder FRET data
for pair = 1:nFRET
    d = FRET(pair,1);
    a = FRET(pair,2);
    fret_tr(:,pair) = E(:,emitters==d,emitters==a);
end

fret_tr(isnan(fret_tr))=0;


