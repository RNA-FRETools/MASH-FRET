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
%  expPrm.seq: {1-by-N} experimental state sequences (filled with state value indexes)
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

% re-arrange experimental dwell times & get state sequences
mols = unique(dt_exp0(:,2));
dt_exp = [];
for m = 1:numel(mols)
    dt_exp_m = adjustDt(dt_exp0(dt_exp0(:,2)==mols(m),:));
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

% calculate the probability for the model to generate all state sequences
J = numel(js);
B = zeros(V,J);
for v = 1:V
    B(v,degen{v}') = 1;
end
[f_lj,f_lj_norm,cl] = fwdprob(expPrm.seq,tp,B,1:V,res.ip);
logPfwd = 0;
for n = 1:numel(f_lj)
    logPfwd = logPfwd + log(sum(f_lj{n}(end,:)));
end

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

hist_sim = cell(1,V);
for j1 = 1:V
    cum_exp = cum_counts_exp{j1}/sumExp;
    maxCumExp = max(cum_exp);
    cum_sim = cum_counts_sim{j1}/sumSim;
    maxCumSim = max(cum_sim);
    cmpl_exp = 1-cum_exp/maxCumExp;
    cmpl_sim = 1-cum_sim/maxCumSim;
    
    n = numel(degen{j1});
    Ni = sum(res.n_exp(degen{j1},:),2)';
    tau = fitPrm{j1}(2:2:end);
    amp = Ni/sum(Ni);

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
        lim_x = [bins{j1}(1),bins{j1}(end)];
        
        h_a = subplot(2,V+1,j1,'replace','parent',h_fig);
        plot(h_a,bins{j1},cum_exp,'+b');
        hold(h_a,'on');
        plot(h_a,bins{j1},cum_sim,'+r');
        plot(h_a,bins{j1},fit_cum_exp,'-k');
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
end
gof = logPfwd;
