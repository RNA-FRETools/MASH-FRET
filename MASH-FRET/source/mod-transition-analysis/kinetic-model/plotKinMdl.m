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
    BICres = prm.mdl_res{6};
end

% draw state diagram
if isempty(states)
    for ax = 1:numel(h_axes)
        h_axes(ax).Visible = 'off';
    end
    return
end
if isempty(simdat)
    drawDiagram(h_axes(1),states,tp,[],[]);
else
    % calculate exp. state rel. pop
    J = numel(states);
    pop = zeros(1,J);
    dtSum = sum(simdat.dt(:,1));
    for j = 1:J
        pop(j) = sum(simdat.dt(simdat.dt(:,3)==j,1))/dtSum;
    end
    drawDiagram(h_axes(1),states,tp,simdat.tpmin,pop);
end


% plot BIC results
if ~isempty(BICres)
    h_axes(5).Visible = 'on';
    nCmb = size(BICres,1);
    BIC = BICres(:,end)';
    incl = ~isinf(BIC);
    BIC = BIC(incl);
    cmbs = 1:nCmb;
    cmbs = cmbs(incl);
    scatter(h_axes(5),cmbs,BIC,'+');

    cmb = BICres(:,1:end-1);
    cmb = cmb(incl,:);
    [BICmin,cmbopt] = min(BIC);
    h_axes(5).NextPlot = 'add';
    scatter(h_axes(5),cmbs(cmbopt),BIC(cmbopt),'+','linewidth',2);
    h_axes(5).NextPlot = 'replacechildren';
    cmblow = cmbopt-3;
    if cmblow<1
        cmblow = 1;
    end
    nCmb = numel(cmbs);
    cmbup = cmbopt+6-(cmbopt-cmblow);
    if cmbup>nCmb
        cmbup = nCmb;
    end
    BICmax = max(BIC(cmblow:cmbup));
    if BICmin==BICmax
        ylim(h_axes(5),BICmin+[-1,1]);
    else
        ylim(h_axes(5),[BICmin,BICmax]);
    end
    h_axes(5).XTick = 1:nCmb;
    xlbl = compose(repmat('%i',1,size(cmb,2)),cmb)';
    h_axes(5).XTickLabel = xlbl(1:nCmb);
    h_axes(5).XLim = [cmblow-0.5,cmbup+0.5];
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

