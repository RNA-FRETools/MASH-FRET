function p = ud_kinPrm(p,J)
% Reinitialize starting parameters for kinetic analysis and build dwell
% time histograms from clustering results according to input configuration
% J

% update kinetic fit parameters
if p.clst_start{1}(4) > J*(J-1)
    p.clst_start{1}(4) = J*(J-1);
end
for j = 1:J*(J-1)
    if size(p.kin_start,1) < 1
        p.kin_start(1,1:2) = p.kin_def;
    elseif j > size(p.kin_start,1)
        p.kin_start = [p.kin_start;p.kin_start(j-1,:)];
    end
end
p.kin_start = p.kin_start(1:J*(J-1),:);
p.kin_res = cell(J*(J-1),5);
curr_k = p.clst_start{1}(4);

% build dwell-time histogram for current cluster
wght = p.kin_start{curr_k,1}(4)*p.kin_start{curr_k,1}(1);
j_trs = 0;
for j1 = 1:J
    for j2 = 1:J
        if j1 ~= j2
            j_trs = j_trs + 1;
            excl = p.kin_start{j_trs,1}(8);
            clust_k = p.clst_res{1}.clusters{J}((...
                p.clst_res{1}.clusters{J}(:,end-1)==j1 & ...
                p.clst_res{1}.clusters{J}(:,end)==j2),1:end-2);
            if size(clust_k,1)>2
                p.clst_res{4}{j_trs} = getDtHist(clust_k, excl, wght);
            else
                p.clst_res{4}{j_trs} = [];
            end
        end
    end
end
