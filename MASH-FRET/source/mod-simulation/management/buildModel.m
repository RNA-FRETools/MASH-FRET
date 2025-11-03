function ok = buildModel(h_fig)
% buildModel simulates a set of discretised FRET time course from the
% kinetic rates and the FRET states defined by the user.
%
% Requires external files: setContPan.m

% Last update, 17.3.2020: (1) use pre-defined transition probabilties (wx) (2) use HMM transition probabiltiies to calculate initial state probabilities ((kx*expT).*wx) (3) add possibility to use pre-defined initial state probabilties (p0)
% update by MH, 19.12.2019: (1) fix error occuring when the sum of one of the rows/columns in the rate matrix is null (2) return execution success/failure in "ok"
% update by MH, 17.12.2019: remove dependency on updateMov.m (called from the pushbutton callback function)
% update by RB, 6.3.2018: review initial state probabilities

% defaults
Lmin = 5; % minimum trace length

% initialize execution failure/success
ok = 0;

% display action
setContPan(cat(2,'Generate random state sequences...'),'process',h_fig);

% retrieve project content
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
prm = p.proj{proj}.sim.prm;
curr = p.proj{proj}.sim.curr;
def = p.proj{proj}.sim.def;

% apply current parameter set to project
prm.gen_dt = curr.gen_dt;

% collect simulation parameters
N = prm.gen_dt{1}(1);
L = prm.gen_dt{1}(2);
J = prm.gen_dt{1}(3);
isblch = prm.gen_dt{1}(5);
blch_cst = prm.gen_dt{1}(6);
kx = prm.gen_dt{2}(:,:,1);
% wx = prm.gen_dt{2}(:,:,2);
isPresets = prm.gen_dt{3}{1};
presets = prm.gen_dt{3}{2};

% get proper transition rate constants
kx_all = [];
if isPresets && isfield(presets, 'kx') % transition rate coefficients from presets
    kx_all = presets.kx;
elseif ~(isPresets && isfield(presets, 'wx')) % transition rate coefficients from interface
    kx_all  = repmat(kx,[1,1,N]);
end

% get proper transition partition factors and state lifetimes
if isempty(kx_all) % from presets
    wx_all = presets.wx./sum(presets.wx,2);
    wx_all(isnan(wx_all)) = 0;
    tau_all = presets.tau; % [J-by-N]
    for n = 1:N
        k_n = wx_all(:,:,n).*repmat(1./(tau_all(:,n)),[1,J]);
        kx_all = cat(3,kx_all,k_n);
    end
else % from transition rates
    kx_all = kx_all(1:J,1:J,:);
    for n = 1:N
        k_n = kx_all(:,:,n);
        k_n(~~eye(J)) = 0;
        kx_all(:,:,n) = k_n;
    end
    wx_all =  kx_all./repmat(sum(kx_all,2),[1,J]);
    wx_all(isnan(wx_all)) = 0;
    tau_all = 1./permute(sum(kx_all,2),[1,3,2]); % [J-by-N]
end

% get proper starting probabilities
if isPresets && isfield(presets, 'p0') % initial state prob. from presets
    ip_all = presets.p0;
% else % initial prob. calculated from state lifetimes
%     ip_all = tau_all./repmat(sum(tau_all,1),[J,1,1]); % [J-by-N]
%     ip_all = ip_all';
else % initial prob. calculated from transition matrix eigenvectors
    ip_all = [];
    for n = 1:N
        tp_n = kx_all(:,:,n);
        tp_n(~~eye(J)) = 1-sum(tp_n,2);
        [V,D] = eig(tp_n');
        idx = find(abs(diag(D) - 1) < 1e-10,1);
        ip_n = V(:,idx)'; 
        ip_n = ip_n/sum(ip_n); 
        ip_all = cat(1,ip_all,ip_n); % [N-by-J]
    end
end

% initializes results
mix = repmat(-1,[J,L,N]);
discr_seq = repmat(-1,[L,N]);
dt_final = cell(1,N);
for n = 1:N
    if isblch
        Ln = ceil(random('exp',blch_cst));
        if Ln > L
            Ln = L;
        end
        if Ln<Lmin
            Ln = Lmin;
        end
    else
        Ln = L;
    end
    w = wx_all(:,:,n);
    ip = ip_all(n,:);
    tau = tau_all(:,n)';
    k = kx_all(:,:,n);

    [mixn,seqn,dtn] = genstateseq(Ln,k,J,w,ip,tau);
    if isempty(mixn)
        % clear any results to avoid conflict
        if isfield(h,'results') && isfield(h.results,'sim')
            h.results = rmfield(h.results,'sim');
        end
        guidata(h_fig,h);
        return
    end

    mix(:,1:Ln,n) = mixn;
    discr_seq(1:Ln,n) = seqn;
    dt_final{n} = dtn;
end

% save results in project parameters
prm.res_dt{1} = mix;
prm.res_dt{2} = discr_seq;
prm.res_dt{3} = dt_final;
curr.res_dt = prm.res_dt;

% reset following results
prm.res_dat = def.res_dat;
curr.res_dat = prm.res_dat;

% save modifications
p.proj{proj}.sim.curr = curr;
p.proj{proj}.sim.prm = prm;
h.param = p;
guidata(h_fig,h);

% return execution success
ok = 1;



