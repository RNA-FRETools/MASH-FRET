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
meth_mdl = curr.mdl_start(1);
T = curr.mdl_start(2);
D = curr.mdl_start(3);

% bin states
nTrs = getClusterNb(J,mat,clstDiag);
[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
[states,~] = binStateValues(mu,bin,[j1,j2]);
V = numel(states);

% check for state lifetimes
set([h.text_TA_mdlComplexity,h.popupmenu_TA_mdlMeth,...
    h.pushbutton_TA_refreshModel,h.edit_TA_mdlRestartNb,...
    h.text_TA_mdlRestartNb],'enable','on');
set(h.edit_TA_mdlRestartNb,'string',num2str(T));
if meth_mdl==1
    set([h.text_TA_mdlJmax,h.edit_TA_mdlJmax],'enable','on');
    set(h.edit_TA_mdlJmax,'string',num2str(D));
end

if ~(isfield(prm,'mdl_res') && size(prm.mdl_res,2)>=5 && ...
        ~isempty(prm.mdl_res{3})) % no probability infered yet
    return
end
if ~isempty(prm.mdl_res{3})
    set(h.popupmenu_TA_mdlDtState,'Enable','on');
    if get(h.popupmenu_TA_mdlDtState,'Value')>V
        set(h.popupmenu_TA_mdlDtState,'Value',V);
    end
    str_pop = cell(1,V);
    for v = 1:V
        str_pop{v} = sprintf('%0.2f',states(v));
    end
    set(h.popupmenu_TA_mdlDtState,'String',str_pop);
end


