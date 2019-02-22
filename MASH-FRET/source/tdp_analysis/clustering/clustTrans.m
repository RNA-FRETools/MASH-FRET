function res = clustTrans(dt_bin, TDP, plot_prm, clust_prm, varargin)

M_def = 500; % default max. number of maximization iteration
plotIter_def = 0; % plot/not EM results while iterating
Kmin_def = 2; % minimum configuration

meth = clust_prm{1}(1); % clustering method
shape = clust_prm{1}(2); % cluster shape
Kmax = clust_prm{1}(3); % max. number of states
T = clust_prm{1}(4); % max. number of k-mean iterations/GMM initialisations
mu_0 = clust_prm{2}(:,1); % starting guess for states
tol = clust_prm{2}(:,2); % k-mean tolerance radius around states
boba = clust_prm{4}(1); % apply/not bootstrapped (BS) clustering
n_spl = clust_prm{4}(2); % number of BS samples
n_rep = clust_prm{4}(3); % number of BS replicates in one sample

bins = plot_prm{1};
lim = plot_prm{2}; % TDP x & y limits
rate = plot_prm{3}(1); % frame rate
onecount = plot_prm{3}(2); % one/total transition count per molecule
gconv = plot_prm{3}(3); % one/total transition count per molecule
norm = plot_prm{3}(4); % one/total transition count per molecule

if ~(~isempty(varargin) && ishandle(varargin{1}))
    h_fig = [];
else
    h_fig = varargin{1};
end

res.mu = [];
res.a = [];
res.o = [];
res.clusters = [];
res.BIC = [];
res.boba_K = [];

[mols,o,o] = unique(dt_bin(:,4));
nMol = numel(mols);

if ~boba
    n_spl = 1;
else
    h_axes = [];
    if nMol ~= n_rep
        n_rep = nMol;
    end
end
res.n_rep = n_rep;

if boba && ~isempty(h_fig)
    % randomly select dynamic molecules
    err = loading_bar('init', h_fig, n_spl+1, ['Performing ' ...
        'randomisation and clustering ...']);
    if err
        return;
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
end

param = cell(1,n_spl);
n_states = nan(1,n_spl);

iv_x = lim(1,1):bins(1):lim(1,2);
iv_y = lim(2,1):bins(2):lim(2,2);
x = mean([iv_x(1:end-1);iv_x(2:end)],1);
y = mean([iv_y(1:end-1);iv_y(2:end)],1);

for k = 1:n_spl
    if boba
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

        [TDP_spl,o,o,coord_spl] = hist2(data_spl_m(:,[2 3]),[iv_x;iv_y]);
    else
        TDP_spl = TDP;
    end
    
    
    % TDP convolution with Gaussian filter
    if gconv
        TDP_spl = convGauss(TDP_spl, 0.0005, lim);
    end

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
            [mu_spl,clust_spl] = get_kmean(mu_0, tol, T, TDP_spl, x, y, 1);
            Kopt = size(mu_spl,1);
            BIC = []; a = []; sig = [];
            if boba
                param{k} = {mu_spl};
            else
                param{k} = {mu_spl clust_spl};
            end
            
        case 2 % GMM clustering

            [mu_spl,clust_spl,BIC_spl,a_spl,sig_spl,o,o,o,o] = ...
                find_best_model(TDP_spl, x, y, Kmin_def, Kmax, T, M_def,...
                true,shape_str,max(bins),plotIter_def);
            Kopt = size(mu_spl,1);
            mu_spl = mu_spl';
            param{k} = {mu_spl clust_spl BIC_spl a_spl sig_spl};
    end
    n_states(k) = Kopt;
    
    if boba && ~isempty(h_fig)
        err = loading_bar('update', h_fig);
        if err
            break;
        end
    end
end

