function pushbutton_TDPupdateClust_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    
    % reset previous clustering results if exist
    pushbutton_TDPresetClust_Callback(h.pushbutton_TDPresetClust, [], h);
    
    h = guidata(h.figure_MASH);
    p = h.param.TDP;
    proj = p.curr_proj; % current project
    tpe = p.curr_type(proj); % current channel type
    prm = p.proj{proj}.prm{tpe}; % current channel parameters
    
    dt_bin = prm.plot{3}; % binned transitions + TDP coord. assignment
    TDP = prm.plot{2}; % TDP matrix
    
    clust_prm{1} = [prm.clst_start{1}(1) ... % clustering method
                    prm.clst_start{1}(2) ... % cluster shape
                    prm.clst_start{1}(3) ... % max. number of states
                    prm.clst_start{1}(5)]; % max. number of k-mean iterations/GMM initialisations
    clust_prm{2} = [prm.clst_start{2}(:,1) ... % starting guess for states
                    prm.clst_start{2}(:,2)]; % k-mean tolerance radius around states
    clust_prm{3} = [2 3]; % columns in dt_bin containing transitions
    clust_prm{4} = [prm.clst_start{1}(6) ... % apply/not bootstrapped (BS) clustering
                    prm.clst_start{1}(7) ... % number of BS samples
                    prm.clst_start{1}(8)]; % number of BS replicates in one sample

    plot_prm{1} = prm.plot{1}([1 2],1); % TDP x & y binning
    plot_prm{2} = prm.plot{1}([1 2],[2 3]); % TDP x & y limits
    plot_prm{3} = [p.proj{proj}.frame_rate ... % frame rate
                   prm.plot{1}(4,1) ... % one/total transition count per molecule
                   prm.plot{1}(3,2) ... % conv./not TDP with Gaussian, o^2=0.0005
                   prm.plot{1}(3,3)]; % normalize/not TDP z-axis

    res = clustTrans(dt_bin, TDP,plot_prm, clust_prm,h.figure_MASH);
    
    if isempty(res)
        return;
    end
    
    % save updated number of replicates
    prm.clst_start{1}(8) = res.n_rep; % updated number of replicates
    p.proj{proj}.prm{tpe} = prm;
    h.param.TDP = p;
    guidata(h.figure_MASH, h);
    
    Kopt = size(res.mu,1); % optimum number of states
    
    if Kopt>0
        
        % converged results
        b.BIC = res.BIC; % minimum Bayesian information criterion
        b.a = res.a; % Gaussian weigths
        b.o = res.o; % Gaussian sigmas
        b.boba_K = res.boba_K; % BS mean and sigma of the number of states
        states = res.mu; % converged states
        pop = res.fract; % state populations (time fraction)
        clust = res.clusters; % binned transitions + cluster assignment
        prm.clst_res = {[states pop]  clust b};
        
        % update number of transitions for kinetics analysis
        if prm.clst_start{1}(4) > Kopt*(Kopt-1)
            prm.clst_start{1}(4) = Kopt*(Kopt-1);
        end
        for k = 1:Kopt*(Kopt-1)
            if size(prm.kin_start,1) < 1
                prm.kin_start(1,1:2) = prm.kin_def;
            elseif k > size(prm.kin_start,1)
                prm.kin_start = [prm.kin_start;prm.kin_start(k-1,:)];
            end
        end
        prm.kin_start = prm.kin_start(1:Kopt*(Kopt-1),:);
        prm.kin_res = cell(Kopt*(Kopt-1),5);
        curr_k = prm.clst_start{1}(4);
        
        % build dwell-time histogram for current cluster
        wght = prm.kin_start{curr_k,1}(4)*prm.kin_start{curr_k,1}(1);
        k_trs = 0;
        for k1 = 1:Kopt
            for k2 = 1:Kopt
                if k1 ~= k2
                    k_trs = k_trs + 1;
                    excl = prm.kin_start{k_trs,1}(8);
                    clust_k = res.clusters((res.clusters(:,end-1)==k1 & ...
                        res.clusters(:,end)==k2),1:end-2);
                    if size(clust_k,1)>2
                        prm.clst_res{4}{k_trs} = ...
                            getDtHist(clust_k, excl, wght);
                    else
                        prm.clst_res{4}{k_trs} = [];
                    end
                end
            end
        end
        
        % save data
        p.proj{proj}.prm{tpe} = prm;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        
    end
    setContPan(cat(2,'Clustering completed: ',num2str(Kopt),' states ',...
        'found'),'success', h.figure_MASH);
    updateFields(h.figure_MASH, 'TDP');
end
