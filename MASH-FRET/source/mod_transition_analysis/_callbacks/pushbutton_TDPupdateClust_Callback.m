function pushbutton_TDPupdateClust_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj)
    
    % reset previous clustering results if exist
    pushbutton_TDPresetClust_Callback(h.pushbutton_TDPresetClust,[],h_fig);
    
    h = guidata(h_fig);
    p = h.param.TDP;
    proj = p.curr_proj; % current project
    tpe = p.curr_type(proj); % current channel type
    prm = p.proj{proj}.prm{tpe}; % current channel parameters
    
    dt_bin = prm.plot{3}; % binned transitions + TDP coord. assignment
    TDP = prm.plot{2}; % TDP matrix
    
    if ~sum(sum(TDP))
        setContPan('TDP is empty, clustering is not availabe.','warning',...
            h_fig);
        return;
    end
    
    meth = prm.clst_start{1}(1);
    
    % manage ill-defined k-mean starting guess
    if meth==1
        mu_0 = prm.clst_start{2}(:,1);
        J_0 = prm.clst_start{1}(3);
        isdouble = 0;
        for j=1:J_0
            ind = 1:J_0;
            ind(ind==j)=[];
            if sum(mu_0(j)==mu_0(ind))
                isdouble = 1;
                break;
            end
        end
        
        if isdouble
            question = sprintf(cat(2,'Some states have identical values ',...
                'in the starting guess. Do you want to use default state ',...
                'values?'));
            choice = questdlg(question, 'Starting guess is ill-defined', ...
                'Yes, use default', 'Cancel, I will correct manually', ...
                'Yes, use default');
            if strcmp(choice, 'Yes, use default')
                pushbutton_TDPautoStart_Callback([],[],h_fig);
                h = guidata(h_fig);
                p = h.param.TDP;
                prm = p.proj{proj}.prm{tpe}; % current channel parameters
            else
                return;
            end
        end
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

    res = clustTrans(dt_bin, TDP,plot_prm, clust_prm,h_fig);
    
    if isempty(res)
        return;
    end
    
    % save updated number of replicates
    prm.clst_start{1}(8) = res.n_rep; % updated number of replicates
    p.proj{proj}.prm{tpe} = prm;
    h.param.TDP = p;
    guidata(h_fig, h);

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
    
    if ~isnan(Jopt) && Jopt>1
        
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
        guidata(h_fig, h);
        
        str_pop = cell(1,Jmax-1);
        for j = 2:Jmax
            str_pop{j-1} = num2str(j);
        end
        set(h.popupmenu_tdp_model,'Value',1);
        set(h.popupmenu_tdp_model,'String',str_pop,'Value',Jopt-1);
        
    end
    
    updateFields(h_fig, 'TDP');
end
