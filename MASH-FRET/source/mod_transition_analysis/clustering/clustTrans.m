function res = clustTrans(dt_bin, TDP, plot_prm, clust_prm, h_fig)

% initialize results
res.mu = {};
res.a = {};
res.o = {};
res.clusters = {};
res.BIC = [];
res.boba_K = [];
res.fract = {};
res.pop = {};

% default
M_def = 500; % default max. number of maximization iteration
plotIter_def = 0; % plot/not EM results while iterating
Jmin_def = 2; % minimum configuration

% collect processing parameters
meth = clust_prm{1}(1); % clustering method
shape = clust_prm{1}(2); % cluster shape
Jmax = clust_prm{1}(3); % max. number of states
mat = clust_prm{1}(4); % cluster matrix
T = clust_prm{1}(5); % max. number of k-mean iterations/GMM initialisations
clstDiag = clust_prm{1}(6); % generate cluster for "static" transitions (k to k transitions)
logl = clust_prm{1}(7); % type of likelihood
mu_0 = clust_prm{2}(:,[1,2]); % starting guess for k-mean centers
tol = clust_prm{2}(:,[3,4]); % k-mean tolerance radius around states
boba = clust_prm{4}(1); % apply/not bootstrapped (BS) clustering
n_spl = clust_prm{4}(2); % number of BS samples
n_rep = clust_prm{4}(3); % number of BS replicates in one sample
bin = plot_prm{1};
lim = plot_prm{2}; % TDP x & y limits
onecount = plot_prm{3}(1); % one/total transition count per molecule
gconv = plot_prm{3}(2); % one/total transition count per molecule
incldiag = plot_prm{3}(3); % include last states in sequences

[mols,o,o] = unique(dt_bin(:,4));

if meth==1 && mat
    [mu_0,id] = unique(mu_0(:,1),'stable'); % states only
    tol = tol(id,1);
end
tol(isinf(tol)) = 2*(lim(2)-lim(1));

if ~boba
    n_spl = 1;
end
res.n_rep = n_rep;

if boba
    % randomly select dynamic molecules
    err = loading_bar('init', h_fig, n_spl, cat(2,'Performing ',...
        'randomisation and clustering ...'));
    if err
        return;
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    
    setContPan(cat(2,'Performing data randomisation and clustering ...'),...
        'process', h_fig);
else
    setContPan('Performing data clustering ...','process', h_fig);
end

param = cell(1,n_spl);
Jopt_k = nan(1,n_spl);

iv = lim(1):bin:lim(2);
x = mean([iv(1:end-1);iv(2:end)],1);

