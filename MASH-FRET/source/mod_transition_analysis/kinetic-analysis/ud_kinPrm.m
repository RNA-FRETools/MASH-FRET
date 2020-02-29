function prm = ud_kinPrm(prm,def,J)
% Reinitialize starting parameters for kinetic analysis and build dwell
% time histograms from clustering results according to input configuration
% J

% collect processing parameters
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);

nTrs = getClusterNb(J,mat,clstDiag);
[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);

% correct current transition
if prm.kin_start{2}(2) > nTrs
    prm.kin_start{2}(2) = nTrs;
end

% update fit parameters
for j = 1:nTrs
    if j==1 && (isempty(prm.kin_start{1}{j,1}) || ...
            isempty(prm.kin_start{1}{j,2}))
        prm.kin_start{1}(1,1:2) = prm.kin_def;
    elseif j>size(prm.kin_start{1},1) || ...
            (isempty(prm.kin_start{1}{j,1}) || ...
            isempty(prm.kin_start{1}{j,2}))
        prm.kin_start{1} = [prm.kin_start{1};prm.kin_start{1}(j-1,:)];
    end
end
prm.kin_start{1} = prm.kin_start{1}(1:nTrs,:);
prm.kin_res = repmat(def.kin_res,nTrs,1);

% build dwell-time histograms
for k = 1:nTrs
    wght = prm.kin_start{1}{k,1}(4)*prm.kin_start{1}{k,1}(1);    
%     excl = prm.kin_start{1}{k,1}(8);
    excl = false;
    mols = unique(prm.clst_res{1}.clusters{J}(:,4));
    prm.clst_res{4}{k} = getDtHist(prm.clst_res{1}.clusters{J},...
        [j1(k),j2(k)], mols, excl, wght);
end
