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
    
    if ~sum(sum(TDP))
        setContPan('TDP is empty, clustering is not availabe.','warning',...
            h.figure_MASH);
        return;
    end
    
    clust_prm{1} = [prm.clst_start{1}(1) ... % clustering method
                    prm.clst_start{1}(2) ... % cluster shape
                    prm.clst_start{1}(3) ... % max. number of states
                    prm.clst_start{1}(5)]; % max. number of j-mean iterations/GMM initialisations
    clust_prm{2} = [prm.clst_start{2}(:,1) ... % starting guess for states
                    prm.clst_start{2}(:,2)]; % j-mean tolerance radius around states
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
    
    meth = prm.clst_start{1}(1);
    Jmax = size(res.mu,2);
    
    % optimum number of states
    switch meth
        case 1
            for J = 1:Jmax
                if ~isempty(res.mu{J})
                    Jopt = size(res.mu{J},1); 
                    break;
                end
            end
        case 2
            BICs = NaN(1,Jmax);
            for J = 1:Jmax
                if ~isempty(res.BIC(J))
                    BICs(J) = res.BIC(J);
                end
            end
            [BICmin,Jopt] = min(BICs);
    end
    
    if ~isnan(Jopt) && Jopt>0
        
        % converged results
        models.BIC = res.BIC; % minimum Bayesian information criterion
        models.a = res.a; % Gaussian weigths
        models.o = res.o; % Gaussian sigmas
        models.mu = res.mu; % converged states
        models.fract = res.fract; % state populations (time fraction)
        models.clusters = res.clusters; % binned transitions + cluster assignment
        
        prm.clst_res = {models res.boba_K Jopt};
        
        prm = ud_kinPrm(prm,Jopt);
        
        % save data
        p.proj{proj}.prm{tpe} = prm;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        
        str_pop = cell(1,Jmax-1);
        for j = 2:Jmax
            str_pop{j-1} = num2str(j);
        end
        set(h.popupmenu_tdp_model,'Value',1);
        set(h.popupmenu_tdp_model,'String',str_pop,'Value',Jopt-1);
        
    end
    
    updateFields(h.figure_MASH, 'TDP');
end
