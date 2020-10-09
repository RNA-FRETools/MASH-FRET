function [model,L_t,BIC_t] = find_best_model(z,x,y,J_min,J_max,T_max,M, ...
    mat,shape,lim,plotIt,clstDiag,lklhd)
% [model,L_t,BIC_t] = find_best_model(z,x,y,J_min,J_max,T_max,M,mat,shape,lim,plotIt,clstDiag,lklhd)
%
% z: vector or matrix to cluster
% x: empty or vector of coordinates of each column's center of the TDP
% y: empty or vector of coordinates of each row's center of the TDP
% J_min: minimum number of components in the Gaussian mixture to fit.
% J_max: maximum number of components in the Gaussian mixture to fit.
% T_max: maximum number of model initialisations.
% M: maximum number of E-M iterations.
% mat: (1) infer a square matrix of clusters, (2) infer symmetrical clusters separated by the TDP diagonal (3) no constraint on cluster centers
% shape: cluster shape ('spherical','ellipsoid straight','ellipsoid diagonal','free')
% plotIt: true to plot in real time the E-M results, false otherwise
% lklhd: 1 for complete data likelihood, 2 for incomplete data likelihood
% clustDiag: true to include diagonal clusters in cluster matrix, false otherwise
%
% model: {1-by-J_max} structure containing fields:
%  model.L: normalized log-Likelihood (best inferred model)
%  model.BIC: normalized Bayesian information criterion (best inferred model)
%  model.I: [J-by-N] classification of transitions into clusters (best inferred model)
%  model.mu: [J-by-2] coordinates (x,y) of the Gaussian centers (best inferred model)
%  model.o: [2-by-2-by-J] covariance matrix (best inferred model)
%  model.w: [J-by-1] mixture coefficients (best inferred model)
%  model.clusters: [m-by-n] cluster indexes for each TDP bin (best inferred model)
% L_t: [1-by-J_max] highest inferred Likelihoods
% BIC_t: [1-by-J_max] lowest inferred Bayesian information criterion

% default
dL = 1E-6; %  minimum difference in log likelihood
n_max = 100; % maximum invalid starting guesses

% initialization of fitting results
model = cell(1,J_max); % model structure

% initialization of t-reference
L_t = -Inf*ones(1,J_max); % likelihood = -Inf
BIC_t = Inf*ones(1,J_max); % Bayesian information criterion = Inf

% control J input
if mat==1 % matrix
    if J_min<2
        disp('Cluster matrix requires J>=2.');
        J_min = 2;
    end
elseif mat~=1 && clstDiag
    disp('Diagonal clusters are only for the cluster matrix option.');
    clstDiag = false;
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
    nTrs = getClusterNb(J,mat,clstDiag);
    
    % initialize error list
    msgerr{J} = {};
    
    % model initialization iterations
    for t = 1:T_max
        
        % reinitialize t-iteration goodness of fit
        L = -Inf;
        BIC = Inf;
        I = false(J,size(v,2));
        
        % model starting guess
        [w,mu,sig] = init_guess(J,v,t,mat,shape,lim,clstDiag);
        
        % check starting guess validity
        n = 0;
        while n<n_max && size(mu,1)~=J
            [w,mu,sig] = init_guess(J,v,2,mat,shape,lim,clstDiag);
            n = n+1;
        end
        
        % only invalid starting guesses
        if n==n_max && size(mu,1)~=J
            msgerr{J} = [msgerr{J}; ...
                'k-mean converged to an insufficient number of states'];
            continue
        end
            
        % plot starting guess
        if plotIt
            h_axes = subplot(2,1,1, 'replace', 'parent', h_fig);
            plotGMMinfer(mat, clstDiag, J, mu, sig, w, h_axes);
        end

        % initialize m-reference
        L_prev = L; BIC_prev = BIC; I_prev = I;
        w_prev = w; mu_prev = mu; sig_prev = sig;

        % expectation-maximization iterations
        for m = 1:M

            % expectation step
            p = gmm_density(mu, sig, v, mat, clstDiag); % [nTrs-by-N]
            w = repmat(w,[1 N]); % [nTrs-by-N]
            h = w.*p ./ repmat(sum(w.*p,1),[size(p,1) 1]); % [nTrs-by-N]
            h(isnan(h)) = 0;

            % maximization step
            [w, mu, sig] = calc_hypprm(h, v, shape, mu, mat, lim, ...
                clstDiag);

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
                break
            end

            % calculate goodness of fit
            [BIC,L,I] = calc_L(w, mu, sig, v, mat, shape, lklhd, clstDiag);

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
                break

            % m-inferred model identical to m-reference
            elseif isequal(mu,mu_prev) && isequal(w,w_prev) && ...
                    isequal(sig,sig_prev)
                break

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
                    h_axes = subplot(2,1,1, 'replace', 'parent', h_fig);
                    plotGMMinfer(mat, clstDiag, J, mu, sig, w, h_axes);
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
                model{J}.clusters(I(j,:)) = j*ones(sum(I(j,:)),1);
            end
            model{J}.clusters = reshape(model{J}.clusters,numel(y),...
                numel(x));

            % plot best t-inferred model on top axes
            if plotIt
                h_axes = subplot(2,1,1, 'replace', 'parent', h_fig);
                plotGMMinfer(mat, clstDiag, J, mu, sig, w, h_axes);
            end

            % update action
            disp(cat(2,'Model J=',num2str(J),' : LogL=',...
                num2str(model{J}.L),', BIC=',num2str(model{J}.BIC)));

        end
            
        % only one iteration is necessary for one Gaussian
        if J == 1
            break
        end
    end
    
    % update action
    if isinf(L_t(J))
        disp(cat(2,'Model J=',num2str(J),' : convergeance impossible.'));
    end
end

% normalize BIC
BIC_t = BIC_t/sum(v(3,:));
L_t = L_t/sum(v(3,:));

% plot fitting results
if sum(~isinf(BIC_t)) && plotIt
    hfig2 = figure('Color', [1 1 1]);
    pos = get(hfig2,'Position');
    pos(4) = 2*pos(4);
    pos(3) = pos(4)/2;
    set(hfig2,'Position',pos);
    movegui('north');
    
    % plot best inferred models
    for J = J_min:J_max
        if isempty(model{J})
            continue
        end
        h_axes = subplot(2,(J_max-J_min+1),(J-J_min+1),'replace','parent',...
            hfig2);
        plotGMMinfer(mat, clstDiag, J, model{J}.mu, model{J}.o, model{J}.w,...
            h_axes);
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


