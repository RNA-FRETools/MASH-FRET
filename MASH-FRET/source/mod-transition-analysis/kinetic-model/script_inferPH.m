function mdl = script_inferPH(dt,states,expT,dt_bin,n_rs,J_deg,plotIt,sumexp,savecurve)
% mdl = script_inferPH(allSchemes,dt,expT,dt_bin,n_rs,J_deg,plotIt,sumexp,savecurve)
%
% Trains DPH distributions of specific complexities (in terms of number of degenerated levels) on experimental dwell time histograms (one histogram per state value).
% Returns best fit parameters
%
% dt: [nDt-by-3] dwell times (s), molecule indexes, state values
% states: [1-by-V] state values in dt
% expT: bin time (s)
% dt_bin: binning factor for dwell times prior building histogram
% n_rs: number of restarts
% J_deg: [1-by-V] number of degenerated levels
% plotIt: (1) to plot fit, (0) otherwise
% sumexp: (1) to fit a sume of exponential (0) to fit PH
% savecurve: empty or destination folder to save best fit curves
% mdl: structure containing fit DPH parameters
%   mdl.pi_fit: {1-by-V} starting probabilities
%   mdl.tp_fit: {1-by-V} transition probabilities among degenerated states of a same state value
%   mdl.logL: {1-by-V} log likelihoods for best fits
%   mdl.N: [1-by-V] number of data

% initialize output
mdl = struct;

% defaults
PH_type = 1;% 1 for discrete, 2 for continuous

saveit = ~isempty(savecurve);
if saveit
    pname = savecurve;
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
    if ~exist(pname,'dir')
        mkdir(pname)
    end
end

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

% calculate experimental complementary CDF for each state value z
V = numel(states);
P = cell(1,V);
x = P;
for v = 1:V
    dt_z = dt(dt(:,3)==v,1);
    if isempty(dt_z)
        continue
    end
    edg = 0.5:(max(dt_z)+0.5);
    x{v} = mean([edg(2:end);edg(1:end-1)],1);
    P{v} = histcounts(dt_z,edg);
end

% calculate phase-type complementary CDF for each state value z
pi_fit = cell(1,V);
tp_fit = pi_fit;
logL = -Inf(1,V);
nDat = zeros(1,V);
if plotIt || saveit
    P_fit = pi_fit;
    w_fit = pi_fit;
    tau_fit = pi_fit;
end
for v = 1:V
    if isempty(P{v})
        pi_fit{v} = 1;
        tp_fit{v} = [1,0];
        fprintf('state %i/%i: trap state (irreversible transition)\n',v,V);
        continue
    end
    
    v_e = ones(J_deg(v),1);

    pi_fit{v} = NaN(1,J_deg(v));
    tp_fit{v} = NaN(J_deg(v),J_deg(v)+1);
    if plotIt || saveit
        L = numel(x{v});
        P_fit{v} = zeros(1,L);
        tau_fit{v} = NaN(J_deg(v),1);
        w_fit{v} = NaN(J_deg(v)+1,J_deg(v)+1);
    end
    
    incl = (x{v}>0 & P{v}>0);

    % generate random PH parameters
    a_fit = [];
    T_fit = [];
    for rs = 1:n_rs
        
        fprintf('state %i/%i, restart %i/%i: ',v,V,rs,n_rs);

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
            if sumexp
                for j = 1:J_deg(v)
                    tp0(j,1:J_deg(v)) = 0;
                end
            end
            tp0(~~eye(size(tp0))) = 10;
            tp0 = tp0./repmat(sum(tp0,2),[1,J_deg(v)+1]);

            T_start = tp0(:,1:J_deg(v));
        end

        % train a PH model on experimental CDF
        [a_res,T_res,logL_res] = ...
            trainPH(a_start,T_start,[x{v}(incl);P{v}(incl)]);
%         [a_res,T_res,logL_res] = trainPH_matlab(PH_type,a_start,...
%             T_start,[x{v}(incl);P{v}(incl)]);
        if isempty(a_res) || isempty(T_res)
%             disp(['Optimization failed: ' errstr]);
            continue
        end
        if logL_res>logL(v)
            logL(v) = logL_res;
            a_fit = a_res;
            T_fit = T_res;
        end
    end
    if isempty(a_fit) || isempty(T_fit)
        if plotIt || saveit
            P_fit{v}(1,:) = 0;
        end
        continue
    end
    
    if plotIt || saveit
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
    end
    if saveit
        % export hitstogram and DPH fit curve
        dat = [x{v}',P{v}',P_fit{v}'];
        rname = sprintf('state%0.1f_D%i',states(v),J_deg(v));
        nf = 1;
        ffile = [pname,rname,'_dphplot'];
        while exist(ffile,'file')
            nf = nf+1;
            ffile = [pname,rname,'(',num2str(nf),')_dphplot'];
        end
        save(ffile,'dat','-ascii')
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
%     nDat(v) = sum(x{v}.*P{v});
    nDat(v) = sum(P{v});
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
    
    existPlot = false;
    for v = 1:V
        ha1 = subplot(1,2*V,2*v-1);
        xlabel(ha1,sprintf('dwell time is state %i (seconds)',v));
        if v==1
            ylabel(ha1,'PDF');
        end
        ha2 = subplot(1,2*V,2*v);
        xlabel(ha2,sprintf('dwell time is state %i (seconds)',v));
        if v==V
            hst = sgtitle(['Dwell time histograms and respective ',...
                PH_type_str,' PH distribution']);
            hst.FontSize = 12;
        end
        if isempty(P{v})
            continue
        end
        
        ha1.NextPlot = 'add';
        plot(ha1,expT_bin*x{v},P{v},'color','black','linewidth',1);
        plot(ha1,expT_bin*x{v},sum(P{v})*P_fit{v},'color','blue',...
            'linewidth',1);
        ha1.YLim = [0,max(P{v})];
        if ~existPlot
            legend(ha1,'data','fit');
            existPlot = true;
        end

        ha2.NextPlot = 'add';
        ha2.YScale = 'log';
        plot(ha2,expT_bin*x{v},P{v},'color','black','linewidth',2);
        plot(ha2,expT_bin*x{v},sum(P{v})*P_fit{v},'color','blue',...
            'linewidth',1);
        if max(P{v})==1
            ha2.YLim = [0.5,2];
        else
            ha2.YLim = [0.5,max(P{v})];
        end

        str_mat = 'w:\n';
        str_mat = [str_mat,...
            repmat([repmat('%0.2f  ',1,J_deg(v)),'%0.2f  \n'],[1,J_deg(v)+1])];
        ht3 = text(ha2.XLim(2)/8,ha2.YLim(1)+(ha2.YLim(2)-ha2.YLim(1))*0.3,...
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
        text(ha2.XLim(2)/2,ha2.YLim(1)+(ha2.YLim(2)-ha2.YLim(1))*0.07,...
            str_logL,'color','blue','fontweight','bold');
    end
end

