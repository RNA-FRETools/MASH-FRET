function discr = discr_cpa(trace, varargin)
% Change-point analysis and discretisation script adapted from:
% Taylor, Wayne A. (2000), "Change-Point Analysis: A Powerful New Tool For
% Detecting Changes"
% WEB: http://www.variation.com/cpa/tech/changepoint.html
%
% "trace" >> [m-by-n] matrix containing the n traces
% "cp" >> {1-by-n} cell array containing changing points
% "discr" >> [m-by-n] matrix containing the n discretised traces
%
% optional input arguments:
% 1) number of bootstrap samples to estimate change amplitude
% 2) confidence level for detection of a significant change.
% 3) changing point determination method: 1 (max) or 2 (mse)
% 4) correlation analysis: changing zone width

% Created the 7th of March 2014 by Mélodie C.A.S. Hadzic
% Last update the 10th of March 2014 by Mélodie C.A.S. Hadzic



%% Initialisation

% parameters
[n_smpl sgn_lvl ana_type correl tol Kmax] = getParam(varargin);
if ana_type == 1
    ana_type = 'max';
elseif ana_type == 2
    ana_type = 'mse';
end
T = 10;
shape = 'spherical';

% input data
if size(trace,1) < size(trace,2)
    trace = trace';
end

% output data
cp = cell(1,size(trace,2));
discr = zeros(size(trace));


%% Analysis

disp('Determination of significant change points ...');

% determination of significant CP
for n = 1:size(trace,2)
    cp{n} = cpa_bs_ana(trace(:,n), n_smpl, sgn_lvl, ana_type);
end

% screening of correlated CP
if correl && ~mod(size(trace,2),2)
    cp_corr = cell(size(cp));
    for t = 1:size(trace,2)/2
        [o,min_np] = min([size(cp{t*2-1},2) size(cp{t*2},2)]);
        chan_in = t*2-(2-min_np);
        chan_cmp = t*2-abs(1-min_np);
        for p = 1:numel(cp{chan_in})
            [o,i_p,v_p] = find(cp{chan_cmp} <= (cp{chan_in}(p)+tol/2) & ...
                cp{chan_cmp} >= (cp{chan_in}(p)-tol/2));
            if ~isempty(v_p)
                new_cp = round(mean([cp{chan_in}(p) cp{chan_cmp}(i_p)]));
                cp_corr{chan_in} = [cp_corr{chan_in} new_cp];
                cp_corr{chan_cmp} = [cp_corr{chan_cmp} new_cp];
                cp{chan_cmp}(i_p) = [];
            end
        end
    end
    cp = cp_corr;
end

% discretisation
for n = 1:size(trace,2)
    p = [0 cp{n} numel(trace(:,n))];
    for i = 1:numel(p)-1
        means(i,n) = mean(trace((p(i)+1):p(i+1),n));
        discr((p(i)+1):p(i+1),n) = means(i,n);
    end
end

% dat = getDtFromDiscr(discr, 1);
% dat = [dat ones(size(dat,1),1)];
% 
% if size(dat,1)>2
%     [mu, clust, o, o, o] = modelClust(dat(1:end-1,:), Kmax, T, 100, ...
%         [2 3], Inf, shape, [], []);
%     clust  = adjustDt(clust);
% else
%     clust = dat(1:end-1,1:end-1);
% end
% if size(clust,1)>1 && sum(sum(clust(:,(end-1):end),1))
%     clust(:,2) = mu(clust(:,end-1));
%     clust(:,3) = mu(clust(:,end));
%     clust = clust(:,1:3);
%     last_state = clust(end,end);
%     clust = [clust; dat(end,1) last_state NaN];
%     clust = delFalseTrs(clust);
%     
% elseif size(clust,1)==1 % one transition
%     clust = [clust; [numel(trace)-clust(1) ...
%         mean(trace(clust(1)+1:numel(trace))) NaN]];
% else % statics
%     clust = [numel(trace) mean(trace) NaN];
% end
% 
% discr = getDiscrFromDt(clust, 1)';

% %% plot
% h_fig = figure;
% h_axes = axes('Parent', h_fig);
% [n iv] = hist(discr,150);
% diff_n = n(2:end)-n(1:end-1);
% mean_iv = mean([iv(2:end);iv(1:end-1)],1);
% plot(h_axes, iv, n, '+k', mean_iv, diff_n, '-r');
% xlim(h_axes, [iv(1) iv(end)]);


function [n_smpl sgn_lvl ana_type correl tol Kmax] = getParam(param)

if size(param,2) >= 1
    n_smpl = param{1};
else
    n_smpl = 50;
end
if size(param,2) >= 2
    sgn_lvl = param{2};
else
    sgn_lvl = 90;
end
if size(param,2) >= 3 && sum(double(param{3} == [1 2]))
    ana_type = param{3};
else
    ana_type = 2;
end
if size(param,2) >= 4
    Kmax = param{4};
else
   Kmax=10;
end
if size(param,2) >= 5
    correl = 1;
    tol = param{5};
else
    correl = 0;
    tol = 0;
end


function cp = cpa_bs_ana(trace, n_smpl, sgn_lvl, ana_type)
%% bootstraping

% reference
N = numel(trace);
ave = mean(trace); % mean
cs_ref = cumsum(trace)-ave*(1:N)'; % cumulative sum

% estimator of the reference magnitude of changes
cs_max = max(cs_ref);
cs_min = min(cs_ref);
diff_ref = cs_max-cs_min;


% bootstrap samples
for s = 1:n_smpl

    % sampling without replacement
    rand_n = randi([1 N],[1 N]);
    [o,n] = sort(rand_n, 'descend');
    sample = trace(n,:);

    ave = mean(sample); % mean
    cs = cumsum(sample)-ave*(1:N)'; % cumulative sum

    % estimator of the magnitude of the change
    cs_max = max(cs);
    cs_min = min(cs);
    diff_smpl(s) = cs_max-cs_min;
end



%% selection of significant changing points
n_inf = numel(find(diff_smpl < diff_ref));
conf_lvl = 100*(n_inf/n_smpl);

cp = [];
if size(trace,1) > 1 && conf_lvl >= sgn_lvl
    switch ana_type
        case 'max'
            [o,p] = max(abs(cs_ref));
            
        case 'mse'
            p = mse_ana(trace);
    end

    cp_inf = cpa_bs_ana(trace(1:p), n_smpl, sgn_lvl, ana_type);
    cp_sup = cpa_bs_ana(trace(p+1:end), n_smpl, sgn_lvl, ana_type);
    cp = [cp_inf p (cp_sup+p)];
end



function p = mse_ana(trace)
mse = [];
for i = 1:numel(trace)-1
    mean_a = mean(trace(1:i));
    mean_b = mean(trace(i+1:numel(trace)));
    mse(i) = sum((trace(1:i)-mean_a).^2) + ...
        sum((trace(i+1:numel(trace))-mean_b).^2);
end
[o,p] = min(mse);


