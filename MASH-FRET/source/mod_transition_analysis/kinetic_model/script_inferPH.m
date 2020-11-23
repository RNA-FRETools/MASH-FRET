function mdl = script_inferPH(dt,states,expT,dt_bin,J_deg,plotIt)
% mdl = script_inferPH(allSchemes,dt,expT,dt_bin,J_deg,plotIt)
%
% Trains DPH distributions of specific complexities (in terms of number of degenerated levels) on experimental dwell time histograms (one histogram per state value).
% Returns best fit parameters
%
% dt: [nDt-by-3] dwell times (s), molecule indexes, state values
% states: [1-by-V] state values in dt
% expT: bin time (s)
% dt_bin: binning factor for dwell times prior building histogram
% J_deg: [1-by-V] number of degenerated levels
% plotIt: (1) to plot fit, (0) otherwise
% mdl: structure containing fit DPH parameters
%   mdl.pi_fit: {1-by-V} starting probabilities
%   mdl.tp_fit: {1-by-V} transition probabilities among degenerated states of a same state value
%   mdl.logL: {1-by-V} log likelihoods for best fits
%   mdl.N: [1-by-V] number of data

% initialize output
mdl = struct;

% defaults
PH_type = 1;% 1 for discrete, 2 for continuous
n_rs = 10; % number of EM restarts
nb = 0; % initializes number of bytes written in command window

expT_bin = dt_bin*expT;
n = 0;
degen = cell(1,numel(J_deg));
for j = 1:numel(J_deg)
    degen{j} = [];
    for j2 = 1:J_deg(j)
        n = n+1;
        degen{j} = [degen{j} n];
    end
end
dt(:,1) = round(dt(:,1)/expT_bin);
dt(dt(:,1)==0,1) = 1;

% calculate experimental complementary CDF for each state value z
V = numel(states);
P = cell(1,V);
if plotIt
    cmplP = P;
end
x = P;
for v = 1:V
    dt_z = dt(dt(:,3)==v,1);
    edg = 0.5:1:(max(dt_z)+0.5);
    x{v} = mean([edg(2:end);edg(1:end-1)],1);
    P{v} = histcounts(dt_z,edg);
    if plotIt
        cmplP{v} = 1-cumsum(P{v}/sum(P{v}));
    end
end

% calculate phase-type complementary CDF for each state value z
pi_fit = cell(1,V);
tp_fit = pi_fit;
logL = -Inf(1,V);
nDat = zeros(1,V);
if plotIt
    P_fit = pi_fit;
    cmplP_fit = pi_fit;
    w_fit = pi_fit;
    tau_fit = pi_fit;
end
totcnt = V*n_rs;
cnt = 0;
nb = dispProgress(sprintf('%i%%%%',round(100*cnt/totcnt)),nb);
for v = 1:V
    v_e = ones(J_deg(v),1);
    incl = P{v}>0;

    pi_fit{v} = NaN(1,J_deg(v));
    tp_fit{v} = NaN(J_deg(v),J_deg(v)+1);
    if plotIt
        L = numel(x{v});
        P_fit{v} = zeros(1,L);
        tau_fit{v} = NaN(J_deg(v),1);
        w_fit{v} = NaN(J_deg(v)+1,J_deg(v)+1);
    end

    % generate random PH parameters
    a_fit = [];
    T_fit = [];
    for rs = 1:n_rs

        % use random starting guess
        a_start = ones(1,J_deg(v));
        a_start = a_start/sum(a_start);

        if PH_type==2 % continuous PH
            w0 = rand(J_deg(v),J_deg(v)+1);
            w0([~~eye(J_deg(v)) false(J_deg(v),1)]) = 0;
            w0 = w0./repmat(sum(w0,2),[1,J_deg(v)+1]);

            r0 = rand(J_deg(v),1);

            T_start = w0.*repmat(r0,[1,J_deg(v)+1]);
            t = T_start(:,end);
            T_start = T_start(:,1:J_deg(v));
            T_start(~~eye(J_deg(v))) = -(sum(T_start,2)+t);
        end

        if PH_type==1 % discrete PH
            tp0 = rand(J_deg(v),J_deg(v)+1);
            tp0(~~eye(size(tp0))) = 10;
            tp0 = tp0./repmat(sum(tp0,2),[1,J_deg(v)+1]);

            T_start = tp0(:,1:J_deg(v));
        end

        % train a PH model on experimental CDF
        [a_res,T_res,logL_res,errstr] = ...
            trainPH(PH_type,a_start,T_start,[x{v}(incl);P{v}(incl)]);
        if isempty(a_res) || isempty(T_res)
