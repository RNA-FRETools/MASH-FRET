function thresh_ana(h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);

molTag = p.proj{proj}.molTag;
m_incl = p.proj{proj}.coord_incl;
def = p.proj{proj}.HA.def{tag,tpe};
curr = p.proj{proj}.HA.curr{tag,tpe};
prm = p.proj{proj}.HA.prm{tag,tpe};

prm.thm_start([1,2]) = curr.thm_start([1,2]);
prm.thm_res(1,:) = def.thm_res(1,:);

prm_start = prm.thm_start;
prm_plot = prm.plot;
ovrfl = prm_plot{1}(1,4);
boba = prm_start{1}(2);
nRpl = prm_start{1}(3);
nSpl = prm_start{1}(4);
w = prm_start{1}(5);
thrsh = [-Inf prm_start{2}' Inf];
K = numel(prm_start{2})+1;

if boba
    % randomly select histograms, exponential/Gaussian fitting
    err = loading_bar('init', h_fig, nSpl, ['Performing randomisation and ' ...
        'thresholding ...']);
    if err
        return;
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    setContPan(cat(2,'Bootstrap (',num2str(nRpl),' replicates, ',...
        num2str(nSpl),' samples) histograms and calculate state relative ',...
        'populations with ',num2str(K-1),' thresholds ...'),'process',...
        h_fig);
else
    setContPan(cat(2,'Calculate state relative populations with ',...
        num2str(K-1),' thresholds ...'),'process',h_fig);
end

if ~boba
    nSpl = 1;
end

nMol = size(m_incl,2); % inital number of molecules

if boba
    mols = 1:nMol;
    if tag==1
        mols = mols(m_incl);
    else
        mols = mols(m_incl & molTag(:,tag-1)');
    end
    N = size(mols,2); % number of user-selected molecules
end

pop = zeros(nSpl,K);
P_bs = [];

for s = 1:nSpl

    if boba
        % update loading bar
        err = loading_bar('update', h_fig);
        if err
            return;
        end
        
        % select randomly nSpl single molecule (with replacement)
        m = randsample(mols, nRpl, true, ones(N,1))';
    else
        m = 'all';
    end
    
    P_s = getHist(m, w, ovrfl, h_fig);
    P_s(:,2) = P_s(:,2)/sum(P_s(:,2));

    % with thresholding
    for k = 1:K
        pop(s,k) = sum(P_s((P_s(:,1)>thrsh(k) & P_s(:,1)<=thrsh(k+1)),2));
    end
    P_bs(:,s) = P_s(:,2);
end

res(:,1) = mean(pop,1)';

if boba
    res(:,2) = std(pop,0,1)';
    loading_bar('close', h_fig);
end

prm.thm_res(1,:) = {res, pop, cat(2,P_s(:,1),P_bs)};
curr.thm_res(1,:) = prm.thm_res(1,:);

p.proj{proj}.HA.prm{tag,tpe} = prm;
h.param = p;
guidata(h_fig,h);

setContPan('State relative populations successfully calculated.','success',...
    h_fig);
