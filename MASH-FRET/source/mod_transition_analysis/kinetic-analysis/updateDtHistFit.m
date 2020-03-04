function p = updateDtHistFit(p,tag,tpe,curr_k,excl,h_fig)

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

prm.kin_start{1}{curr_k,1}(8) = excl;

% collect state indexes for curent transitions
[j1,j2] = getStatesFromTransIndexes(curr_k,J,mat,clstDiag);

% re-arrange state sequences by cancelling transitions belonging to diagonal clusters
rearr = prm.kin_start{1}{curr_k,1}(9);
if rearr
    [mols,o,o] = unique(dat(:,4));
    dat_new = [];
    for m = mols'
        dat_m = dat(dat(:,4)==m,:);
        if isempty(dat_m)
            continue
        end
        dat_m = adjustDt(dat_m);
        if size(dat_m,1)==1
            continue
        end
        dat_new = cat(1,dat_new,dat_m);
    end
    dat = dat_new;
end

% get reference histogram
wght = prm.kin_start{1}{curr_k,1}(7);
ref_k = getDtHist(dat, [j1,j2], [], excl, wght);
prm.clst_res{4}{curr_k} = ref_k;

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