%             disp(['Optimization failed: ' errstr]);
            continue
        end
        if logL_res>logL(v)
            logL(v) = logL_res;
            a_fit = a_res;
            T_fit = T_res;
        end
        
        cnt = cnt+1;
        nb = dispProgress(sprintf('%i%%%%',round(100*cnt/totcnt)),nb);
    end
    if isempty(a_fit) || isempty(T_fit)
        if plotIt
            P_fit{v}(1,:) = 0;
            cmplP_fit{v}(1,:) = 0;
        end
        continue
    end
    
    if plotIt
        if PH_type==1 % discrete PH
            t = v_e-T_fit*v_e;
        end
        for l = 1:L
            if PH_type==1 % discrete PH
                P_fit{v}(1,l) = a_fit*(T_fit^(x{v}(l)-1))*t;
            else% continuous PH
                P_fit{v}(1,l) = a_fit*expm(T_fit*x{v}(l))*v_e;
            end
        end
        P_fit{v}(1,:) = P_fit{v}(1,:)/sum(P_fit{v}(1,:));
        cumP_fit = cumsum(P_fit{v}(1,:));
        cumP_fit(cumP_fit>1) = 1;
        cmplP_fit{v}(1,:) = 1-cumP_fit;
    end

    % get parameters from trained PH model
    pi_fit{v} = a_fit;
    if PH_type==2 % continuous PH
        r_v = -diag(T_fit)/dt_bin;
        w = T_fit./repmat(r_v,1,J_deg(v));
        w(~~eye(J_deg(v))) = 0;
        w = cat(2,w,1-sum(w,2));
    else % discrete PH
        t = v_e-T_fit*v_e;
%         r_v = -log(diag(T_fit))/dt_bin;
        k = [T_fit,t];
        k(~~eye(J_deg(v))) = 0;
        r_v = sum(k,2)/dt_bin;
        w = k./repmat(sum(k,2),[1,J_deg(v)+1]);
    end
    tp_fit{v} = w.*repmat(r_v,[1,J_deg(v)+1]);
    tp_fit{v}(~~eye(J_deg(v))) = 1-sum(tp_fit{v},2);
    if plotIt
        tau_fit{v} = expT./r_v;
        w_fit{v} = w;
    end
    nDat(v) = sum(x{v}.*P{v});
end
mdl.pi_fit = pi_fit;
mdl.tp_fit = tp_fit;
mdl.logL = logL;
mdl.N = nDat;

