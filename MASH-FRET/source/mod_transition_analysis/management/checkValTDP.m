function prm = checkValTDP(p,prm,def)
% Identify ill-defined processing parameters and reset results accordingly

% default
state = 0;
tol = Inf;

% collect interface parameters
clr = p.colList;

% collect processing parameters
prm.plot = adjustParam('plot', def.plot, prm);
prm.clst_start = adjustParam('clst_start', def.clst_start, prm);
prm.clst_res = adjustParam('clst_res', def.clst_res, prm);
prm.kin_def = adjustParam('kin_def', def.kin_def, prm);
prm.kin_start = adjustParam('kin_start', def.kin_start, prm);
prm.kin_res = adjustParam('kin_res', def.kin_res, prm);
pplot = prm.plot;
clst_start = prm.clst_start;
clst_res = prm.clst_res;
kin_def = prm.kin_def;
kin_start = prm.kin_start;
kin_res = prm.clst_res;

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
    kin_start = def.kin_start; % reset fitting parameters
    kin_res = def.kin_res; % reset fitting results
end

% adjust cluster starting guesses
J = clst_start{1}(3);
if size(clst_start{2},1)<J
    clst_start{2} = cat(1,clst_start{2},...
        repmat([state,tol],J-size(clst_start{2},1)));
else
    clst_start{2} = clst_start{2}(1:J,:);
end

% adjust cluster colors
nTrs = J*(J-1);
if size(clr,1)<nTrs
    clr = cat(1,clr,rand(nTrs-size(clr,1),3)); 
end
clst_start{3} = clr(1:nTrs,:);

kin_def{1} = adjustVal(kin_def{1},def.kin_def{1});

nExp = kin_def{1}(2);
fitprm = adjustVal(kin_def{2}(1,:),def.kin_def{2}(1,:));
if ~isequal(fitprm,kin_def{2}(1,:))
    kin_def{2} = repmat(def.kin_def{2}(1,:),nExp,1);
    kin_start{1} = def.kin_start{1}; % reset fitting parameters
    kin_res = def.kin_res; % reset fitting results
end
if size(kin_def{2},1)<nExp
    kin_def{2} = cat(1,kin_def{2},...
        repmat(kin_def{2}(end,:),nExp-size(kin_def{2},1),1));
end

if ~isempty(clst_res{2})
    method = clst_start{1}(1);
    corr = clst_start{1}(9);
    J = kin_start{2}(1);
    if sum(method==[1,2]) && corr % cluster centers are dependent
        nTrs = J*(J-1);
    else % cluster centers are independent
        nTrs = J;
    end

    if size(kin_start{1},1)<nTrs
        kin_start{1} = cat(1,kin_start{1},...
            repmat(kin_def,[nTrs-size(kin_start{1},1),1]));
        kin_res = def.kin_res; % reset fitting results
    else
        kin_start{1} = kin_start{1}(1:nTrs,:);
    end   
end

prm.plot = pplot;
prm.clst_start = clst_start;
prm.clst_res = clst_res;
prm.kin_def = kin_def;
prm.kin_start = kin_start;
prm.kin_res = kin_res;
