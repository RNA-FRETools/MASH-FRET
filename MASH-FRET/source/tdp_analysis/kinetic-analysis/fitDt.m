function res = fitDt(dat, excl, hist_ref, p_fit, p_boba, h_fig)

strch = size(p_fit.start,2) == 3;
nExp = (size(p_fit.start,2)/(2+strch));
mols = unique(dat(:,end));
nMol = numel(mols);

boba = ~isempty(p_boba);
if boba
    n_rpl = p_boba(1);
    n_spl = p_boba(2);
    wght = p_boba(3);
    rspl = true;
end

dt = {};
m = 0;
excl_mol = [];
for im = 1:nMol
    DT = dat(dat(:,end)==mols(im),1);
    if isempty(DT)
        excl_mol = [excl_mol im];
        continue;
    end

    if excl && isempty(DT(2:end-1,:))
        excl_mol = [excl_mol im];
        continue;
    elseif excl
        m = m+1;
        dt{m} = DT(2:end-1,:);
    else
        m = m+1;
        dt{m} = DT;
    end
    if boba && wght
        w_vect(m,1) = sum(dt{m}(:,1));
        if im == nMol
            w_vect = w_vect/sum(w_vect);
        end
    end
end

w_vect = ones(m,1);

if boba
    boba_res = BOBA_ana(dt, p_fit, strch, nExp, rspl, n_rpl, n_spl, ...
        w_vect, h_fig);
    if isempty(boba_res)
        res = [];
        return;
    end
    
    boba_mean = mean(boba_res.cf,1);
    boba_std = std(boba_res.cf,0,1);
end

% fit reference histogram
% kinetic analysis
x_data = hist_ref(:,1);
y_data = hist_ref(:,end);
ref_res = mmexpfit_mod(x_data, y_data, p_fit, nExp, strch);
if isempty(ref_res)
    res = [];
    return;
end

if ~strch
    cf_ref = reshape(ref_res.cf', [2 nExp])'; % amplitudes, decay constants
else
    cf_ref = ref_res.cf; % amplitudes, decay constants, beta
end
res.fit_ref = cf_ref;

if boba
    cf_boba = reshape([boba_mean;boba_std], ...
        [1 numel([boba_mean;boba_std])]);
    % 6 parameters (beta,amp,decay) OR 4 (amp,decay)
    cf_boba = reshape(cf_boba',[2*(2+strch) nExp])';
    if strch
        % sort according to beta
        cf = flipud(sortrows(boba_res.cf,3));
    else
        % sort according to 1st time decay
        cf = sortrows(boba_res.cf,2);
    end

    res.n_rep = boba_res.n_rep;
    res.boba_mean = cf_boba;
    res.boba_inf = reshape(cf(1,:)',[(2+strch) nExp])';
    res.boba_sup = reshape(cf(end,:)',[(2+strch) nExp])';
else
    res.n_rep = [];
    res.boba_mean = [];
    res.boba_inf = [];
    res.boba_sup = [];
end