% plot experimental and calculated distributions
if plotIt
    hfig = figure('color','white');
    hfig.Position = [hfig.Position([1,2]),2*hfig.Position(3),hfig.Position(4)];
    switch PH_type
        case 1
            PH_type_str = 'discrete';
        case 2
            PH_type_str = 'continuous';
    end
    for v = 1:V
        ha1 = subplot(1,2*V,2*v-1);
        ha1.NextPlot = 'add';
        xlabel(sprintf('dwell time is state %i (seconds)',v));
        plot(ha1,expT_bin*x{v},P{v},'color','black','linewidth',1);
        plot(ha1,expT_bin*x{v},sum(P{v})*P_fit{v},'color','blue',...
            'linewidth',1);
        ha1.YLim = [0,max(P{v})];

        if v==1
            legend(ha1,'data','fit');
            ylabel('Compl. CDF');
        end

        ha2 = subplot(1,2*V,2*v);
        ha2.NextPlot = 'add';
        ha2.YScale = 'log';
        xlabel(sprintf('dwell time is state %i (seconds)',v));
        plot(ha2,expT_bin*x{v},sum(P{v})*cmplP{v},'color','black','linewidth',2);
        plot(ha2,expT_bin*x{v},sum(P{v})*cmplP_fit{v},'color','blue',...
            'linewidth',1);
        ha2.YLim = [1,sum(P{v})];

        str_mat = 'w:\n';
        str_mat = [str_mat,...
            repmat([repmat('%0.2f  ',1,J_deg(v)),'%0.2f  \n'],[1,J_deg(v)+1])];
        ht3 = text(ha2.XLim(2)/8,ha2.YLim(2)*0.3,...
            sprintf(str_mat,w_fit{v}'),'color','blue');

        str_tau = 'tau (s)\n';
        str_tau = [str_tau,repmat('%0.2f\n',1,J_deg(v))];
        ht4 = text(sum(ht3.Extent([1,3])),ht3.Position(2),...
            sprintf(str_tau,tau_fit{v}),'color','blue',...
            'fontweight','bold');
        
        str_pi = 'pi\n';
        str_pi = [str_pi,repmat('%0.2f\n',1,J_deg(v))];
        text(sum(ht4.Extent([1,3])),ht4.Position(2),...
            sprintf(str_pi,pi_fit{v}),'color','blue',...
            'fontweight','bold');

        str_logL = sprintf('logL=%0.6f',logL(v));
        text(ha2.XLim(2)/2,ha2.YLim(2)*0.07,str_logL,'color','blue',...
            'fontweight','bold');

        if v==V
            hst = sgtitle(['Dwell time histograms and respective ',...
                PH_type_str,' PH distribution']);
            hst.FontSize = 12;
        end
    end
end


function [a,T,logL,actstr] = trainPH(PH_type,a0,T0,P)

% default
M = 1E5; % maximum number of EM iterations
dL_min = 1E-6; % convergeance criteria on likelihood (faster)
d_min = 1E-8; % convergeance criteria on parameters (from SMACKS)

N = sum(P(2,:));

a_start = a0;
T_start = T0;
S = size(a_start,1);
for s = 1:S
    m = 0;
    a = a_start(s,:);
    T = T_start(:,:,s);
    logL = -Inf;
    while m<M
        a_prev = a;
        T_prev = T;
        logL_prev = logL;

        % E-step
        [B,Z,Nij,Ni] = PH_Estep(PH_type,a,T,P);

        % M-step
        [a,T,t] = PH_Mstep(PH_type,B,Z,Nij,Ni,N);
        
        % likelihood
        logL = PH_likelihood(PH_type,a,T,P);
        
        % check for convergence
%         if (logL-logL_prev)<dL_min || ...
%                 all(all(abs(T-T_prev)<d_min)) && all(abs(a-a_prev)<d_min)
        if (logL-logL_prev)<dL_min
            actstr = 'EM successfully converged';
            break
        end

        m = m+1;
        if m==M
            actstr = 'maximum number of iterations as been reached';
        end
    end

%     fprintf('Best fit: logL=%d, %i iterations\n',logL,m);

    if m>=M
        a = [];
        T = [];
        logL = -Inf;
        actstr = 'The maximum number of iteration has been reached';
    end
end


function [B,Z,Nij,Ni] = PH_Estep(PH_type,a,T,data)

x = data(1,:);
count = data(2,:);
J = numel(a);
N = numel(x);

% initialization
Nij = zeros(J);
B = Nij(1,:);
Z = Nij(1,:);
Ni = Nij(:,1);
E = eye(J);
v_e = ones(J,1);
denom = zeros(1,N);

if PH_type==1 % discrete PH
    % preliminary calculations
    t = v_e-T*v_e;
    Ty_pow = zeros(J,J,N);
    Kij = zeros(J,J,N);
    for n = 1:N
        if x(n)>1
            mat = [T,t*a;zeros(J),T]^(x(n)-1);
            Ty_pow(:,:,n) = mat(1:J,1:J);
            Kij(:,:,n) = mat(1:J,(J+1):end);
        else
            Ty_pow(:,:,n) = T^0;
        end

        denom(n) = a*(Ty_pow(:,:,n)*t);
    end

    % expectation calculation
    for j = 1:J
        for n = 1:N
            B(j) = B(j)+...
                count(n)*a(j)*(E(j,:)*(Ty_pow(:,:,n)*t))/denom(n);
            for j2 = 1:J
                if x(n)>1
                    Nij(j,j2) = Nij(j,j2)+ ...
                        count(n)*(T(j,j2)*Kij(j2,j,n))/denom(n);
                end
            end
            Ni(j) = Ni(j)+...
                count(n)*a*(Ty_pow(:,:,n)*(E(:,j)*t(j)))/denom(n);
        end
    end
    
elseif PH_type==2% continuous PH
    % preliminary calculations
    t = -T*v_e;
    exp_Ty = zeros(J,J,N);
    Jij = zeros(J,J,N);
    for n = 1:N
        mat = expm([T,t*a;zeros(J),T]*x(n));
        exp_Ty(:,:,n) = mat(1:J,1:J);
        Jij(:,:,n) = mat(1:J,(J+1):end);

        denom(n) = a*(exp_Ty(:,:,n)*t);
    end

    % expectation calculation
    for j = 1:J
        for n = 1:N
            B(j) = B(j)+count(n)*a(j)*(E(j,:)*(exp_Ty(:,:,n)*t))/denom(n);
            Z(j) = Z(j)+count(n)*Jij(j,j,n)/denom(n);
            for j2 = 1:J
                if j==j2
                    continue
                end
                Nij(j,j2) = Nij(j,j2)+...
                    count(n)*T(j,j2)*Jij(j2,j,n)/denom(n);
            end
            Ni(j) = Ni(j)+...
                count(n)*a*(exp_Ty(:,:,n)*(E(:,j)*t(j)))/denom(n);
        end
    end
end


function [a,T,t] = PH_Mstep(PH_type,B,Z,Nij,Ni,totcount)

J = numel(B);

a = B/totcount;

if PH_type==2 % continuous PH
    T = Nij./repmat(Z',[1,J]); 
    t = Ni./Z';

    js = 1:J;
    for j = 1:J
        j2s = js(js~=j);
        T(j,j) = -sum(T(j,j2s))-t(j);
    end
elseif PH_type==1 % discrete PH
    T = zeros(J);
    t = zeros(J,1);
    for j1 = 1:J
        t(j1) = Ni(j1)/(Ni(j1)+sum(Nij(j1,:)));
        for j2 = 1:J
            T(j1,j2) = Nij(j1,j2)/(Ni(j1)+sum(Nij(j1,:)));
        end
    end
end


function logL = PH_likelihood(PH_type,a,T,data)
x = data(1,:);
count = data(2,:);
N = numel(x);
J = numel(a);

if PH_type==2 % continuous PH
    t = -T*ones(J,1);
    logL = 0;
    for n = 1:N
        logL = logL + count(n)*log(a*(expm(T*x(n))*t));
    end
    
elseif PH_type==1 % discrete PH
    t = ones(J,1)-T*ones(J,1);
    logL = 0;
    for n = 1:N
        logL = logL + count(n)*log(a*(T^(x(n)-1)*t));
    end
end




