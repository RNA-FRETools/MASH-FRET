function thresh_ana(h_fig)

h = guidata(h_fig);
p = h.param.thm;
proj = p.curr_proj;
tpe = p.curr_tpe(proj);
prm_start = p.proj{proj}.prm{tpe}.thm_start;
prm_plot = p.proj{proj}.prm{tpe}.plot;
ovrfl = prm_plot{1}(1,4);
boba = prm_start{1}(2);
nRpl = prm_start{1}(3);
nSpl = prm_start{1}(4);
w = prm_start{1}(5);
thrsh = [-Inf prm_start{2}' Inf];
K = numel(prm_start{2})+1;
N = sum(p.proj{proj}.coord_incl);

% randomly select histograms, exponential/Gaussian fitting
err = loading_bar('init', h_fig, nSpl, ['Performing randomisation and ' ...
    'thresholding ...']);
if err
    return;
end

if boba
    setContPan(cat(2,'Bootstrap (',num2str(nRpl),' replicates, ',...
        num2str(nSpl),' samples) histograms and calculate state relative ',...
        'populations with ',num2str(K-1),' thresholds ...'),'process',...
        h_fig);
else
    setContPan(cat(2,'Calculate state relative populations with ',...
        num2str(K-1),' thresholds ...'),'process',h_fig);
end

h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

if ~boba
    nSpl = 1;
end

pop = zeros(nSpl,K);
P_bs = [];

for s = 1:nSpl
    % update loading bar
    err = loading_bar('update', h_fig);
    if err
        return;
    end
    if boba
        mols = randsample(N, nRpl, true, ones(N,1))';
    else
        mols = 'all';
    end
    P_s = getHist(mols, w, ovrfl, h_fig);
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
end

p.proj{proj}.prm{tpe}.thm_res{1,1} = res;
p.proj{proj}.prm{tpe}.thm_res{1,2} = pop;
p.proj{proj}.prm{tpe}.thm_res{1,3} = P_bs;
h.param.thm = p;
guidata(h_fig,h);

loading_bar('close', h_fig);

setContPan('State relative populations successfully calculated.','success',...
    h_fig);


