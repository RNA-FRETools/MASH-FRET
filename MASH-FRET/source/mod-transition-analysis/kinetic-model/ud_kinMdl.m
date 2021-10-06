function ud_kinMdl(h_fig)
% Set properties of all controls in panel "Kinetic model" to proper values.
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param;

h_pan = h.uipanel_TA_kineticModel;
if ~prepPanel(h.uipanel_TA_kineticModel,h)
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};
prm = p.proj{proj}.TA.prm{tag,tpe};

if ~(isfield(prm,'clst_res') && ~isempty(prm.clst_res{1}))
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
set(h.edit_TA_mdlRestartNb,'string',num2str(T));
set(h.popupmenu_TA_mdlMeth,'value',meth_mdl);
if meth_mdl==1
    set(h.edit_TA_mdlJmax,'string',num2str(D));
else
    set([h.text_TA_mdlJmax,h.edit_TA_mdlJmax],'enable','off');
    set(h.edit_TA_mdlJmax,'string','');
end

if ~(isfield(prm,'mdl_res') && size(prm.mdl_res,2)>=5 && ...
        ~isempty(prm.mdl_res{3})) % no probability infered yet
    return
end
if ~isempty(prm.mdl_res{3})
    if get(h.popupmenu_TA_mdlDtState,'Value')>V
        set(h.popupmenu_TA_mdlDtState,'Value',V);
    end
    str_pop = cell(1,V);
    for v = 1:V
        str_pop{v} = sprintf('%0.2f',states(v));
    end
    set(h.popupmenu_TA_mdlDtState,'String',str_pop);
else
    set([h.popupmenu_TA_mdlDtState,h.text_TA_mdlDtState],'Enable','off');
end


