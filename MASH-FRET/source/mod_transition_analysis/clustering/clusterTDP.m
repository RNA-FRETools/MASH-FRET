function p = clusterTDP(p,tag,tpe,h_fig)

% collect interface parameters
proj = p.curr_proj;
prm = p.proj{proj}.prm{tag,tpe};
curr = p.proj{proj}.curr{tag,tpe};
def = p.proj{proj}.def{tag,tpe};

% make current settings the processing parameters at last update
prm.clst_start = curr.clst_start;
prm.clst_res = curr.clst_res;
prm.kin_def = curr.kin_def;

% collect project parameters
expT = p.proj{proj}.frame_rate;

% collect processing parameters
dt_bin = prm.plot{3}; % binned transitions + TDP coord. assignment
TDP = prm.plot{2}; % TDP matrix

% reset previous clustering results if exist
prm.clst_res = def.clst_res;
prm.kin_start = def.kin_start;
prm.kin_res = def.kin_res;

% abort if TDP is empty
if ~sum(sum(TDP))
    setContPan('TDP is empty, clustering is not availabe.','warning',...
        h_fig);
    return
end

meth = prm.clst_start{1}(1);

% manage ill-defined k-mean starting guess
if meth==1
    [ok,prm] = checkKmeanStart(prm);
    if ~ok
        return
    end
end

clust_prm{1} = prm.clst_start{1}([1:5,9:10]);
clust_prm{2} = prm.clst_start{2}(:,[1,2]);
clust_prm{3} = [2 3]; % columns in dt_bin containing transitions
clust_prm{4} = prm.clst_start{1}(6:8); % bootstrap parameters
plot_prm{1} = prm.plot{1}(1,1);
plot_prm{2} = prm.plot{1}(1,2:3); 
plot_prm{3} = [expT prm.plot{1}(4,1) prm.plot{1}(3,2:3)];

res = clustTrans(dt_bin, TDP, plot_prm, clust_prm, h_fig);

if isempty(res)
    return
end

% save updated number of replicates
prm.clst_start{1}(8) = res.n_rep; % updated number of replicates

Jmax = size(res.mu,2);

% optimum number of states
switch meth
    case 1
        for J = 1:Jmax
            if ~isempty(res.mu{J})
                Jopt = size(res.mu{J},1); 
                break
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

    prm = ud_kinPrm(prm,def,Jopt);

    % set models for plot and kinetic analysis to optimum config
    prm.clst_res{3} = Jopt;
    prm.kin_start{2}(1) = Jopt;
end

% save modifications of processing parameters in current settings
curr.clst_start = prm.clst_start;
curr.clst_res = prm.clst_res;
curr.kin_def = prm.kin_def;
curr.kin_start = prm.kin_start;
curr.kin_res = prm.kin_res;

p.proj{proj}.prm{tag,tpe} = prm;
p.proj{proj}.curr{tag,tpe} = curr;
