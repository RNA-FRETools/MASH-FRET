function ud_kinMdl(h_fig)
% Set properties of all controls in panel "Kinetic model" to proper values.
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

% collect processing parameters
curr = p.proj{proj}.curr{tag,tpe};
prm = p.proj{proj}.prm{tag,tpe};

% set all control enabled
setProp(h.uipanel_TA_kineticModel, 'Enable', 'off');

if ~(isfield(curr,'clst_res') && ~isempty(curr.clst_res{1}))
    return
end

J = prm.lft_start{2}(1);
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);
mu = prm.clst_res{1}.mu{J};
bin = prm.lft_start{2}(3);

% bin states
nTrs = getClusterNb(J,mat,clstDiag);
[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
[states,~] = binStateValues(mu,bin,[j1,j2]);
V = numel(states);

% check for state lifetimes
if isfield(prm,'lft_res') && ~isempty(prm.lft_res) && ...
        size(prm.lft_res,1)>=V && size(prm.lft_res,2)>=2
    for v = 1:V
        boba = prm.lft_start{1}{v,1}(5);
        if ~((boba && size(prm.lft_res{v,1},2)>=4) || ...
                (~boba && size(prm.lft_res{v,2},2)>=2))
            return
        end
    end
else
    return
end

set(h.pushbutton_TA_refreshModel,'enable','on');

if ~(isfield(prm,'mdl_res') && size(prm.mdl_res,2)>=4 && ...
        ~isempty(prm.mdl_res{4}))
    return
end


