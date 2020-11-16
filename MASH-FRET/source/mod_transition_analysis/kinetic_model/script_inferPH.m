function [mdl,mdl_opt] = script_inferPH(allSchemes,varargin)
% [mdl,mdl_opt] = script_inferPH(allSchemes)
% [mdl,mdl_opt] = script_inferPH(allSchemes,fname,import_prm)
% [mdl,mdl_opt] = script_inferPH(allSchemes,fname,import_prm,plotIt)
%
% Import dwell times from .clst file
% Train PH distributions of specific complexities (in terms of number of degenerated levels) on experimental dwell time histograms (one histogram per state value).
% Plot PH fits
%
% allSchemes: 1 to infer parameters for all possible transition schemes, 0 for only one scheme (where all transition are allorwed)
% fname: path to file (clustered dwell times) or none to use default
% import_prm: {1-by-4} import parameters or none to use default
%  import_prm{1}: number of header lines in file
%  import_prm{2}: [1-by-4] file columns to import (time, molecule index, state index before and after transition)
%  import_prm{3}: [1-by-V] state value indexes in file
%  import_prm{4}: [1-by-V] number of degenerated levels for each state value
% plotIt: 1 to plot fit, 0 otherwise
% mdl: structure containing fit PH parameters
% mdl_opt: index in mdl of most sufficient PH complexity
%
% ex: [mdl,mdl_opt] = script_inferPH(0,'C:\data\proj1.clst',{35,[1,4,7,8],[1,2],[2,2]});

% initialize output
% t_comp = tic;
mdl = struct;
mdl_opt = [];

% defaults
% fname0 = [fileparts(which(mfilename)),'\transition_analysis\clustering',...
%     '\sim_level3_final_publish_STaSI_FRETdonacc1.clst'];
fname0 = [fileparts(which(mfilename)),'\transition_analysis\clustering',...
    '\sim_level3_final_publish_vbFRET_2states_FRETdonacc1.clst'];
import_prm0 = {35,[1,4,7,8],[1,2],[2,2]};
PH_type = 1;% 1 for discrete, 2 for continuous
expT = 0.2; % 0.2 (seconds)
n_rs = 10; % number of EM restarts
dt_bin = 1;
expT_bin = dt_bin*expT;
useGuess = false;
k0 =	[	0.000	0.080	0.250	0.000       % 0.000	0.080	0.250	0.000
            0.053	0.000	0.000	0.018       % 0.053	0.000	0.000	0.018
            0.680	0.000	0.000	0.000       % 0.680	0.000	0.000	0.000
            0.000	0.032	0.000	0.000   ];  % 0.000	0.032	0.000	0.000
tp0 = k0/expT_bin;
astart0 = [0.9,0.1];
a_min = 0; % minimum contribution to dwell time histogram (5%, ebFRET)

% import settings
plotIt = true;
if nargin==1
    fname = fname0;
    import_prm = import_prm0;
elseif nargin==3 || nargin==4
    fname = varargin{1};
    import_prm = varargin{2};
    if nargin==4
        plotIt = varargin{3};
    end
else
    disp('The number of input arguments is incorrect: type "help script_inferPH" for help');
    return
end
nhead = import_prm{1};
cols = import_prm{2};
state_id = import_prm{3};
J_deg = import_prm{4};

n = 0;
degen = cell(1,numel(J_deg));
for j = 1:numel(J_deg)
    degen{j} = [];
    for j2 = 1:J_deg(j)
        n = n+1;
        degen{j} = [degen{j} n];
    end
end

disp('>> import data');

% import data from file
f_id = fopen(fname,'r');
for fh = 1:nhead
    fgetl(f_id);
end
dt0 = [];
while ~feof(f_id)
    dt0 = cat(1,dt0,str2num(fgetl(f_id)));
end
fclose(f_id);
dt0 = dt0(:,cols);

n_id = unique(dt0(:,2))';
V = numel(state_id); % number of state values
N = numel(n_id);
Ls = zeros(1,N);
dt = [];
for n = n_id
    dt_m = adjustDt(dt0(dt0(:,2)==n,:));
    Ls(n) = round(sum(dt_m(:,1))/expT_bin);
    dt = cat(1,dt,dt_m);
end
dt(:,1) = round(dt(:,1)/expT_bin);
dt(dt(:,1)==0,1) = 1;

