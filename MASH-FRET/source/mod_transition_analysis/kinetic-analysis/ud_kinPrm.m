function prm = ud_kinPrm(prm,def,J)
% Reinitialize starting parameters for kinetic analysis and build dwell
% time histograms from clustering results according to input configuration
% J

nTrs = J*(J-1);

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
j_trs = 0;
for j1 = 1:J
    for j2 = 1:J
        if j1==j2
            continue
        end
        j_trs = j_trs + 1;
        wght = prm.kin_start{1}{j_trs,1}(4)*prm.kin_start{1}{j_trs,1}(1);
        
        clust_k = prm.clst_res{1}.clusters{J}((...
            prm.clst_res{1}.clusters{J}(:,end-1)==j1 & ...
            prm.clst_res{1}.clusters{J}(:,end)==j2),1:end-2);

        if size(clust_k,1)>2
            % save histogram including first dwell time of trajectory
            % for plot
            mols = unique(prm.clst_res{1}.clusters{J}(:,4));
            excl = prm.kin_start{1}{j_trs,1}(8);
            prm.clst_res{4}{j_trs} = getDtHist(prm.clst_res{1}.clusters{J},...
                [j1,j2], mols, excl, wght);

        else
            prm.clst_res{4}{j_trs} = [];
        end
    end
end
