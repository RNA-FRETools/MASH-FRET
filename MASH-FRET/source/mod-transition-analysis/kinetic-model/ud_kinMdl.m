function ud_kinMdl(h_fig)
% Set properties of all controls in panel "Kinetic model" to proper values.
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param;

% check if panel control must be updated
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

meth_mdl = curr.mdl_start(1);
T = curr.mdl_start(2);
D = curr.mdl_start(3);

% check for state lifetimes
set(h.edit_TA_mdlRestartNb,'string',num2str(T));
set(h.popupmenu_TA_mdlMeth,'value',meth_mdl);
if meth_mdl==1
    set(h.edit_TA_mdlJmax,'string',num2str(D));
else
    set([h.text_TA_mdlJmax,h.edit_TA_mdlJmax],'enable','off');
    set(h.edit_TA_mdlJmax,'string','');
end


