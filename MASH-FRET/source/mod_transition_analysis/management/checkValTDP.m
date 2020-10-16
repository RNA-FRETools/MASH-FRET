function prm = checkValTDP(p,prm,def)
% prm = checkValTDP(p,prm,def)
%
% Identify ill-defined processing parameters and reset results accordingly
%
% p: structure containing field:
%  p.colList: [nClr-by-3] default cluster colors
% prm: structure containing processing parameters to check
% def: structure containing standard processing parameters (reference)

% Last update, 24.4.2020 by MH: replace fields "kin_def", "kin_start" and "kin_res" by "lft_def", "lft_start" and "lft_res"

% default
state = 0;
tol = Inf;

% collect interface parameters
clr = p.colList;

% collect processing parameters
prm.plot = adjustParam('plot', def.plot, prm);
prm.clst_start = adjustParam('clst_start', def.clst_start, prm);
prm.clst_res = adjustParam('clst_res', def.clst_res, prm);
prm.lft_def = adjustParam('lft_def', def.lft_def, prm);
prm.lft_start = adjustParam('lft_start', def.lft_start, prm);
prm.lft_res = adjustParam('lft_res', def.lft_res, prm);
prm.mdl_res = adjustParam('mdl_res', def.mdl_res, prm);
pplot = prm.plot;
clst_start = prm.clst_start;
clst_res = prm.clst_res;
lft_def = prm.lft_def;
lft_start = prm.lft_start;
lft_res = prm.lft_res;

% adjust TDP parameters
pplot{1} = adjustVal(pplot{1},def.plot{1});
if ~isequal(pplot{1},prm.plot{1})
    pplot{2} = def.plot{2}; % reset TDP
    pplot{3} = def.plot{3}; % reset dt table
end

% adjust clustering parameters
clst_start{1} = adjustVal(clst_start{1},def.clst_start{1});
if ~isequal(clst_start{1},prm.clst_start{1})
    clst_start{2} = def.clst_start{2}; % reset cluster starting guess
    clst_start{3} = def.clst_start{3}; % reset cluster colors
    clst_res = def.clst_res; % reset clustering results
    lft_start = def.lft_start; % reset fitting parameters
    lft_res = def.lft_res; % reset fitting results
end

% adjust cluster starting guesses
J = clst_start{1}(3);
mat = clst_start{1}(4);
clstDiag = clst_start{1}(9);
nTrs = getClusterNb(J,mat,clstDiag);

if size(clst_start{2},1)<nTrs
    clst_start{2} = cat(1,clst_start{2},...
        repmat([state,state,tol,tol],nTrs-size(clst_start{2},1),1));
else
    clst_start{2} = clst_start{2}(1:nTrs,:);
end

% adjust cluster colors
if size(clr,1)<nTrs
    clr = cat(1,clr,rand(nTrs-size(clr,1),3)); 
end
clst_start{3} = clr(1:nTrs,:);

lft_def{1} = adjustVal(lft_def{1},def.lft_def{1});

nExp = lft_def{1}(3);
fitprm = adjustVal(lft_def{2}(1,:),def.lft_def{2}(1,:));
if ~isequal(fitprm,lft_def{2}(1,:))
    lft_def{2} = repmat(def.lft_def{2}(1,:),nExp,1);
    lft_start{1} = def.lft_start{1}; % reset fitting parameters
    lft_res = def.lft_res; % reset fitting results
end
if size(lft_def{2},1)<nExp
    lft_def{2} = cat(1,lft_def{2},...
        repmat(lft_def{2}(end,:),nExp-size(lft_def{2},1),1));
end

lft_start{2} = adjustVal(lft_start{2},def.lft_start{2});

[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
if ~isempty(clst_res{2})
    J = lft_start{2}(1);
    bin = prm.lft_start{2}(3);
    mu = clst_res{1}.mu{J};
    [vals,~] = binStateValues(mu,bin,[j1,j2]);
    V = numel(vals);

    if size(lft_start{1},1)<V
        lft_start{1} = cat(1,lft_start{1},...
            repmat(lft_def,[V-size(lft_start{1},1),1]));
        lft_res = def.lft_res; % reset fitting results
    else
        lft_start{1} = lft_start{1}(1:V,:);
    end
    for c = 1:numel(lft_res)
        if size(lft_res{c},3)<V
            lft_res = def.lft_res; % reset fitting results
            break
        end
    end
end

prm.plot = pplot;
prm.clst_start = clst_start;
prm.clst_res = clst_res;
prm.lft_def = lft_def;
prm.lft_start = lft_start;
prm.lft_res = lft_res;