% calculate experimental complementary CDF for each state value z
disp('>> calculate experimental distributions');
P = cell(1,V);
x = P;
cmplP = P;
edg = P;
for v = 1:V
    dt_z = dt(dt(:,3)==v,1);
    edg{v} = 0.5:1:(max(dt_z)+0.5);
    x{v} = mean([edg{v}(2:end);edg{v}(1:end-1)],1);
    P{v} = histcounts(dt_z,edg{v});
    cumP = cumsum(P{v}/sum(P{v}));
    cmplP{v} = 1-cumP;
end

J = sum(J_deg); % number of states (incl. degenerated)

% calculate phase-type complementary CDF for each state value z
P_fit = cell(1,V);
cmplP_fit = P_fit;
pi_fit = P_fit;
tau_fit = P_fit;
w_fit = P_fit;
logL = P_fit;
BIC = P_fit;
R2 = P_fit;
mdl_opt = NaN(1,V);
nDt = zeros(1,V);
for v = 1:V
    v_e = ones(J_deg(v),1);
    L = numel(x{v});
    incl = P{v}>0;
    
    % get transition schemes
    if allSchemes
        schemes = getTransSchemes(J_deg(v));
    else
        schemes = true(J_deg(v));
        schemes(~~eye(J_deg(v))) = false;
    end
    nSch = size(schemes,3);
    
    logL{v} = -Inf(1,nSch);
    BIC{v} = Inf(1,nSch);
    P_fit{v} = zeros(nSch,L);
    R2{v} = logL{v};
    pi_fit{v} = NaN(nSch,J_deg(v));
    tau_fit{v} = NaN(J_deg(v),nSch);
    w_fit{v} = NaN(J_deg(v)+1,J_deg(v)+1,nSch);
    for sch = 1:nSch
        % generate random PH parameters
        a_fit = [];
        T_fit = [];
        for rs = 1:n_rs
            if nSch>1
                fprintf('>> process state %i/%i, scheme %i/%i, opt. restart %i/%i\n',...
                    v,V,sch,nSch,rs,n_rs);
            else
                fprintf('>> process state %i/%i, opt. restart %i/%i\n',v,V,...
                    rs,n_rs);
            end

            % use random starting guess
            a_start = ones(1,J_deg(v));
            a_start = a_start/sum(a_start);

            if PH_type==2 % continuous PH
                if ~useGuess % calculate random starting guess
                    w0 = rand(J_deg(v),J_deg(v)+1);
                    w0([~~eye(J_deg(v)) false(J_deg(v),1)]) = 0;
                    sub_w0 = w0(1:J_deg(v),1:J_deg(v));
                    sub_w0(~schemes(:,:,sch)) = 0;
                    w0(1:J_deg(v),1:J_deg(v)) = sub_w0;
                    w0 = w0./repmat(sum(w0,2),[1,J_deg(v)+1]);
                    r0 = rand(J_deg(v),1);
                    T_start = w0.*repmat(r0,[1,J_deg(v)+1]);
                else % pre-defined starting guess
                    a_start = astart0;
                    js = 1:J;
                    js(degen{v}) = [];
                    T_start = [tp0(degen{v},degen{v}),...
                        sum(tp0(degen{v},js),2)];
                end
                t = T_start(:,end);
                T_start = T_start(:,1:J_deg(v));
                T_start(~~eye(J_deg(v))) = -(sum(T_start,2)+t);
            end

            if PH_type==1 % discrete PH
                if ~useGuess % calculate random startng guess
                    tp0 = rand(J_deg(v),J_deg(v)+1);
                    sub_tp0 = tp0(1:J_deg(v),1:J_deg(v));
                    sub_tp0(~schemes(:,:,sch)) = 0;
                    tp0(1:J_deg(v),1:J_deg(v)) = sub_tp0;
                    tp0(~~eye(size(tp0))) = 10;
                    tp0 = tp0./repmat(sum(tp0,2),[1,J_deg(v)+1]);
                    T_start = tp0(:,1:J_deg(v));
                else % pre-defined starting guess
                    a_start = astart0;
                    T_start = tp0(degen{v},degen{v});
                    T_start(~~eye(size(T_start))) = ...
                        1-sum(tp0(degen{v},:),2);
                end
            end

            % train a PH model on experimental CDF
            [a_res,T_res,logL_res,errstr] = ...
                trainPH(PH_type,a_start,T_start,[x{v}(incl);P{v}(incl)]);
            if isempty(a_res) || isempty(T_res)
                disp(['Optimization failed: ' errstr]);
                continue
            end
            if sum(a_res<a_min)
                disp('Optimization failed: parameter out-of-range');
                continue
            end
            if logL_res>logL{v}(sch)
                logL{v}(sch) = logL_res;
                a_fit = a_res;
                T_fit = T_res;
            end
            if PH_type==2 % continuous PH
                r_res = -diag(T_res);
                tau_res = expT_bin./r_res;
                w_res = T_res./repmat(r_res,1,J_deg(v));
                w_res(~~eye(J_deg(v))) = 0;
                w_res = [w_res,1-sum(w_res,2);zeros(1,J_deg(v)+1)];

            else % discrete PH
                r_res = -log(diag(T_res));
                tau_res = expT_bin./r_res;
                w_res = T_res;
                w_res(~~eye(J_deg(v))) = 0;
                t = v_e-T_res*v_e;
                w_res = [w_res,t;zeros(1,J_deg(v)+1)];
                w_res = w_res./repmat(sum(w_res,2),[1,J_deg(v)+1]);
            end
            disp(a_res)
            disp(tau_res)
            disp(w_res)
        end
        if isempty(a_fit) || isempty(T_fit)
            P_fit{v}(sch,:) = 0;
            cmplP_fit{v}(sch,:) = 0;
            continue
        end

        if PH_type==1 % discrete PH
            t = v_e-T_fit*v_e;
        end
        for l = 1:L
            if PH_type==1 % discrete PH
                P_fit{v}(sch,l) = a_fit*(T_fit^(x{v}(l)-1))*t;
            else% continuous PH
                P_fit{v}(sch,l) = a_fit*expm(T_fit*x{v}(l))*v_e;
            end
        end
        P_fit{v}(sch,:) = P_fit{v}(sch,:)/sum(P_fit{v}(sch,:));
        cumP_fit = cumsum(P_fit{v}(sch,:));
        cumP_fit(cumP_fit>1) = 1;
        cmplP_fit{v}(sch,:) = 1-cumP_fit;
        R2{v}(sch) = 1-sum((cmplP{v}-cmplP_fit{v}(sch,:)).^2)/...
            sum((cmplP{v}-mean(cmplP{v})).^2);


        % get parameters from trained PH model
        pi_fit{v}(sch,:) = a_fit;
        if PH_type==2 % continuous PH
            r_z = -diag(T_fit);
            tau_fit{v}(:,sch) = expT_bin./r_z;
            w_fit_z = T_fit./repmat(r_z,1,J_deg(v));
            w_fit_z(~~eye(J_deg(v))) = 0;
            w_fit{v}(:,:,sch) = ...
                [w_fit_z,1-sum(w_fit_z,2);zeros(1,J_deg(v)+1)];
            
        else % discrete PH
            r_z = -log(diag(T_fit));
            tau_fit{v}(:,sch) = expT_bin./r_z;
            w_fit_z = T_fit;
            w_fit_z(~~eye(J_deg(v))) = 0;
            t = v_e-T_fit*v_e;
            w_fit{v}(:,:,sch) = [w_fit_z,t;zeros(1,J_deg(v)+1)];
            w_fit{v}(:,:,sch) = w_fit{v}(:,:,sch)./...
                repmat(sum(w_fit{v}(:,:,sch),2),[1,J_deg(v)+1]);
        end
        
        df_a = J_deg(v)-1;
        df_T = sum(sum(w_fit{v}(:,:,sch)>0));
        df = df_a + df_T; % degrees of freedom
        BIC{v}(sch) = df*log(sum(P{v}))-2*logL{v}(sch);
    end
    [~,mdl_opt(v)] = max(logL{v});
    nDt(v) = sum(x{v}.*P{v});
