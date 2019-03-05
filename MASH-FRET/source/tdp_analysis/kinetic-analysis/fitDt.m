function res = fitDt(dat, j1, j2, excl, hist_ref, p_fit, p_boba, h_fig)

res = [];

strch = size(p_fit.start,2) == 3;
nExp = (size(p_fit.start,2)/(2+strch));

% get dwell times concerning j1->j2 transition only
dat_j1j2 = dat(dat(:,7)==j1 & dat(:,8)==j2,1:end-2);

mols = unique(dat_j1j2(:,4));
N = numel(mols);

boba = ~isempty(p_boba);
if boba
    n_rpl = p_boba(1);
    n_spl = p_boba(2);
    wght = p_boba(3);
    rspl = true;
end

dt = {};
w_vect = [];
mol_incl = [];
for n = 1:N
    dt_m = dat(dat(:,4)==mols(n),:);
    
    % exclude molecules without dwell times concerning j1->j2 transition
    if isempty(dt_m)
        disp(cat(2,'molecule ',num2str(mols(n)),' excluded: no dwell time'));
        continue;
    end
    
    if excl && isempty(dt_m(2:end-1,:))
        disp(cat(2,'molecule ',num2str(mols(n)),' excluded: no dwell time',...
            ' left after exclusion.'));
        continue;
        
    elseif excl
        dt_m = dt_m(2:end-1,:);
    end

    dt_m_j1j2 = dt_m(dt_m(:,7)==j1 & dt_m(:,8)==j2,:);
    dt = cat(2,dt,dt_m_j1j2);
    mol_incl = cat(2,mol_incl,mols(n));
    
    if boba && wght
        w_vect = cat(1,w_vect,sum(dt{end}(:,1)));
        
        if n == N
            w_vect = w_vect/sum(w_vect);
        end
    end
end

if size(dt,2)==0
    setContPan(cat(2,'No dwell time is left after excluding first last ',...
        'occurrence in each trajectory.'),'error',h_fig);
    return;
end

disp(sprintf(cat(2,'molecules ',repmat('%i ',[1,numel(mol_incl)]),...
    ' included in data to fit.'),mol_incl));

if boba && ~wght
    w_vect = ones(size(dt,2),1);
end

if boba
    boba_res = BOBA_ana(dt, p_fit, strch, nExp, rspl, n_rpl, n_spl, ...
        w_vect, h_fig);
    if isempty(boba_res)
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
    setContPan('Fitting process interrupted', 'error', h.figure_MASH);
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


