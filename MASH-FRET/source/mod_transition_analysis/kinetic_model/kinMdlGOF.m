function [gof,res] = kinMdlGOF(degen,mat,r,expPrm,opt,varargin)
% [gof,res] = kinMdlGOF(degen,mat,r,expPrm,opt)
% [gof,res] = kinMdlGOF(degen,mat,r,expPrm,opt,h_fig)
%
% Calculate the goodness of fit of the model defined by the matrix of transition probabilities or transition numbers.
% Eventually plot simulated dwell time histograms, state population and transition counts in comparison to experimental data.
%
% degen: {1-by-V} column vectors grouping indexes of degenerated states
% mat: matrix to vary
% r: transition rate constants restricted to 2 states (in s-1)
% expPrm: structure containing experimental data and parameters, with fields:
%  expPrm.dt: [nDt-by-3] dwell times (seconds) and state indexes before and after transition
%  expPrm.A: [1-by-K] relative contributions of degenerated states in dwell time histograms
%  expPrm.Ls: [1-by-N] experimental trajectory lengths
%  expPrm.expT: binning time
%  expPrm.fitPrm: fitting parameters
%  expPrm.excl: (1) to exclude first and last dwell times of each sequence, (0) otherwise
% opt: 'n','w' or 'tp' to optimize the matrix of number of transitions (fixed restricted rates), the repartition probability matrix (fixed restricted rates) or the transition probability matrix respectively
% h_fig: handle to figure where data are plotted

% default
plotIt = false; % true to plot

if ~isempty(varargin)
    h_fig = varargin{1};
    if ~isempty(h_fig)
        plotIt = true;
    end
end
Ls = expPrm.Ls;
expT = expPrm.expT;
dt_exp0 = expPrm.dt;
fitPrm = expPrm.fitPrm;
excl = expPrm.excl;
A = expPrm.A;
V = numel(degen);
L_ref = sum(Ls);

% re-arrange experimental dwell times & get state sequences
mols = unique(dt_exp0(:,2));
dt_exp = [];
% seq_exp = cell(1,numel(mols));
for m = 1:numel(mols)
    dt_exp_m = adjustDt(dt_exp0(dt_exp0(:,2)==mols(m),:));
%     seq_exp{m} = getDiscrFromDt(dt_exp_m(:,[1,3,4]),expT);
    if excl
        dt_exp_m([1,end],:) = [];
    end
    dt_exp = cat(1,dt_exp,dt_exp_m);
end