end
mdl.pi_fit = pi_fit;
mdl.tau_fit = tau_fit;
mdl.w_fit = w_fit;
mdl.logL = logL;
mdl.BIC = BIC;
mdl.N = nDt;

% plot experimental and calculated distributions
if plotIt
    disp('>> plot results');
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
%         plot(ha1,expT_bin*x{v},sum(P{v})*cmplP{v},'color','black','linewidth',2);
%         plot(ha1,expT_bin*x{v},sum(P{v})*cmplP_fit{v}(mdl_opt(v),:),'color','blue',...
%             'linewidth',1);
%         ha1.YLim = [0,sum(P{v})];

        text(ha1.XLim(2)/3,ha1.YLim(2)/4,sprintf('R^2=%0.3f',R2{v}(sch)),...
            'color','blue');

        if v==1
            legend(ha1,'data','fit');
            ylabel('Compl. CDF');
        end

        ha2 = subplot(1,2*V,2*v);
        ha2.NextPlot = 'add';
        ha2.YScale = 'log';
        xlabel(sprintf('dwell time is state %i (seconds)',v));
        plot(ha2,expT_bin*x{v},sum(P{v})*cmplP{v},'color','black','linewidth',2);
        plot(ha2,expT_bin*x{v},sum(P{v})*cmplP_fit{v}(mdl_opt(v),:),'color','blue',...
            'linewidth',1);
        ha2.YLim = [1,sum(P{v})];

        str_mat = 'w:\n';
        str_mat = [str_mat,...
            repmat([repmat('%0.2f  ',1,J_deg(v)),'%0.2f  \n'],[1,J_deg(v)+1])];
        ht3 = text(ha2.XLim(2)/8,ha2.YLim(2)*0.3,...
            sprintf(str_mat,w_fit{v}(:,:,mdl_opt(v))'),'color','blue');

        str_tau = 'tau (s)\n';
        str_tau = [str_tau,repmat('%0.2f\n',1,J_deg(v)+1)];
        ht4 = text(sum(ht3.Extent([1,3])),ht3.Position(2),...
            sprintf(str_tau,[tau_fit{v}(:,mdl_opt(v));NaN]'),'color','blue',...
            'fontweight','bold');
        
        str_pi = 'pi\n';
        str_pi = [str_pi,repmat('%0.2f\n',1,J_deg(v)+1)];
        text(sum(ht4.Extent([1,3])),ht4.Position(2),...
            sprintf(str_pi,[pi_fit{v}(mdl_opt(v),:),NaN]),'color','blue',...
            'fontweight','bold');

        str_logL = sprintf('logL=%0.6f\nBIC=%0.6f',logL{v}(mdl_opt(v)),...
            BIC{v}(mdl_opt(v)));
        text(ha2.XLim(2)/2,ha2.YLim(2)*0.07,str_logL,'color','blue',...
            'fontweight','bold');

        if v==V
            hst = sgtitle([sprintf(...
                'Dwell time histograms (data: %i traces, median trace length=%0.0f)',...
                N,median(Ls)),' and respective ',PH_type_str,' PH distribution']);
            hst.FontSize = 12;
        end
    end
end
% fprintf('Fit completed in %0.0f seconds\n',toc(t_comp));


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
        
%         if all(all(abs(T-T_prev)<d_min)) && all(abs(a-a_prev)<d_min) % EM successfully converged
%             a = a_prev;
%             T = T_prev;
%             logL = logL_prev;
%             actstr = 'EM successfully converged';
%             break
%         end
        if (logL-logL_prev)<dL_min % EM successfully converged (faster)
            a = a_prev;
            T = T_prev;
            logL = logL_prev;
            actstr = 'EM successfully converged';
            break
        end

        m = m+1;
        if m==M
            actstr = 'maximum number of iterations as been reached';
        end
    end

    fprintf('Best fit: logL=%d, %i iterations\n',logL,m);

    if m>=M
        a_fin = [];
        T_fin = [];
        logL_fin = -Inf;
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
    
    % complete-data likelihood (hard assignment of dwelltime to individual state)
%     P = zeros(1,N);
%     for n = 1:N
%         [p,id] = max(expm(T*x(n))*t);
%         P(:,n) = p*a(id);
%     end
%     logL = sum(count.*log(P(:,n)));

    % incomplete-data likelihood (soft assignment)
    logL = 0;
    for n = 1:N
        logL = logL + count(n)*log(a*(expm(T*x(n))*t));
    end
    
elseif PH_type==1 % discrete PH

    % incomplete-data likelihood (soft assignment)
    t = ones(J,1)-T*ones(J,1);
    logL = 0;
    for n = 1:N
        logL = logL + count(n)*log(a*(T^(x(n)-1)*t));
    end
end




