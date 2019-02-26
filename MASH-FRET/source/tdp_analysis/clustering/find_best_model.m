function [model,L_t,BIC_t] = find_best_model(z,x,y,J_min,J_max,T_max,M, ...
    corr,shape,lim,plotIt)
% example: [mu, clust, BIC, w, sig, rho, model, L_t, BIC_t] = ...
%    find_best_model(TDP, [], [], 1, 5, 10, 1000, 1, 'free', 1);

% z stores occurences of the frequency pair (y,x) must be size [m-by-n].
% J_min is the minimum number of components in the Gaussian mixture to fit.
% J_max is the maximum number of components in the Gaussian mixture to fit.
% T_max is the maximum number of parameter initialisations of each GMM.
% M is the maximum number of E-M iterations.
% corr=1 if cluster centers are correlated with each other (J states -> 
%     J*(J-1) clusters)
% shape is 'spherical', 'diagonal' or 'free' dependaing on the symetry of
%     the Gaussians
% plotIt=1 to plot in real time the E-M results

% mu is the [J-by-2] coordinates (x,y) of the Gaussian centers.
% clust is an [N-by-4] array contaning (x,y,z) data points and the nemuber 
%     of the Gaussian they belong to.
% BIC is the Bayesian information criterion of the optimum GMM (lowest BIC)
% w is the [J-by-1] mixture coefficients of the J components in the optimum
%     GMM.
% sig is the [2-by-2-by-J] covariance matrix of the J components in the
%     optimum GMM.
% rho is the [J-by-1] correlation coefficient for each J components in the
%     optimum GMM.

% define variables
dL = 1E-6; %  minimum difference in log likelihood
n_max = 100; % maximum invalid starting guesses


% initialization of fitting results
model = cell(1,J_max); % model structure

% initialization of t-reference
L_t = -Inf*ones(1,J_max); % likelihood = -Inf
BIC_t = Inf*ones(1,J_max); % Bayesian information criterion = Inf

% control J input
if corr
    J_min = 2;
    if J_max<=1
        disp('If coordinates are correlated, J_max>=2.');
        return;
    end
end

% create figure to plot fitting iterations
if plotIt
    hfig = figure;
    pos = get(hfig,'Position');
    pos(4) = 2*pos(4);
    pos(3) = pos(4)/2;
    set(hfig,'Position',pos);
    movegui('north');
end

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

% plot original TDP on bottom axes
if plotIt
    haxes = subplot(2,1,2,'parent',hfig);
    surface(haxes,X,Y,z,'EdgeColor','none');
    title(haxes,'experimental');
    drawnow;
end

% turn off warnings
warning('off','all');

% initialize error list
msgerr = cell(1,J_max);

