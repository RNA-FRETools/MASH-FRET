function [mu, clust, BIC, w, sig, rho, model, L_t, BIC_t] = ...
    find_best_model(z, x, y, K_min, K_max, T_max, M, corr, shape, lim, ...
    plotIt)
% example: [mu, clust, BIC, w, sig, rho, model, L_t, BIC_t] = ...
%    find_best_model(TDP, [], [], 1, 5, 10, 1000, 1, 'free', 1);

% z stores occurences of the frequency pair (y,x) must be size [m-by-n].
% K_min is the minimum number of components in the Gaussian mixture to fit.
% K_max is the maximum number of components in the Gaussian mixture to fit.
% T_max is the maximum number of parameter initialisations of each GMM.
% M is the maximum number of E-M iterations.
% corr=1 if cluster centers are correlated with each other (K states -> 
%     K*(K-1) clusters)
% shape is 'spherical', 'diagonal' or 'free' dependaing on the symetry of
%     the Gaussians
% plotIt=1 to plot in real time the E-M results

% mu is the [K-by-2] coordinates (x,y) of the Gaussian centers.
% clust is an [N-by-4] array contaning (x,y,z) data points and the nemuber 
%     of the Gaussian they belong to.
% BIC is the Bayesian information criterion of the optimum GMM (lowest BIC)
% w is the [K-by-1] mixture coefficients of the K components in the optimum
%     GMM.
% sig is the [2-by-2-by-K] covariance matrix of the K components in the
%     optimum GMM.
% rho is the [K-by-1] correlation coefficient for each K components in the
%     optimum GMM.

if corr
    K_min = 2;
    if K_max<=1
        disp('If coordinates are correlated, K_max>=2.');
        return;
    end
end

if plotIt
    figure;
    pos = get(gcf,'Position');
    pos(4) = 2*pos(4);
    pos(3) = pos(4)/2;
    set(gcf,'Position',pos);
    movegui('north');
end

% Initialisation
model = cell(1,K_max); % model structure
clusters = cell(1,K_max); % clustered data from "dat"

% vectorize martix data (x,y,z)
if isempty(x)
    x = mean([1:size(z,2)-1;1:size(z,2)],1);
end
if isempty(y)
    y = mean([0:size(z,1)-1;1:size(z,1)],1);
end
[X,Y] = meshgrid(x,y);
x_v = reshape(X,[numel(X),1]);	y_v = reshape(Y,[numel(Y),1]);
v = [x_v y_v reshape(z,[numel(z) 1])]';
N = size(v,2);

if plotIt
    subplot(2,1,2);
    surface(X,Y,z,'EdgeColor','none');
    title('experimental');
    drawnow;
end

% initialisation of fitting results
L_t = -Inf*ones(1,K_max); % likelihood = -Inf
BIC_t = Inf*ones(1,K_max); % Bayesian information criterion = Inf

msgerr = cell(1,K_max);

% turn off warnings
warning('off','all');