for k = 1:n_spl
    
    % get TDP data
    if boba && k>1
        
        % randomize molecule data
        m = randsample(mols, n_rep, true, ones(numel(mols),1))';
        data_spl_m = [];
        for n = m
            dat_m = dt_bin(dt_bin(:,4)==n,:);
            if onecount
                [o,id] = unique(dat_m(:,5:6),'rows');
                data_spl_m = [data_spl_m;dat_m(id,:)];
            else
                data_spl_m = [data_spl_m;dat_m];
            end
        end
        
        % build sample TDP
        [TDP_spl,o,o,o] = hist2(data_spl_m(:,[2 3]),[iv;iv]);
        
        % remove diagonal densities
        if ~incldiag
            TDP_spl(~~eye(size(TDP_spl))) = 0;
        end
    else
        % get original TDP
        TDP_spl = TDP;
    end

    % apply Gaussian filter to TDP
    if gconv
        TDP_spl = gconvTDP(TDP_spl,lim,bin);
    end
    
    % get 2D-Gaussian shape
    switch shape
        case 1
            shape_str = 'spherical';
        case 2
            shape_str = 'ellipsoid straight';
        case 3
            shape_str = 'ellipsoid diagonal';
        case 4
            shape_str = 'free';
    end

    switch meth
        
        case 1 %k-mean clustering
            
            % cluster data
            [mu_spl,clust_spl] = get_kmean(mu_0, tol, T, TDP_spl, x, x, ...
                mat, clstDiag, shape);
            
            % determine model configuration
            Jopt = size(mu_spl,1);
            
            % save sample's best inferred model
            param{k} = {mu_spl};
            
            if ~boba || (boba && k==1)
                % save inferred models for original TDP
                origin = cell(1,Jmax);
                origin{Jopt}.mu = mu_spl;
                origin{Jopt}.clusters = clust_spl;
                origin{Jopt}.o = [];
                origin{Jopt}.w = [];
                origin{Jopt}.BIC = Inf;
            end
            
            % update action
            if n_spl==1
                setContPan(cat(2,'Inferred model: J=',num2str(Jopt),...
                    ', states=',sprintf(repmat('%d ',[1,size(mu_spl,1)]),...
                    mu_spl')),'success',h_fig);
            else
                str = cat(2,'Inferred model: J=',num2str(Jopt),...
                    ', states=',sprintf(repmat('%d ',[1,size(mu_spl,1)]),...
                    mu_spl'));
                setContPan(str,'process',h_fig);
            end
            
        case 2 % GMM clustering
            
            % fit and cluster data
            [model,L_t,BIC_t] = find_best_model(TDP_spl,x,x,Jmin_def,Jmax,...
                T, M_def,mat,shape_str,0,plotIter_def,clstDiag,logl);
            
            % save inferred models for original TDP
            if k==1
                origin = model;
            end
            
            % find sample's best inferred model
            [BIC_min,Jopt] = min(BIC_t);
            
            if ~isempty(model{Jopt})
                % save sample's best inferred model
                mu_spl = model{Jopt}.mu;
                clust_spl = model{Jopt}.clusters;
                BIC_spl = model{Jopt}.BIC;
                a_spl = model{Jopt}.w;
                sig_spl = model{Jopt}.o;
                param{k} = {mu_spl clust_spl BIC_spl a_spl sig_spl};
                
                % update action
                if n_spl==1
                    setContPan(cat(2,'Most sufficient model: J=',num2str(Jopt),...
                        ', LogL=',num2str(L_t(Jopt)),', BIC=',...
                        num2str(BIC_t(Jopt))),'success',h_fig);
                else
                    str = cat(2,'Sample ',num2str(k),', most sufficient ',...
                        'model: J=',num2str(Jopt),', LogL=',num2str(L_t(Jopt)),...
                        ', BIC=',num2str(BIC_t(Jopt)));
                    setContPan(str,'process',h_fig);
                end
            
            else
                Jopt = NaN;
            end
            
        case 3 % manual
            
            % cluster data
            clust_spl = manualClustering(TDP_spl,x,x,mu_0,tol,shape);
            
            % determine model configuration
            Jopt = size(mu_0,1);
            
            % save sample's best inferred model
            param{k} = {mu_0};
            
            if ~boba || (boba && k==1)
                % save inferred models for original TDP
                origin = cell(1,Jmax);
                origin{Jopt}.mu = mu_0;
                origin{Jopt}.clusters = clust_spl;
                origin{Jopt}.o = [];
                origin{Jopt}.w = [];
                origin{Jopt}.BIC = Inf;
            end
            
            % update action
            if n_spl==1
                setContPan('Manual clustering completed.','success',h_fig);
            end
    end
    
    % number of states in sample's model
    Jopt_k(k) = Jopt;
    
    % update loading bar
    if boba
        err = loading_bar('update', h_fig);
        if err
            break
        end
    end
    
    if n_spl>1
        setContPan('Bootstrap clustering competed !','process',h_fig);
    end
end

if boba
    
    % remove models that did not converge
    param(isnan(Jopt_k)) = [];
    Jopt_k(isnan(Jopt_k)) = [];
    
    % calculate bootstrap mean and deviation
    Jopt_mean = mean(Jopt_k);
    Jopt_sig = std(Jopt_k);
    
    % determine best state configuration Jopt
    Jopt = round(Jopt_mean);
    if Jopt==0
        return
    end
    
    % select samples with best configuration J=Jopt
    spl_opt = Jopt_k==Jopt;
    param_opt = param(spl_opt);
    
    % average centers over samples and cluster original TDP
    if meth==1 
        mu = zeros(size(param_opt{1}{1}));
        for k = 1:size(param_opt,1)
            mu = mu + param_opt{k}{1}/size(param_opt,1);
        end
        [mu,clust] = get_kmean(mu, tol, T, TDP_spl, x, x, mat, clstDiag, ...
            shape);
        
        % save inferred model for original TDP
        origin = cell(1,Jmax);
        origin{Jopt}.mu = mu;
        origin{Jopt}.clusters = clust;
        origin{Jopt}.o = [];
        origin{Jopt}.w = [];
        origin{Jopt}.BIC = Inf;
    end
    
    % close loading bar
    loading_bar('close', h_fig);
    
else
    Jopt_mean = Jopt;
    Jopt_sig = 0;
end

% used for Model selection evaluation paper:
% if ~isempty(h_fig)
%     h = guidata(h_fig);
%     p = h.param.TDP;
%     proj = p.curr_proj;
%     [o,fname_proj,o] = fileparts(p.proj{proj}.proj_file);
%     saveStatesResults(param,cat(2,fname_proj,'_',num2str(shape),'.txt'));
% end

% initialize results to return
res.mu = cell(1,Jmax);
res.o = cell(1,Jmax);
res.a = cell(1,Jmax);
res.clusters = cell(1,Jmax);
res.BIC = Inf(1,Jmax);
res.fract = cell(1,Jmax);
res.pop = cell(1,Jmax);

if meth==1
    Jmin = Jopt;
    Jmax = Jopt;
else
    Jmin = Jmin_def;
end

for J = Jmin:Jmax
    
    if isempty(origin{J})
        res.mu{J} = [];
        res.o{J} = [];
        res.a{J} = [];
        res.clusters{J} = [];
        res.fract{J} = [];
        continue
    end
    
    nTrs = getClusterNb(J,mat,clstDiag);
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
    
    % add cluster assignment in columns 7 and 8
    dt_bin_j = [dt_bin zeros(size(dt_bin,1),2)];
    for i = 1:size(dt_bin_j,1)
        x_TDP = dt_bin_j(i,5);
        y_TDP = dt_bin_j(i,6);
        if x_TDP>0 && y_TDP>0 && origin{J}.clusters(y_TDP,x_TDP)>0
            k = origin{J}.clusters(y_TDP,x_TDP);
            dt_bin_j(i,[7 8]) = [j1(k),j2(k)];
        end
    end
    
    dt_bin_new = dt_bin_j;

    if isempty(dt_bin_new)
        return
    end
    
    res.o{J} = origin{J}.o;
    res.a{J} = origin{J}.w;
    res.clusters{J} = dt_bin_new;
    res.BIC(J) = origin{J}.BIC;
    if mat
        res.mu{J} = [origin{J}.mu(j1,1),origin{J}.mu(j2,1)];
        js = 1:J;
    else
        res.mu{J} = origin{J}.mu;
        js = reshape([j1,j2]',1,2*nTrs);
    end
    res.fract{J} = zeros(size(js,2),1);
    for j = js
        clust_k = dt_bin_new(dt_bin_new(:,end-1)==j,:);
        res.fract{J}(j,1) = sum(clust_k(:,1),1)/sum(dt_bin_new(:,1),1);
    end
    res.pop{J} = zeros(nTrs,1);
    N = 0;
    for k = 1:nTrs
        Nk = size(dt_bin_new(dt_bin_new(:,7)==j1(k) & ...
            dt_bin_new(:,8)==j2(k),:),1);
        res.pop{J}(k,1) = Nk;
        N = N + Nk;
    end
    res.pop{J} = res.pop{J}/N;
end

res.boba_K = [Jopt_mean Jopt_sig];

if Jopt<=0
    setContPan('Clustering failed','error', h_fig);
end

