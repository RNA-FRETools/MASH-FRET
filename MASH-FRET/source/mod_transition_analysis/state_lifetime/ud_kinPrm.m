function prm = ud_kinPrm(prm,def,J)
% Reinitialize starting parameters for kinetic analysis and build dwell
% time histograms from clustering results according to input configuration
% J

% collect processing parameters
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);

nTrs = getClusterNb(J,mat,clstDiag);
[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
[vals,~] = binStateValues(prm.clst_res{1}.mu{J},prm.lft_start{2}(3),...
    [j1,j2]);
V = numel(vals);

% update number of observed states in cluster config
prm.lft_start{2}(1) = J;

% correct current state value
if prm.lft_start{2}(2)>V
    prm.lft_start{2}(2) = V;
end

% update fit parameters
for j = 1:V
    if j==1 && (isempty(prm.lft_start{1}{j,1}) || ...
            isempty(prm.lft_start{1}{j,2}))
        prm.lft_start{1}(1,1:2) = prm.lft_def;
    elseif j>size(prm.lft_start{1},1) || ...
            (isempty(prm.lft_start{1}{j,1}) || ...
            isempty(prm.lft_start{1}{j,2}))
        prm.lft_start{1} = [prm.lft_start{1};prm.lft_start{1}(j-1,:)];
    end
end
prm.lft_start{1} = prm.lft_start{1}(1:V,:);
prm.lft_res = repmat(def.lft_res,V,1);
prm.mdl_res = def.mdl_res;

prm.clst_res{4} = cell(1,V);
for v1 = 1:V
    k = 1;
    prm.clst_res{4}{v1,k} = updateDtHist(prm,[],v1,0); % all transitions from v1
    for v2 = 1:V
        if v1==v2
            continue
        end
        k = k+1;
        prm.clst_res{4}{v1,k} = updateDtHist(prm,[],v1,v2); % v1->v2 transitions only
    end
end
