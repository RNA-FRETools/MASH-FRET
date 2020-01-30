function plotTDP(hndls, curr, prm)
% Plot transition density plot and clusters
% plotTDP(hndls, prm)
%
% hndls: [1-by-2] vector containing axes and colorbar handles
% prm: last applied processing parameters or current settings
% h_fig: handle to main figure

% Last update by MH, 26.1.2020: adapt to current and last applied parameters
% update by MH, 12.12.2019: give the colorbar's handle in plotTDP's input to prevent dependency on MASH main figure's handle and allow external use.
% update by MH, 29.11.2019: remove systemic axes clearance to keep original properties (font size, color bar etc..)
% update by MH, 18.3.2019: update help section

% default
slcttool = 1;
rectlw = 2;
rectclr = [1,1,1];
diagclr = [0.5 0.5 0.5];
diagstyle = '--';
trsmark = '+';
trsmarksz = 5;
trslw = 1;
mumark = '+';
mumarksz = 13;
mulw = 2;
gmstyle = '-w';
xlbl = 'Value before transition';
ylbl = 'Value after transition';
clbl = {'normalized occurrence','occurrence'};

% collect processing parameters
bin = prm.plot{1}(1,1);
lim = prm.plot{1}(1,2:3);
gconv = curr.plot{1}(3,2);
norm = curr.plot{1}(3,3);
TDP = prm.plot{2};

% get haxes handles
h_axes_TDP = hndls(1);
h_cb_TDP = hndls(2);
h_axes_BIC = hndls(3);

% clear axes
cla(h_axes_TDP);
cla(h_axes_BIC);
set(h_axes_BIC,'visible','off');

if isempty(TDP) || (numel(TDP)==1 && isnan(TDP))
    return
end

if isfield(prm,'clst_res') && ~isempty(prm.clst_res{1})
    isRes = true;
    clr = prm.clst_start{3};
else
    isRes = false;
    clr = curr.clst_start{3};
end

% get cluster centers and dimensions
val = [];
a = [];
sig = [];
clust = [];
rad = [];
if isRes
    meth = prm.clst_start{1}(1);
    mat = prm.clst_start{1}(4);
    clstDiag = prm.clst_start{1}(9);
    if meth == 2 % GM
        
        % adjust index of model to display
        J = curr.clst_res{3};

        val = prm.clst_res{1}.mu{J};
        clust = prm.clst_res{1}.clusters{J};
        a = prm.clst_res{1}.a{J};
        sig = prm.clst_res{1}.o{J};

        % plot BIC results
        Jmax = size(prm.clst_res{1}.BIC,2);
        BICs = prm.clst_res{1}.BIC;
        set(h_axes_BIC,'visible','on');
        barh(h_axes_BIC,1:Jmax,BICs);
        xlim(h_axes_BIC,[min(BICs) mean(BICs)]);
        ylim(h_axes_BIC,[0,Jmax+1]);
        title(h_axes_BIC,'BIC');
        
    else
        J = curr.clst_res{3};
        val = prm.clst_res{1}.mu{J};
        rad = prm.clst_start{2}(:,[3,4]);
        clust = prm.clst_res{1}.clusters{J};
        slcttool = prm.clst_start{1}(2);
    end
else
    J = curr.clst_start{1}(3);
    meth = curr.clst_start{1}(1);
    mat = curr.clst_start{1}(4);
    clstDiag = curr.clst_start{1}(9);
    if sum(meth==[1,3]) % kmean or manual
        val = curr.clst_start{2}(:,[1,2]);
        rad = curr.clst_start{2}(:,[3,4]);
        slcttool = curr.clst_start{1}(2);
    end
end
if isempty(rad)
    rad = Inf(size(val));
end
rad(isinf(rad)) = 2*(lim(2)-lim(1));

% TDP convolution with Gaussian filter
if gconv
    TDP = gconvTDP(TDP,lim,bin);
end

% normalise transition densities
if norm
    try
        if sum(sum(TDP))>0
            TDP = TDP/sum(sum(TDP));
        end
    catch err % out of memory
        disp(cat(2,'Impossible to normalize TDP: ',err.message,...
            '\nIncreasing TDP binning might be a solution.'));
    end
end

% draw TDP image
imagesc(lim,lim,TDP,'Parent',h_axes_TDP,'HitTest','off',...
    'PickableParts','none');
if sum(sum(TDP))
    set(h_axes_TDP,'CLim',[min(min(TDP)) max(max(TDP))]);
else
    set(h_axes_TDP,'CLim',[0 1]);
end

% plot y = x diagonal
set(h_axes_TDP,'NextPlot','add');
plot(h_axes_TDP,lim,lim,'LineStyle',diagstyle,'Color',diagclr);

% plot clustered data with resp. colour code
nTrs = getClusterNb(J,mat,clstDiag);
[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);

if size(val,1)>0
    % plot transitions
    if ~isempty(clust)
        for k = 1:nTrs
            clust_k = clust((clust(:,7)==j1(k) & clust(:,8)==j2(k)),:);
            if isempty(clust_k)
                continue
            end
            plot(h_axes_TDP,clust_k(:,2),clust_k(:,3),'Marker',trsmark, ...
                'MarkerEdgeColor',clr(k,:),'MarkerSize',trsmarksz, ...
                'LineWidth',trslw,'LineStyle','none');
        end
    end
    
    % plot cluster centers
    for k = 1:nTrs
        plot(h_axes_TDP,val(k,1),val(k,2),'Marker',mumark,...
            'MarkerEdgeColor',clr(k,:),'MarkerSize',mumarksz,'LineWidth', ...
            mulw,'hittest','off','pickableparts','none');
    end
    
    % plot cluster contours
    switch slcttool
        case 1
            for k = 1:nTrs
                rectangle(h_axes_TDP,'position',[val(k,1:2)-rad(k,1:2),...
                    2*rad(k,1:2)],'linewidth',rectlw,'edgecolor',rectclr);
            end
        case 2
            plotEllipsis(h_axes_TDP, val(:,1:2), rad(:,1:2), 0, rectclr, ...
                rectlw);
        case 3
            if mat
                id_inf = val(:,1)<=val(:,2);
                id_sup = val(:,1)>val(:,2);
                plotEllipsis(h_axes_TDP, val(id_inf',1:2), rad(id_inf',[1,2]),...
                    -pi/4, rectclr, rectlw);
                plotEllipsis(h_axes_TDP, val(id_sup',1:2), rad(id_sup',[2,1]),...
                    -pi/4, rectclr, rectlw);
            else
                plotEllipsis(h_axes_TDP,val(:,1:2),rad(:,1:2),-pi/4,...
                    rectclr,rectlw);
            end
    end
    if ~isempty(a) && ~isempty(sig)
        iv = lim(1):bin:lim(2);
        iv = mean([iv(1:end-1);iv(2:end)],1);
        plotEllipsisFromGM(h_axes_TDP,val,sig,a,iv,iv,[],gmstyle);
    end
end

% adjust axis grid, limits and labels
grid(h_axes_TDP, 'on');
xlabel(h_axes_TDP, xlbl);
ylabel(h_axes_TDP, ylbl);
set(h_axes_TDP, 'XAxisLocation', 'top', 'YAxisLocation', 'right', 'XLim', ...
    lim(1,:), 'YLim', lim(1,:), 'YDir', 'normal', 'NextPlot', ...
    'replacechildren');

if norm
    ylabel(h_cb_TDP, clbl{1});
else
    ylabel(h_cb_TDP, clbl{2});
end

set([h_axes_TDP h_cb_TDP],'visible','on');

