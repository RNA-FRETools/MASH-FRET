function ud_TDPplot(h_fig)

h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
tpe = p.curr_type(proj);
prm = p.proj{proj}.prm{tpe};

x_bin = prm.plot{1}(1,1);
x_lim = prm.plot{1}(1,2:3);
y_bin = prm.plot{1}(2,1);
y_lim = prm.plot{1}(2,2:3);
gconv = prm.plot{1}(3,2);
norm = prm.plot{1}(3,3);
onecount = prm.plot{1}(4,1);
TDP = prm.plot{2};
meth = prm.clst_start{1}(1);

%% set fields to parameter values
setProp(get(h.uipanel_TDPplot, 'Children'), 'Enable', 'on');

set([h.edit_TDPxBin h.edit_TDPxLow h.edit_TDPxUp h.edit_TDPyBin ...
    h.edit_TDPyLow h.edit_TDPyUp], 'BackgroundColor', [1 1 1]);

set(h.edit_TDPxBin, 'String', num2str(x_bin));
set(h.edit_TDPyBin, 'String', num2str(y_bin));
set(h.edit_TDPxLow, 'String', num2str(x_lim(1)));
set(h.edit_TDPxUp, 'String', num2str(x_lim(2)));
set(h.edit_TDPyLow, 'String', num2str(y_lim(1)));
set(h.edit_TDPyUp, 'String', num2str(y_lim(2)));
set(h.checkbox_TDPgconv, 'Enable', 'on', 'Value', gconv);
set(h.checkbox_TDPnorm, 'Enable', 'on', 'Value', norm);
set(h.checkbox_TDP_onecount, 'Enable', 'on', 'Value', onecount);

%% if not calculated yet, build TDp matrix
if isempty(TDP)
    dt_raw = p.proj{proj}.dt(:,tpe); % {1-by-nMol} transitions
    TDP_prm{1} = [x_bin y_bin]; % TDP x & y binning
    TDP_prm{2} = [x_lim;y_lim]; % TDP x & y limits
    TDP_prm{3} = p.proj{proj}.frame_rate; % rate
    TDP_prm{4} = onecount; % one/total transition count per mol.
    
    % create TDP matrix and get binned transitions + TDP coord. assignment
    [TDP,dt_bin] = getTDPmat(dt_raw, TDP_prm, h_fig);
    if isempty(TDP)
        return;
    end
    
    prm.plot{2} = TDP;
    prm.plot{3} = dt_bin;
    p.proj{proj}.prm{tpe} = prm;
end

%% plot TDP matrix and clusters data
clr = prm.clst_start{3};
mu = [];
a = [];
o = [];
clust = [];

if ~isempty(prm.clst_res{1})
    if meth == 2 % GM
        J = get(h.popupmenu_tdp_model,'Value')+1;
        mu = prm.clst_res{1}.mu{J};
        clust = prm.clst_res{1}.clusters{J};
        a = prm.clst_res{1}.a{J};
        o = prm.clst_res{1}.o{J};
        
        %% plot BIC results
        Jmax = size(prm.clst_res{1}.BIC,2);
        BICs = prm.clst_res{1}.BIC;
        barh(h.axes_tdp_BIC,1:Jmax,BICs);
        xlim(h.axes_tdp_BIC,[min(BICs) mean(BICs)]);
        ylim(h.axes_tdp_BIC,[0,Jmax+1]);
        title(h.axes_tdp_BIC,'BIC');
        
    else
        J = prm.clst_res{3};
        mu = prm.clst_res{1}.mu{J};
        clust = prm.clst_res{1}.clusters{J};
    end
else
    if meth == 1 % kmean
        mu = prm.clst_start{2}(:,1);
    end
end

plot_prm{1} = [x_lim;y_lim]; % TDP x & y limits
plot_prm{2} = [x_bin y_bin]; % TDP x & y binning
plot_prm{3} = gconv; % conv./not TDP with Gaussian, o^2=0.0005
plot_prm{4} = norm; % normalize/not TDP z-axis
plot_prm{5} = clr; % cluster colours

clust_prm{1} = mu; % converged cluster centres (states)
clust_prm{2} = clust; % cluster assigment of TDP coordinates
clust_prm{3}.a = a; % converged Gaussian weights
clust_prm{3}.o = o; % converged Gaussian deviations

plotTDP(h.axes_TDPplot1, TDP, plot_prm, clust_prm, h_fig);

%% adjust colormap
p.cmap = colormap(h.axes_TDPplot1);
set(h.axes_TDPplot1, 'Color', p.cmap(1,:));
setCmap(h_fig, p.cmap);

%% store modifications
h.param.TDP = p;
guidata(h_fig, h);

