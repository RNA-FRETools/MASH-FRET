function ud_TA_visuArea(h_fig)
% ud_TA_visuArea(h_fig)
%
% Set visualization area control properties to proper values
%
% h_fig: handle to main figure

% default
gray = [0.94,0.94,0.94];

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};
prm = p.proj{proj}.TA.prm{tag,tpe}; % interface settings at last analysis
def = p.proj{proj}.TA.def{tag,tpe}; 

% update TDP tab
if ~(isfield(prm,'plot') && ~isempty(prm.plot{2}) && ...
        ~(numel(prm.plot{2})==1 && isnan(prm.plot{2})))
    set(h.popupmenu_TA_setClstClr,'string',{''},'enable','off');
    set(h.pushbutton_TA_setClstClr,'backgroundcolor',gray,'enable','off');
else
    set([h.popupmenu_TA_setClstClr,h.pushbutton_TA_setClstClr],'enable',...
        'on');
    if isfield(prm,'clst_res') && ~isempty(prm.clst_res{1})
        clr = prm.clst_start{3};
    else
        clr = curr.clst_start{3};
    end
    K = size(clr,1);
    k = h.popupmenu_TA_setClstClr.Value;
    if k>K
        k = K;
    end
    str_pop = getClrStrPop(cellstr(num2str((1:K)'))',clr);
    set(h.popupmenu_TA_setClstClr,'string',str_pop,'value',k);
    set(h.pushbutton_TA_setClstClr,'backgroundcolor',clr(k,:));
end

% update Dwell times tab
if ~(isfield(prm,'clst_res') && ~isempty(prm.clst_res{1}))
    set(h.pushbutton_TDPfit_log,'visible','off','enable','off');
else
    set(h.pushbutton_TDPfit_log,'visible','on','enable','on');
end

% update Simulation tab
if ~(isfield(prm,'mdl_res') && ~isequal(prm.mdl_res,def.mdl_res) && ...
        ~isempty(prm.mdl_res{4}) && ~isempty(prm.mdl_res{5}))
    set([h.popupmenu_TA_mdlDtState,h.text_TA_mdlDtState],'visible','off',...
        'enable','off');
else
    set([h.popupmenu_TA_mdlDtState,h.text_TA_mdlDtState],'visible','on',...
        'enable','on');
    J = prm.lft_start{2}(1);
    mat = prm.clst_start{1}(4);
    clstDiag = prm.clst_start{1}(9);
    mu = prm.clst_res{1}.mu{J};
    bin = prm.lft_start{2}(3);
    nTrs = getClusterNb(J,mat,clstDiag);
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
    [states,~] = binStateValues(mu,bin,[j1,j2]);
    V = numel(states);

    if get(h.popupmenu_TA_mdlDtState,'value')>V
        set(h.popupmenu_TA_mdlDtState,'value',V);
    end
    str_pop = cell(1,V);
    for v = 1:V
        str_pop{v} = sprintf('%0.2f',states(v));
    end
    set(h.popupmenu_TA_mdlDtState,'string',str_pop);
end