for J = J_min:J_max
    
    % update number of possible state transitions
    if corr
        nTrs = J^2;
    else
        nTrs = J;
    end
    
    % initialize error list
    msgerr{J} = {};
    
    % model initialization iterations
    for t = 1:T_max
        
        % reinitialize t-iteration goodness of fit
        L = -Inf;
        BIC = Inf;
        I = false(J,size(v,2));
        
        % model starting guess
        [w,mu,sig] = init_guess(J,v,t,corr,shape,lim);
        
        % check starting guess validity
        n = 0;
        while n<n_max && (isempty(mu) || size(mu,1)~=J)
            [w,mu,sig] = init_guess(J,v,2,corr,shape,lim);
            n = n+1;
        end
        
        % only invalid starting guesses
        if n==n_max && (isempty(mu) || size(mu,1)~=J)
            continue;
        end

        if size(mu,1)==J
            
            % plot starting guess
            if plotIt
                if corr
                    mu_plot = zeros(nTrs,2);
                    j = 0;
                    for j1 = 1:J
                        for j2 = 1:J
                            j = j + 1;
                            mu_plot(j,:) = mu([j1 j2],1)';
                        end
                    end
                else
                    mu_plot = mu;
                end
                haxes = subplot(2,1,1,'replace','parent',hfig);
                obj = gmdistribution(mu_plot,sig,w');
                try
                    Z = reshape(pdf(obj,[x_v y_v]),numel(y),numel(x));
                    surface(haxes,X,Y,Z,'EdgeColor','none');
                    hold(haxes,'on');
                    plot3(haxes,mu_plot(:,1), mu_plot(:,2), ...
                        repmat(max(Z),[nTrs 1]), '+r');
                    title(haxes,['fit (J=' num2str(J) ')']);
                    drawnow;
                catch err
                    disp('error');
                    disp(err.message)
                end
            end
            
            % initialize m-reference
            L_prev = L; BIC_prev = BIC; I_prev = I;
            w_prev = w; mu_prev = mu; sig_prev = sig;
            
            % expectation-maximization iterations
            for m = 1:M

                % expectation step
                p = gmm_density(mu, sig, v, corr); % [nTrs-by-N]
                w = repmat(w,[1 N]); % [nTrs-by-N]
                h = w.*p ./ repmat(sum(w.*p,1),[size(p,1) 1]); % [nTrs-by-N]
                h(isnan(h)) = 0;

                % maximization step
                [w, mu, sig] = calc_hypprm(h, v, shape, mu, corr, lim);
                
                % maximization failed
                if ~(size(mu,1)==J)
                    
                    % update error list
                    msgerr{J} = [msgerr{J}; ['M-step converged to an ' ...
                        'insufficient number of states']];
                    
                    % reinitialize model parameters with m-reference
                    L = L_prev;
                    BIC = BIC_prev;
                    I = I_prev;
                    w = w_prev;
                    mu = mu_prev;
                    sig = sig_prev;
                    
                    % go to next t-iteration
                    break;
                end
                
                % calculate goodness of fit
                [BIC,L,I] = calc_L(w, mu, sig, v, corr, shape);
                
                % m-inferred model deteriorates compare to m-reference
                if isnan(L) || (L/sum(v(3,:)))<=(L_prev/sum(v(3,:))) + dL
                    
                    % update error list
                    if isnan(L)
                        msgerr{J} = [msgerr{J}; 'Likelihood null.'];
                    end
                    
                    % reinitialize model parameters with m-reference
                    L = L_prev;
                    BIC = BIC_prev;
                    I = I_prev;
                    w = w_prev;
                    mu = mu_prev;
                    sig = sig_prev;
                    
                    % go to next t-iteration
                    break;
                
                % m-inferred model identical to m-reference
                elseif isequal(mu,mu_prev) && isequal(w,w_prev) && ...
                        isequal(sig,sig_prev)
                    break;
                    
                % m-inferred model improves compare to m-reference
                else
                    
                    % update reference
                    L_prev = L;
                    BIC_prev = BIC;
                    I_prev = I;
                    w_prev = w;
                    mu_prev = mu;
                    sig_prev = sig;
                    
                    % plot m-inferred model on top axes
                    if plotIt
                        if corr
                            mu_plot = zeros(nTrs,2);
                            j = 0;
                            for j1 = 1:J
                                for j2 = 1:J
                                    j = j + 1;
                                    mu_plot(j,:) = mu([j1 j2],1)';
                                end
                            end
                        else
                            mu_plot = mu;
                        end
                        haxes = subplot(2,1,1,'replace','parent',hfig);
                        obj = gmdistribution(mu_plot,sig,w');
                        try
                            Z = reshape(pdf(obj,[x_v y_v]),numel(y), ...
                                numel(x));
                            surface(haxes,X,Y,Z,'EdgeColor','none');
                            hold(haxes,'on');
                            plot3(haxes,mu_plot(:,1), mu_plot(:,2), ...
                                repmat(max(max(Z)),[size(mu_plot,1) 1]),...
                                '+r');
                            title(haxes,['fit (J=' num2str(J) ')']);
                            drawnow;
                        catch err
                            disp(err.message);
                        end
                    end
                end
            end
            
            % t-inferred model improves compare to t-reference
            if L > L_t(J)
                
                % save results to return
                L_t(J) = L;
                BIC_t(J) = BIC;
                model{J}.L = L/sum(v(3,:));
                model{J}.BIC = BIC/sum(v(3,:));
                model{J}.I = I;
                model{J}.mu = mu;
                model{J}.o = sig;
                model{J}.w = w;
                model{J}.clusters = zeros(1,N);
                for j = 1:nTrs
                    model{J}.clusters(I(j,:)) = ...
                        j*ones(numel(find(I(j,:),1)),1);
                end
                model{J}.clusters = reshape(model{J}.clusters,numel(y),...
                    numel(x));
                
                % plot best t-inferred model on top axes
                if plotIt
                    if corr
                        mu_plot = zeros(nTrs,2);
                        j = 0;
                        for j1 = 1:J
                            for j2 = 1:J
                                j = j + 1;
                                mu_plot(j,:) = mu([j1 j2],1)';
                            end
                        end
                    else
                        mu_plot = mu;
                    end
                    haxes = subplot(2,1,1,'replace','parent',hfig);
                    obj = gmdistribution(mu_plot,sig,w');
                    try
                        Z = reshape(pdf(obj,[x_v y_v]),numel(y),numel(x));
                        surface(haxes,X,Y,Z,'EdgeColor','none');
                        hold(haxes,'on');
                        plot3(haxes,mu_plot(:,1), mu_plot(:,2), ...
                            repmat(max(max(Z)),[size(mu_plot,1) 1]), '+r');
                        title(haxes,['fit (J=' num2str(J) ')']);
                        drawnow;
                    catch err
                        disp(err.message)
                    end
                end
                
                % update action
                disp(cat(2,'Model J=',num2str(J),' : LogL=',...
                    num2str(model{J}.L),', BIC=',num2str(model{J}.BIC)));
                
            end
            
            % only one iteration is necessary for one Gaussian
            if J == 1
                break;
            end
            
        else
            msgerr{J} = [msgerr{J}; ['k-mean converged to an ' ...
                'insufficient number of states']];
        end
    end
    
    % update action
    if L_t(J) == -Inf
        disp(cat(2,'Model J=',num2str(J),' : convergeance impossible.'));
    end
end

% normalize BIC
BIC_t = BIC_t/sum(v(3,:));
L_t = L_t/sum(v(3,:));

% plot fitting results
if sum(BIC_t ~= Inf) && plotIt
    hfig2 = figure('Color', [1 1 1]);
    pos = get(hfig2,'Position');
    pos(4) = 2*pos(4);
    pos(3) = pos(4)/2;
    set(hfig2,'Position',pos);
    movegui('north');
    
    % plot best inferred models
    for J = J_min:J_max
        if corr
            mu_plot = zeros(J^2,2);
            j = 0;
            for j1 = 1:J
            for j2 = 1:J
                j = j + 1;
                mu_plot(j,:) = model{J}.mu([j1 j2],1)';
            end
            end
        else
            mu_plot = model{J}.mu;
        end
        haxes = subplot(2,(J_max-J_min+1),(J-J_min+1),'replace',...
            'parent',hfig2);
        obj = gmdistribution(mu_plot,model{J}.o,model{J}.w');
        try
            Z = reshape(pdf(obj,[x_v y_v]),numel(y),numel(x));
            surface(haxes,X,Y,Z,'EdgeColor','none');
            hold(haxes,'on');
            plot3(haxes,mu_plot(:,1), mu_plot(:,2), ...
                repmat(max(max(Z)),[size(mu_plot,1) 1]), '+r');
            title(haxes,['fit (J=' num2str(J) ')']);
            xlim(haxes,[v(1,1) v(1,end)]);
            ylim(haxes,[v(2,1) v(2,end)]);
            drawnow;
        catch err
            disp(cat(2,'Error:',err.message));
        end
    end
    
    % plot original TDP
    haxes = subplot(2,(J_max-J_min+1),J_max-J_min+2,'parent',hfig2);
    surface(haxes,X,Y,z,'EdgeColor','none');
    title(haxes,'experimental');
    xlim(haxes,[v(1,1) v(1,end)]);
    ylim(haxes,[v(2,1) v(2,end)]);
    drawnow;
    
    % plot BIC
    haxes = subplot(2,(J_max-J_min+1),J_max-J_min+3,'parent',hfig2);
    barh(haxes,1:J_max,BIC_t);
    xlim(haxes,[min(BIC_t) mean(BIC_t)]);
    ylim(haxes,[0 J_max+1]);
    title(haxes,'BIC');
end

% update action
disp('process completed !');


