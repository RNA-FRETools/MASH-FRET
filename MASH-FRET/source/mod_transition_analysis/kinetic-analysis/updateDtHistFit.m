function p = updateDtHistFit(p,tag,tpe,curr_k,h_fig)

% collect interface parameters
proj = p.curr_proj;

% collect prcoessing parameters
prm = p.proj{proj}.prm{tag,tpe};
curr = p.proj{proj}.curr{tag,tpe};

% make current settings the last applied settings
prm.kin_start = curr.kin_start;
prm.kin_res = curr.kin_res;

J = prm.kin_start{2}(1);
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);
ref_k = prm.clst_res{4}{curr_k};
dat = prm.clst_res{1}.clusters{J};
kin_k = prm.kin_start{1}(curr_k,:);
stchExp = kin_k{1}(1);

% reset results
prm.kin_res(curr_k,:) = p.proj{proj}.def{tag,tpe}.kin_res;

% get fit settings
if stchExp
    % amp, dec, beta
    p_fit.lower = kin_k{2}(1,[1 4 7]);
    p_fit.start = kin_k{2}(1,[2 5 8]);
    p_fit.upper = kin_k{2}(1,[3 6 9]);
else
    % amp1, dec1, amp2, dec2 ...
    p_fit.lower = reshape(kin_k{2}(:,[1 4])', [1 ...
        numel(kin_k{2}(:,[1 4]))]);
    p_fit.start = reshape(kin_k{2}(:,[2 5])', [1 ...
        numel(kin_k{2}(:,[2 5]))]);
    p_fit.upper = reshape(kin_k{2}(:,[3 6])', [1 ...
        numel(kin_k{2}(:,[3 6]))]);
end

% get bootstrap settings
boba = kin_k{1}(4);
p_boba = [];
if boba
    p_boba = kin_k{1}([5 6 7]);
end

% ask user about dwell time exclusion
excl = questdlg({sprintf(cat(2,'The first and last dwell times of state ',...
    'trajectories are truncated due to the limited observation time ',...
    'window and often lead to biased results.\n\nDo you want to exclude ',...
    'the trucated dwell-times from the fit?'))},...
    'Exclude flanking dwell-times?','Exclude','Include','Cancel',...
    'Exclude');
if strcmp(excl, 'Exclude')
    excl = 1;
elseif strcmp(excl, 'Include')
    excl = 0;
else
    return
end
prm.kin_start{1}{curr_k,1}(8) = excl;

% collect state indexes for curent transitions
[j1,j2] = getStatesFromTransIndexes(curr_k,J,mat,clstDiag);

% histogram fitting
setContPan('Fitting in progress ...', 'process', h_fig);
res = fitDt(dat, j1, j2, excl, ref_k, p_fit, p_boba, h_fig);
if isempty(res)
    return
end

if boba
    % update number of replicates
    prm.kin_start{1}{curr_k,1}(5) = res.n_rep;
    prm.kin_res{curr_k,1} = res.boba_mean;
    prm.kin_res{curr_k,3} = res.boba_inf;
    prm.kin_res{curr_k,4} = res.boba_sup;
end

prm.kin_res{curr_k,2} = res.fit_ref;

% update modifications of processing parameters to current settings
curr.kin_start = prm.kin_start;
curr.kin_res = prm.kin_res;

% save modifications
p.proj{proj}.prm{tag,tpe} = prm;
p.proj{proj}.curr{tag,tpe} = curr;