if boba
    param(isnan(n_states)) = [];
    n_states(isnan(n_states)) = [];
    Kopt_mean = mean(n_states);
    Kopt_int = round(Kopt_mean);
    Kopt_sig = std(n_states);
    spl_opt = n_states==Kopt_int;
    param_opt = param(spl_opt);
    
    if Kopt_int==0
        return;
    end
        
    if meth==1
        mu = zeros(size(param_opt{1}{1}));
        for s = 1:size(param_opt,1)
            mu = mu + param_opt{s}{1}/size(param_opt,1);
        end
        [mu clust] = get_kmean(mu, tol, T, TDP_spl, x, y, 1);
        mu = mu';
    
    elseif meth==2
        mu = zeros(size(param_opt{1}{1}));
        clust = zeros([size(param_opt{1}{2}) Kopt_int^2]);
        BIC = zeros(size(param_opt{1}{3}));
        a = zeros(size(param_opt{1}{4}));
        sig = zeros(size(param_opt{1}{5}));
        for s = 1:size(param_opt,2)
            
            clust_spl = zeros([size(param_opt{1}{2}) Kopt_int^2]);
            for k = 1:Kopt_int^2
                clust_spl(:,:,k) = double(param_opt{1}{2}==k);
            end
            clust = clust + clust_spl;
            BIC = BIC + param_opt{s}{3}/size(param_opt,2);
            mu = mu + param_opt{s}{1}/size(param_opt,2);
            a = a + param_opt{s}{4}/size(param_opt,2);
            sig = sig + param_opt{s}{5}/size(param_opt,2);
        end
        a = a/sum(a);
        [o,clust] = max(clust,[],3);
    end
    
    if boba && ~isempty(h_fig) && ~err
        err = loading_bar('update', h_fig);
        if err
            return;
        end
    end
    
    Kopt = Kopt_int;
    if ~isempty(h_fig)
        loading_bar('close', h_fig);
    end
    
else
    switch meth
        case 1 %k-mean clustering
            mu = param{1}{1}';
            clust = param{1}{2};
            
        case 2 % GMM clustering
            mu = param{1}{1};
            clust = param{1}{2};
            BIC = param{1}{3};
            a = param{1}{4};
            sig = param{1}{5};
    end
    Kopt_mean = [];
    Kopt_sig = [];
end

disp(cat(2,'Kopt = ',num2str(Kopt));

% used for Model selection evaluation paper:
%
% if ~isempty(h_fig)
%     h = guidata(h_fig);
%     p = h.param.TDP;
%     proj = p.curr_proj;
%     [o,fname_proj,o] = fileparts(p.proj{proj}.proj_file);
%     saveStatesResults(param,cat(2,fname_proj,'_',num2str(shape),'.txt'));
% end

if sum(sum(clust))==0
    return;
end

id_k = [];
for k1 = 1:Kopt
    for k2 = 1:Kopt
        id_k = [id_k;k1 k2];
    end
end

dt_bin = [dt_bin zeros(size(dt_bin,1),2)];
for i = 1:size(dt_bin,1)
    if dt_bin(i,5)>0 && dt_bin(i,6)>0 && clust(dt_bin(i,6),dt_bin(i,5))>0
        dt_bin(i,[7 8]) = id_k(clust(dt_bin(i,6),dt_bin(i,5)),:);
    end
end

[mols,o,o] = unique(dt_bin(:,4));
dt_bin_new = [];
for m = mols'
    dt_bin_m = dt_bin(dt_bin(:,4)==m,:);
%     dt_bin_m  = adjustDt(dt_bin_m);
    dt_bin_new = [dt_bin_new; dt_bin_m];
end
dt_bin_new(:,1) = round(dt_bin_new(:,1)/rate)*rate;

if isempty(dt_bin_new)
    return;
end

res.mu = mu';
res.o = sig;
res.a = a;
res.clusters = dt_bin_new;
res.BIC = BIC;
res.fract = zeros(Kopt,1);
res.boba_K = [Kopt_mean Kopt_sig];
res.fract = zeros(Kopt,1);

for k = 1:Kopt
    clust_k = dt_bin_new(dt_bin_new(:,end-1)==k,:);
    res.fract(k,1) = sum(clust_k(:,1),1)/sum(dt_bin(:,1),1);
end



