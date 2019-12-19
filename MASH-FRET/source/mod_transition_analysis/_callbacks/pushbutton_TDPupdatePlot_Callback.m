function pushbutton_TDPupdatePlot_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj; % current project
    tpe = p.curr_type(proj); % current channel type
    dt_raw = p.proj{proj}.dt(:,tpe); % {nMol-by-1} transitions
    prm = p.proj{proj}.prm{tpe}; % current channel parameters
    
    a{1} = prm.plot{1}([1 2],1); % TDP x & y binning
    a{2} = prm.plot{1}([1 2],[2 3]); % TDP x & y limits
    a{3} = p.proj{proj}.frame_rate; % frame rate
    a{4} = prm.plot{1}(4,1); % one/total transition count per molecule
    
    % create TDP matrix and get binned transitions + TDP coord. assignment
    [TDP,dt_bin] = getTDPmat(dt_raw, a, h_fig);
    
    if isnan(TDP)
        return;
    end
    
    if ~isempty(TDP)
        % save TDP matrix and binned transitions
        prm.plot{2} = TDP;
        prm.plot{3} = dt_bin;
        p.proj{proj}.prm{tpe} = prm;
        h.param.TDP = p;
        guidata(h_fig, h);
        
        plot_prm{1} = a{2}; % TDP x & y limits
        plot_prm{2} = a{1}; % TDP x & y binning
        plot_prm{3} = prm.plot{1}(3,2); % conv./not TDP with Gaussian, o^2=0.0005
        plot_prm{4} = prm.plot{1}(3,3); % normalize/not TDP z-axis
        plot_prm{5} = prm.clst_start{3}; % cluster colours
        
        if ~isempty(prm.clst_res{1})
            clust{1} = prm.clst_res{1}(:,1); % converged cluster centres (states)
            clust{2} = prm.clst_res{2}; % cluster assigment of TDP coordinates
            clust{3} = prm.clst_res{3}; % converged BIC-GMM parameters
        else
            clust{1} = prm.clst_start{2}(:,1); % initial cluster centres (states)
            clust{2} = [];
            clust{3} = [];
        end
        
        plotTDP(h.axes_TDPplot1, h.colorbar_TA, TDP, plot_prm, clust, h_fig);
        
    else
        prm.plot{2} = []; % TDP matrix
        prm.plot{3} = []; % binned transitions
        
        p.proj{proj}.prm{tpe} = prm;
        h.param.TDP = p;
        guidata(h_fig, h);
    end
    updateFields(h_fig, 'TDP');
end