for K = K_min:K_max
    
    if corr
        nTrs = K^2;
    else
        nTrs = K;
    end
    msgerr{K} = {};

    for t = 1:T_max
        % initialisation

        [w, mu, sig] = init_guess(K, v, t, corr, shape, lim);
        
        n_max = 100;
        n = 0;
        while n<n_max && (isempty(mu) || size(mu,1)~=K)
            [w, mu, sig] = init_guess(K, v, t, corr, shape, lim);
            n = n+1;
        end
        
        if n==n_max && (isempty(mu) || size(mu,1)~=K)
            continue;
        end
        
        L = -Inf;
        BIC = Inf;
        I = false(K,size(v,2));
        
        if size(mu,1)==K
            if plotIt
            if corr
                mu_plot = zeros(nTrs,2);
                k = 0;
                for k1 = 1:K
                    for k2 = 1:K
                        k = k + 1;
                        mu_plot(k,:) = mu([k1 k2],1)';
                    end
                end
            else
                mu_plot = mu;
            end
            subplot(2,1,1,'replace');
            obj = gmdistribution(mu_plot,sig,w');
            try
                Z = reshape(pdf(obj,[x_v y_v]),numel(y),numel(x));
                surface(X,Y,Z,'EdgeColor','none');
                hold on;
                plot3(mu_plot(:,1), mu_plot(:,2), ...
                    repmat(max(Z),[nTrs 1]), '+r');
                title(['fit (K=' num2str(K) ')']);
                drawnow;
            catch err
                disp('error');
                disp(err.message)
            end
            end
            L_prev = L; BIC_prev = BIC; I_prev = I;
            w_prev = w; mu_prev = mu; sig_prev = sig;

            for m = 1:M % for each E-M iteration

                % Expectation (E-step)
                p = gmm_density(mu, sig, v, corr); % [nTrs-by-N]
                w = repmat(w,[1 N]); % [nTrs-by-N]
                h = w.*p ./ repmat(sum(w.*p,1),[size(p,1) 1]); % [nTrs-by-N]
                h(isnan(h)) = 0;

                % M-step
                [w, mu, sig] = calc_hypprm(h, v, shape, mu, corr, lim);

                if ~(size(mu,1)==K)
                    msgerr{K} = [msgerr{K}; ['M-step converged to an ' ...
                        'insufficient number of states']];
                    L = L_prev;
                    BIC = BIC_prev;
                    I = I_prev;
                    w = w_prev;
                    mu = mu_prev;
                    sig = sig_prev;
                    break;
                end
                
                % calculate logL
                [BIC L I] = calc_L(w, mu, sig, v, corr, shape);
                if isnan(L) || (L/sum(v(3,:)))<=(L_prev/sum(v(3,:)))+1E-6
                    if isnan(L)
                        msgerr{K} = [msgerr{K}; 'Likelihood null.'];
                    end
                    L = L_prev;
                    BIC = BIC_prev;
                    I = I_prev;
                    w = w_prev;
                    mu = mu_prev;
                    sig = sig_prev;
                    break;
                    
                elseif isequal(mu,mu_prev) && isequal(w,w_prev) && ...
                        isequal(sig,sig_prev)
                    break;
                else
                    L_prev = L;
                    BIC_prev = BIC;
                    I_prev = I;
                    w_prev = w;
                    mu_prev = mu;
                    sig_prev = sig;
                    if plotIt
                        if corr
                            mu_plot = zeros(nTrs,2);
                            k = 0;
                            for k1 = 1:K
                                for k2 = 1:K
                                    k = k + 1;
                                    mu_plot(k,:) = mu([k1 k2],1)';
                                end
                            end
                        else
                            mu_plot = mu;
                        end
                        subplot(2,1,1,'replace');
                        obj = gmdistribution(mu_plot,sig,w');
                        try
                            Z = reshape(pdf(obj,[x_v y_v]),numel(y), ...
                                numel(x));
                            surface(X,Y,Z,'EdgeColor','none');
                            hold on;
                            plot3(mu_plot(:,1), mu_plot(:,2), ...
                                repmat(max(max(Z)),[size(mu_plot,1) 1]),...
                                '+r');
                            title(['fit (K=' num2str(K) ')']);
                            drawnow;
                        catch err
                            disp(err.message);
                        end
                    end
                end
            end
            if BIC < BIC_t(K)
                L_t(K) = L;
                BIC_t(K) = BIC;
                model{K}.I = I;
                model{K}.mu = mu;
                model{K}.o = sig;
                model{K}.w = w;
                clusters{K} = zeros(1,N);
                for k = 1:nTrs
                    clusters{K}(I(k,:)) = k*ones(numel(find(I(k,:),1)),1);
                end
                clusters{K} = reshape(clusters{K},numel(y),numel(x));
                if plotIt
                    if corr
                        mu_plot = zeros(nTrs,2);
                        k = 0;
                        for k1 = 1:K
                            for k2 = 1:K
                                k = k + 1;
                                mu_plot(k,:) = mu([k1 k2],1)';
                            end
                        end
                    else
                        mu_plot = mu;
                    end
                    subplot(2,1,1,'replace');
                    obj = gmdistribution(mu_plot,sig,w');
                    try
                        Z = reshape(pdf(obj,[x_v y_v]),numel(y),numel(x));
                        surface(X,Y,Z,'EdgeColor','none');
                        hold on;
                        plot3(mu_plot(:,1), mu_plot(:,2), ...
                            repmat(max(max(Z)),[size(mu_plot,1) 1]), '+r');
                        title(['fit (K=' num2str(K) ')']);
                        drawnow;
                    catch err
                        disp(err.message)
                    end
                end
                disp(sprintf(['\nModel ' num2str(K) ':\nLogL: ' ...
                        num2str(L/sum(v(3,:))) '\nBIC: ' ...
                        num2str(BIC/sum(v(3,:))) '\n']));
                
            end
            if K == 1
                break;
            end
        else
            msgerr{K} = [msgerr{K}; ['k-mean converged to an ' ...
                'insufficient number of states']];
        end
    end

    if L_t(K) == -Inf
        disp(sprintf(['\nModel ' num2str(K) ...
            ':\nConvergeance impossible.\n']));
    else
        disp(sprintf(['\nModel ' num2str(K) ':\nLogL: ' ...
            num2str(L_t(K)/sum(v(3,:))) '\nBIC: ' ...
            num2str(BIC_t(K)/sum(v(3,:))) '\n']));
    end
end

if sum(BIC_t ~= Inf)
    [o,Kopt] = min(BIC_t);
    mu = model{Kopt}.mu;
    sig = model{Kopt}.o;
    w = model{Kopt}.w;
    BIC = BIC_t(Kopt)/N;
    clust = clusters{Kopt};
    rho = permute(sig(1,2,:)./sqrt(sig(1,1,:).*sig(2,2,:)),[3 2 1]);
    disp(cat(2,'Optimum number of states: ',num2str(Kopt)));
    if plotIt
        figure('Color', [1 1 1])
        pos = get(gcf,'Position');
        pos(4) = 2*pos(4);
        pos(3) = pos(4)/2;
        set(gcf,'Position',pos);
        movegui('north');
        
        for K = K_min:K_max
            if corr
                mu_plot = zeros(K^2,2);
                k = 0;
                for k1 = 1:K
                for k2 = 1:K
                    k = k + 1;
                    mu_plot(k,:) = model{K}.mu([k1 k2],1)';
                end
                end
            else
                mu_plot = model{K}.mu;
            end
            subplot(2,(K_max-K_min+1),(K-K_min+1),'replace');
            obj = gmdistribution(mu_plot,model{K}.o,model{K}.w');
            try
                Z = reshape(pdf(obj,[x_v y_v]),numel(y),numel(x));
                surface(X,Y,Z,'EdgeColor','none');
                hold on;
                plot3(mu_plot(:,1), mu_plot(:,2), ...
                    repmat(max(max(Z)),[size(mu_plot,1) 1]), '+r');
                title(['fit (K=' num2str(K) ')']);
                xlim([v(1,1) v(1,end)]);
                ylim([v(2,1) v(2,end)]);
                drawnow;
            catch err
                disp(cat(2,'Error:',err.message));
            end
            
            subplot(2,(K_max-K_min+1),(K_max-K_min+1)+K-K_min+1);
            surface(X,Y,z,'EdgeColor','none');
            title('experimental');
            xlim([v(1,1) v(1,end)]);
            ylim([v(2,1) v(2,end)]);
            drawnow;
        end
    end

else
    mu = [];
    sig = [];
    w = [];
    rho = [];
    BIC = Inf;
    clust = [];
end

disp('process completed !');


