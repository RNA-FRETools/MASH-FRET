function plotKinMdl(h_axes,prm,def,v_res)

% defaults
norm = 1;

% clear axes
for ax = 1:numel(h_axes)
    cla(h_axes(ax));
end
if ~isempty(h_axes(1).UserData)
    delete(h_axes(1).UserData);
end

% collect results
if ~(isfield(prm,'mdl_res') && ~isequal(prm.mdl_res,def.mdl_res))
    states = [];
else
    tp = prm.mdl_res{1};
    simdat = prm.mdl_res{4};
    states = prm.mdl_res{5};
    if ~isempty(prm.mdl_res{6})
        BICres = prm.mdl_res{6}{1};
    else
        BICres = [];
    end
end

% control states
if isempty(states)
    for ax = 1:numel(h_axes)
        h_axes(ax).Visible = 'off';
    end
    return
end

% draw state diagram
h_axes(1).Visible = 'on';
if isempty(simdat)
    drawDiagram(h_axes(1),states,[],[],[]);
else
    % calculate exp. state rel. pop
    J = numel(states);
    pop0 = zeros(1,J);
    dtSum = sum(simdat.dt(:,1));
    for j = 1:J
        pop0(j) = sum(simdat.dt(simdat.dt(:,3)==j,1))/dtSum;
    end
    ntrs0 = zeros(J);
    for j1 = 1:J
        for j2 = 1:J
            if j1==j2
                continue
            end
            ntrs0(j1,j2) = sum(simdat.dt(:,3)==j1 & simdat.dt(:,4)==j2);
        end
    end
    ntrs0(tp<simdat.tpmin) = 0;
    
    % order states by value and lifetime
    stateval = sort(unique(states));
    tp = prm.mdl_res{1};
    V = numel(stateval);
    id_j = 1:J;
    lt = 1/(1-tp(~~eye(J)));
    for v = 1:V
        j_v = find(states==stateval(v));
        D_v = numel(j_v);
        lt_v = zeros(1,D_v);
        for d = 1:D_v
            lt_v(d) = 1/(1-tp(j_v(d),j_v(d)));
        end
        [~,id_v] = sort(lt_v);
        id_j(j_v) = j_v(id_v);
        lt(j_v) = lt_v(id_v);
    end
    pop = pop0(id_j);
    ntrs = zeros(J);
    for j1 = 1:J
        for j2 = 1:J
            ntrs(j1,j2) = ntrs0(id_j(j1),id_j(j2));
        end
    end
    
    drawDiagram(h_axes(1),states,ntrs,pop,lt);
end


% plot BIC results
if ~isempty(BICres)
    h_axes(5).Visible = 'on';
    nCmb = size(BICres,1);
    BIC = BICres(:,end)';
    cmbs = 1:nCmb;
    scatter(h_axes(5),cmbs,BIC,'+');

    [BICmin,cmbopt] = min(BIC);
    h_axes(5).NextPlot = 'add';
    scatter(h_axes(5),cmbs(cmbopt),BIC(cmbopt),'+','linewidth',2);
    h_axes(5).NextPlot = 'replacechildren';
    
    BICmax = max(BIC(~isinf(BIC)));
    if BICmin==BICmax
        ylim(h_axes(5),BICmin+[-1,1]);
    else
        ylim(h_axes(5),[BICmin,BICmax]);
    end

    h_axes(5).XTick = cmbs;
    cmb = BICres(:,1:end-1);
    xlbl = compose(repmat('%i',1,size(cmb,2)),cmb)';
    h_axes(5).XTickLabel = xlbl(1:nCmb);
    h_axes(5).XLim = [0,nCmb+1];
else
    h_axes(5).Visible = 'off';
end

% plot experimental vs simulation
if isempty(simdat)
    for ax = 2:4
        h_axes(ax).Visible = 'off';
    end
    return
else
    for ax = 2:4
        h_axes(ax).Visible = 'on';
    end
end

% plot state value populations
vals = unique(states);
V = numel(vals);
bar(h_axes(2),1:V,[simdat.pop(1,:)',simdat.pop(2,:)']);
h_axes(2).XLim = [0.5,V+0.5];
h_axes(2).XTick = 1:V;
xtklbl = cell(1,V);
for v = 1:V
    xtklbl{v} = sprintf('%0.2f',vals(v));
end
h_axes(2).XTickLabel = xtklbl;
ylim(h_axes(2),'auto');
legend(h_axes(2),'exp','sim','location','northoutside');

% plot number of transitions
bar(h_axes(3),1:V*(V-1),[simdat.ntrs(1,:)',simdat.ntrs(2,:)']);
h_axes(3).XLim = [0.5,V*(V-1)+0.5];
h_axes(3).XTick = 1:V*(V-1);
xtklbl = cell(1,V*(V-1));
v = 0;
for v1 = 1:V
    for v2 = 1:V
        if v1==v2
            continue
        end
        v = v+1;
        xtklbl{v} = sprintf('%0.2f\\newline%0.2f',vals(v1),vals(v2));
    end
end
h_axes(3).XTickLabel = xtklbl;
ylim(h_axes(3),'auto');
legend(h_axes(3),'exp','sim','location','northoutside');

% plot dwell time histograms
t = simdat.cumdstrb{v_res}(1,:);
cumPexp = simdat.cumdstrb{v_res}(2,:);
cumPsim = simdat.cumdstrb{v_res}(3,:);
if norm
    cumPexp = cumPexp/max(cumPexp);
end
if norm
    cumPsim = cumPsim/max(cumPsim);
end
scatter(h_axes(4),t,cumPexp,'+k');
h_axes(4).NextPlot = 'add';
scatter(h_axes(4),t,cumPsim,'+r');
h_axes(4).NextPlot = 'replacechildren';
h_axes(4).XLim = t([1,end]);
if norm
    h_axes(4).YLim = [0,1];
else
    ylim(h_axes(4),'auto');
end
legend(h_axes(4),'exp','sim','location','east');

