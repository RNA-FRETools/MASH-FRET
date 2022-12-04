function res = rmse_ana(h_fig, isBIC, penalty, Jmax, val, likl)

res = cell(1,2);

T = 5; % number of model (GMM) initializations
M = 500; % maximum number of E-M cycles
N = size(val,2); % number of data points

% initialisation of results
LogL_t = -Inf*ones(1,Jmax); % negative log likelihood
BIC_t = Inf*ones(1,Jmax);
mu_t = cell(1,Jmax);
sig_t = cell(1,Jmax);
a_t = cell(1,Jmax);

% turn off the fitting warning
warning('off','all');

% initialize error managment
str = [];
msgerr = cell(1,Jmax);

if ~isempty(h_fig)
    setContPan(cat(2,'Calculate optimum state configurations with ',...
        'maximum ',num2str(Jmax),' states...'),'process',h_fig);
end

for J = 1:Jmax
    
    msgerr{J} = {};
    
    for t = 1:T
        
        % initialize GMM
        [a, mu, sig] = init_guess(J, val, t);
        
        % re-initialize current maximum LogL and minimum BIC
        LogL = -Inf;
        BIC = Inf;
        
        I = false(J,N); % binary operator (data affiliation to a Gaussian)
        
        if size(mu,1)==J % GMM properly initialized
            
            % set current maximum LogL and minimum BIC
            LogL_prev = LogL; BIC_prev = BIC; I_prev = I;
            
            % set current optimum coefficients
            a_prev = a; mu_prev = mu; sig_prev = sig;
            
            % E-M iterations
            for m = 1:M
                
                % Expectation (E-step)
                prob = mbd_density(mu, sig, val);
                
                a = repmat(a,[1 size(val,2)]);
                h = a.*prob./repmat(sum(a.*prob,1),[J 1]);
                h(isnan(h)) = 0;
                
                % Maximization (M-step)
                [a, mu, sig] = calc_hypprm(h, val);
                
                if ~(size(mu,1)==J)
                    msgerr{J} = [msgerr{J}; ['M-step converged to an ' ...
                        'insufficient number of states']];
                    LogL = LogL_prev;
                    BIC = BIC_prev;
                    I = I_prev;
                    a = a_prev;
                    mu = mu_prev;
                    sig = sig_prev;
                    break;
                end
                
                % calculate LogL and BIC
                [BIC,LogL,I] = calc_L(a, mu, sig, val, likl);
                
                % when the GOF is worse, E-M stops
                if isnan(LogL) || (LogL/sum(val(2,:)))<(LogL_prev/sum(val(2,:)))
                    if isnan(LogL)
                        msgerr{J} = [msgerr{J}; 'Likelihood null.'];
                    end
                    LogL = LogL_prev;
                    BIC = BIC_prev;
                    I = I_prev;
                    a = a_prev;
                    mu = mu_prev;
                    sig = sig_prev;
                    break;
                
                % when the parameters do not change, E-M stops
                elseif isequal(mu,mu_prev) && isequal(a,a_prev) && ...
                        isequal(sig,sig_prev)
                    break;
                    
                else
                    LogL_prev = LogL;
                    BIC_prev = BIC;
                    I_prev = I;
                    a_prev = a;
                    mu_prev = mu;
                    sig_prev = sig;
                end
            end
            
            % update optimum GMM for J
            if (isBIC && BIC<BIC_t(J)) || (~isBIC && LogL>LogL_t(J))
                LogL_t(J) = LogL;
                BIC_t(J) = BIC;
                mu_t{J} = mu;
                sig_t{J} = sig;
                a_t{J} = a;
            end
            if J == 1
                break;
            end
        end
    end
    
    % Display results
    if LogL_t(J)>-Inf
        disp(sprintf(['GMM of ' num2str(J) ' Gaussians:' ...
            ' LogL=' num2str(LogL_t(J)/sum(val(2,:))) ...
            ' BIC=' num2str(BIC_t(J)/sum(val(2,:)))]));
    else
        disp(sprintf(['GMM of ' num2str(J) ' Gaussians:\n' ...
            'convergeance impossible\n']));
    end
end