% simulate large reference state sequence with actual model parameters
switch opt
    case 'n'
        w = mat./repmat(sum(mat,2),[1,size(mat,2)]);
        tp = w.*repmat(expT*r',[1,size(mat,2)]);
        tp(~~eye(size(tp))) = 1-sum(tp,2);
        res = simStateSequences(tp,expT*r,Ls);
    case 'w'
        tp = mat.*repmat(expT*r',[1,size(mat,2)]);
        tp(~~eye(size(tp))) = 1-sum(tp,2);
        res = simStateSequences(tp,expT*r,Ls);
    case 'tp'
        tp = mat;
        res = simStateSequences(tp,[],Ls);
    case 'k'
        tp = mat;
        tp(~~eye(size(tp))) = 1-sum(tp,2);
        res = simStateSequences(tp,[],Ls);
end
dt_sim0 = res.dt;
if sum(sum(res.w_exp,1)==0) || sum(sum(res.w_exp,2)==0) || ...
        sum(sum(isnan(res.w_exp)))
    res = [];
    gof = -Inf;
    return
end

% count nb. of transitions
Nsim = [];
Nsim_degen = [];
Nexp = [];
k = 0;
ylbl = {};
for v1 = 1:V
    Nsim_degen = cat(1,Nsim_degen,zeros(1,V));
    for v2 = 1:V
        if v1==v2
            continue
        end
        for j1 = degen{v1}'
            k = k+1;
            Nsim = cat(2,Nsim,0);
            Nexp = cat(2,Nexp,A(k)*...
                numel(dt_exp(dt_exp(:,3)==v1 & dt_exp(:,4)==v2,1)));
            ylbl = cat(2,ylbl,sprintf('%i',k));
            for j2 = degen{v2}'
                Nsim(end) = Nsim(end)+...
                    numel(dt_sim0(dt_sim0(:,3)==j1 & dt_sim0(:,4)==j2,1));
                Nsim_degen(v1,v2) = Nsim_degen(end)+...
                    numel(dt_sim0(dt_sim0(:,3)==j1 & dt_sim0(:,4)==j2,1));
            end
        end
    end
end
% Nexp = Nexp/sum(Nexp);
% Nsim = Nsim/sum(Nsim);

% fusion dwells from degenerated states
js = [];
for v = 1:V
    js = cat(2,js,degen{v}');
    for j_degen = degen{v}'
        dt_sim0(dt_sim0(:,3)==j_degen,3) = v;
        dt_sim0(dt_sim0(:,4)==j_degen,4) = v;
    end
end
mols_sim = unique(dt_sim0(:,2));
dt_sim = [];
for m = mols_sim'
    dt_sim_m = adjustDt(dt_sim0(dt_sim0(:,2)==m,:));
    if excl
        dt_sim_m([1,end],:) = [];
    end
    dt_sim = cat(1,dt_sim,dt_sim_m);
end
dt_sim(:,1) = dt_sim(:,1)*expT; % convert frame count to time
res.dt = dt_sim; % save dwell time set
dt_sim = dt_sim(:,[1,3:end]); % remove molecule index

% compare experimental sequences to reference and calculate model's score
% seq_ref = getDiscrFromDt(dt_sim,expT);
% TPm = zeros(1,numel(mols));
% parfor m = 1:numel(mols')
%     [TPm(m),pos,cnf] = countSeqProb(seq_exp{m},seq_ref,false);
%     if ~isempty(cnf)
%         TPm(m) = TPm(m)*cnf;
%     end
% end
% score = sum(TPm)/sum(Ls);

% err_cum = 0;
% for m = 1:numel(mols')
%     err_cum = err_cum + calcSeqError(dt_exp(dt_exp(:,2)==mols(m),:),dt_sim);
% end
% score = 1/err_cum;

% calculate the probability for the model to generate all state sequences
J = numel(js);
B = zeros(V,J);
for v = 1:V
    B(v,degen{v}') = 1;
end
logProb = fwdprob(expPrm.seq,tp,B,1:V,res.ip);

gof = 0;
sumExp = 0;
sumSim = 0;
cum_counts_exp = cell(1,V);
cum_counts_sim = cell(1,V);
bins = cell(1,V);
ndtExp = cell(1,V);
ndtSim = cell(1,V);
maxDt = zeros(1,V);
minDt = zeros(1,V);
popSim = zeros(1,V);
popExp = zeros(1,V);
for j1 = 1:V
    dt_sim_j1 = dt_sim(dt_sim(:,2)==j1,1);
    dt_exp_j1 = dt_exp(dt_exp(:,3)==j1,1);
    
    popSim(j1) = sum(dt_sim_j1);
    popExp(j1) = sum(dt_exp_j1);

    maxDt(j1) = max([dt_sim_j1;dt_exp_j1]);
    minDt(j1) = min([dt_sim_j1(dt_sim_j1>0);dt_exp_j1(dt_exp_j1>0)]);
    bins{j1} = expT:expT:maxDt(j1);

    % build cumulated dwell time histgrams
    cum_counts_exp{j1} = cumsum(histcounts(dt_exp_j1,[bins{j1},Inf])');
    cum_counts_sim{j1} = cumsum(histcounts(dt_sim_j1,[bins{j1},Inf])');
    
    ndtExp{j1} = max(cum_counts_exp{j1});
    ndtSim{j1} = max(cum_counts_sim{j1});
    
    sumExp = sumExp+ndtExp{j1};
    sumSim = sumSim+ndtSim{j1};
end
% popExp = popExp/sum(popExp);
% popSim = popSim/sum(popSim);

hist_sim = cell(1,V);
for j1 = 1:V
    cum_exp = cum_counts_exp{j1}/sumExp;
%     cum_exp = cum_counts_exp{j1};
    maxCumExp = max(cum_exp);
    cum_sim = cum_counts_sim{j1}/sumSim;
%     cum_sim = cum_counts_sim{j1};
    maxCumSim = max(cum_sim);
    cmpl_exp = 1-cum_exp/maxCumExp;
    cmpl_sim = 1-cum_sim/maxCumSim;
    
    n = numel(degen{j1});
    
    % fit simulated dwell time histogram (time consuming)
%     fitbounds.start = fitPrm{j1};
%     fitbounds.lower = zeros(1,2*n);
%     fitbounds.upper = Inf(1,2*n);
%     [tau,amp,~] = fitMultiExp(cmpl_sim',bins{j1},fitbounds);
    
    Ni = sum(res.n_exp(degen{j1},:),2)';
    tau = fitPrm{j1}(2:2:end);
    amp = Ni/sum(Ni);

%     fit_cum_sim = zeros(size(bins{j1}));
%     for i = 1:n
%         fit_cum_sim = fit_cum_sim + amp(i)*exp(-bins{j1}/tau(i));
%     end
% %     fit_cum_sim = maxCumSim*(1-fit_cum_sim)/sumSim;
% %     fit_cmpl_sim = 1-sumSim*fit_cum_sim/maxCumSim;
%     fit_cum_sim = maxCumSim*(1-fit_cum_sim);
%     fit_cmpl_sim = 1-fit_cum_sim/maxCumSim;

    hist_sim{j1} = cum_sim/(max(cum_sim)*sum(tau.*amp));

    % build fit function for experimental dwell time histogram
    fit_cum_exp = zeros(size(bins{j1}));
    for i = 1:n
        fit_cum_exp = fit_cum_exp + ...
            fitPrm{j1}(2*(i-1)+1)*exp(-bins{j1}/fitPrm{j1}(2*i));
    end
    fit_cum_exp = maxCumExp*(1-fit_cum_exp);
    fit_cmpl_exp = 1-fit_cum_exp/maxCumExp;
    
    % plot histograms and fit functions
    if plotIt
        lim_y = [min([cum_exp(cum_exp>0)',...
            cum_sim(cum_sim>0)']),...
            max([cum_exp(cum_exp>0)',...
            cum_sim(cum_sim>0)'])];
%         dat_id = cmpl_exp>0;
%         max_x = find(dat_id==0);
%         max_x = max_x(1);
        lim_x = [bins{j1}(1),bins{j1}(end)];
        
        h_a = subplot(2,V+1,j1,'replace','parent',h_fig);
        plot(h_a,bins{j1},cum_exp,'+b');
        hold(h_a,'on');
        plot(h_a,bins{j1},cum_sim,'+r');
        plot(h_a,bins{j1},fit_cum_exp,'-k');
%         plot(h_a,bins{j1},fit_cum_sim,'-k'); % fit of simulation
        hold(h_a,'off');
        ylim(h_a,lim_y);
        xlim(h_a,lim_x);

        lim_y = [min([cmpl_exp(cmpl_exp>0)',...
            cmpl_sim(cmpl_sim>0)']),...
            max([cmpl_exp(cmpl_exp>0)',...
            cmpl_sim(cmpl_sim>0)'])];

        h_a = subplot(2,V+1,V+1+j1,'replace','parent',h_fig);
        plot(h_a,bins{j1},cmpl_exp,'+b');
        hold(h_a,'on');
        plot(h_a,bins{j1},cmpl_sim,'+r');
        plot(h_a,bins{j1},fit_cmpl_exp,'-k');
%         plot(h_a,bins{j1},fit_cmpl_sim,'-k'); % fit of simulation
        hold(h_a,'off');
        set(h_a,'yscale','log');
        ylim(h_a,lim_y);
        xlim(h_a,lim_x);
        
        if j1==1
            % plot relative FRET state populations
            h_a = subplot(2,V+1,V+1,'replace','parent',h_fig);
            b = bar(h_a,1:V,[popSim',popExp']);
            set(b(1),'facecolor','r');
            set(b(2),'facecolor','b');
            title(h_a,'state occupancy');
            
            % plot relative transition counts
            h_a = subplot(2,V+1,2*(V+1),'replace','parent',h_fig);
            b = bar(h_a,1:numel(Nsim),[Nsim',Nexp']);
            set(b(1),'facecolor','r');
            set(b(2),'facecolor','b');
            title(h_a,'transition count');
            set(h_a,'xticklabel',ylbl);
        end
        
        drawnow;
    end
    
    % calculate log probability
%     incl = cmpl_sim>0 & fit_cmpl_exp'>0;
%     Y_cmpl = log(cmpl_sim(incl));
%     Yfit_cmpl = log(fit_cmpl_exp(incl)');
    
    incl = cum_sim>0 & fit_cum_exp'>0;
%     Y_cum = log(cum_sim(incl));
%     Yfit_cum = log(fit_cum_exp(incl)');
    
    % calculate GOF = N/RSSE
%     gof_lin_cum = numel(fit_cum_exp(incl))/sqrt(sum((fit_cum_exp(incl)'-cum_sim(incl)).^2));
%     gof_lin_cmpl = 1/sqrt(sum((fit_cmpl_exp'-cmpl_sim).^2));
%     gof_log_cmpl = -sum(Y_cmpl)/sqrt(sum(((Yfit_cmpl-Y_cmpl).^2)));
    
    % calculate GOF = N/sum of absolute differences
%     gof_lin_cmpl = sum(fit_cmpl_exp)/sum(abs(fit_cmpl_exp'-cmpl_sim));
    gof_lin_cmpl = 1/sum(abs(fit_cmpl_exp-cmpl_sim')./fit_cmpl_exp);
%     gof_log_cmpl = -sum(Y_cmpl)/sum(abs(Yfit_cmpl-Y_cmpl));
%     gof_lin_cum = sum(fit_cum_exp(incl))/sum(abs((fit_cum_exp(incl)'-cum_sim(incl))));
    gof_lin_cum = 1/sum(abs(fit_cum_exp(incl)-cum_sim(incl)')/fit_cum_exp(incl));
%     gof_pop = sum(popExp)/sum(abs(popSim-popExp));
%     gof_ntrans = sum(Nexp)/sum(abs(Nsim-Nexp));
    gof_ntrans = 1/sum(abs(Nsim-Nexp)./Nexp);
    
    % increment GOF
%     gof = gof + log(gof_ntrans)+log(gof_lin_cmpl*gof_lin_cum);
%     gof = gof + log(gof_lin_cmpl*gof_lin_cum);
end
gof = logProb;
% gof = gof + log(score);
% gof = gof + calcModelProb(dt_exp,expT,hist_sim,Nsim_degen);