% model selection
if (isBIC && sum(BIC_t ~= Inf)) || (~isBIC && sum(LogL_t ~= -Inf))
    
    [o,Kopt_BIC] = min(BIC_t);
    
    Kopt_pen = 1;
    for k = 2:Jmax
        if ((LogL_t(k)-LogL_t(k-1))/abs(LogL_t(k-1)))> ...
                (penalty-1)
            Kopt_pen = k;
        else
            break;
        end
    end
    
    % normalize LogL and BIC
    BIC_t = BIC_t/sum(val(2,:));
    LogL_t = LogL_t/sum(val(2,:));

    for J = 1:Jmax
   
        if LogL_t(J)>-Inf % calculate relative population
            sum_k = 0;
            pop = zeros(J,1);
            for k = 1:J
                pop(k,1) = a_t{J}(k,1)*normpdf(mu_t{J}(k,1),mu_t{J}(k,1), ...
                    sig_t{J}(k,1));
                sum_k = sum_k + a_t{J}(k,1)*sum(normpdf(val(1,:), ...
                    mu_t{J}(k,1),sig_t{J}(k,1)));
            end
            pop = pop/sum_k;
            res{1,1} = [LogL_t' BIC_t'];
            
            % convert sigma to FWHM
            FWHM = (2*sqrt(2*log(2)))*sig_t{J};
            res{1,2}{J} = [pop mu_t{J} FWHM];
            
        else % did not converge to a model
            res{1,2}{J} = [];
        end
    end

    if ~isempty(h_fig)
        setContPan(sprintf(cat(2,'Optimum configuration: %i states (BIC) ',...
            'and %i states (penalty=',num2str(penalty),')'),Kopt_BIC,...
            Kopt_pen),'success', h_fig);
    end
else
    if ~isempty(h_fig)
        setContPan('Convergeance impossible.', 'warning', h_fig);
    end
end


function [a, mu, sigma] = init_guess(J, val, t)

w = val(2,:);
data = val(1,:);

% priors of each cluster a_k = 1/J
a = ones(J,1)/J;

% generate evenly spread centers over the TDP
maxval = max(data);
minval = min(data);

if t == 1
    mu = linspace(minval, maxval, J+2)';
    mu = mu(2:end-1,1);
else
    N = size(val,2);
    mu = zeros(J,1);
    for k = 1:J
        [o,id] = max(rand(1,N));
        mu(k,1) = data(id);
    end
end

w = round(w/min(w(w>0)));

sigma = ones(J,1);
try
    dat = [];
    for i = 1:size(data,2)
        dat = [dat repmat(data(i),[1 w(i)])];
    end
    id = kmeans(dat',J);
catch err
    a = [];
    mu = [];
    sigma = [];
    return;
end
for k = 1:J
    mu(k,1) = mean(dat(id==k));
    sigma(k,1) = 2*sqrt(2*log(2))*std(dat(id==k));
end


function prob = mbd_density(mu, sig, val)
% mu = [J-by-1]
% sig = [J-by-1]
% val = [2-by-N]
% prob_s = [J-by-N]

N = size(val,2);
J = size(mu,1);
prob = zeros(J,N);

for k = 1:J
    prob(k,:) = normpdf(val(1,:),mu(k,1),sig(k));
end


function [BIC,logL,I] = calc_L(a, mu, sig, val, likl)

w = val(2,:);

logL = -Inf;
BIC = Inf;
J = size(mu,1);
N = size(val,2);
I = false(J,N);

p = mbd_density(mu, sig, val);
if isempty(p) || sum(sum(isnan(p)))
    return;
end

[x,i] = max(p,[],1);
i(:,sum(p,1)<=0) = 0;
P = zeros(1,N);

for k = 1:size(p,1)
    I(k,:) = (i==k);
    switch likl
        case 'complete'
            P(I(k,:)) = P(I(k,:)) + a(k)*p(k,I(k,:)); % to calculate complete-data likelihood 
        case 'incomplete'
            P = P + a(k)*p(k,:); % to calculate incomplete-data likelihood 
    end
end

logL = sum((w(P>0).*log(P(P>0))));

if logL == 0
    logL = -Inf;
    BIC = Inf;
    I = false(J,N);
    return;
end

f_sig = J;
f_a = J-1; % when n-1 coefficients are known, the n-th coefficient is known as 1-sum(n coefficients)
f_mu = J;

BIC = (f_sig + f_a + f_mu)*log(sum(w)) - 2*logL;


function [a, mu, sig] = calc_hypprm(h, val)
% prob = [J-by-N] joint probability
% val = [1-by-N] data
% mu = [J-by-1] state values
% a = [J-by-1] peak weights
% sig = [J-by-1] sigma

w = val(2,:);
data = val(1,:);
J = size(h,1);

sig = ones(J,1);
mu = zeros(J,1);
a = (sum(repmat(w,[J 1]).*h,2)/sum(w));

for k = 1:J
    mu(k,1) = sum(w.*h(k,:).*data/sum(w.*h(k,:)),2); % x
end

for k = 1:J
    sig(k,1) = sqrt(sum(w.*h(k,:).*((data-mu(k,1)).^2),2)/sum(w.*h(k,:)));
end
i = isnan(mu) | sig<mu*0.0005;
mu(i,:) = [];
sig(i,:) = [];
a(i,:) = [];

[mu,id] = sort(mu);
sig = sig(id,:);
a = a(id,:);

