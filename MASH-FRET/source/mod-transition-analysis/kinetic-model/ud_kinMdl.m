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
expT = p.proj{proj}.frame_rate;
curr = p.proj{proj}.TA.curr{tag,tpe};
prm = p.proj{proj}.TA.prm{tag,tpe};

if ~(isfield(prm,'clst_res') && ~isempty(prm.clst_res{1}))
    setProp(h.uipanel_TA_kineticModel.Children,'enable','off');
    return
end

meth_mdl = curr.mdl_start{1}(1);
bin = curr.mdl_start{1}(2);
Dmax = curr.mdl_start{1}(3);
T_dph = curr.mdl_start{1}(4);
T_bw = curr.mdl_start{2};

% set state degeneracy
set(h.popupmenu_TA_mdlMeth,'value',meth_mdl);
set(h.pushbutton_TA_fitMLDPH,'string',...
    h.pushbutton_TA_fitMLDPH.UserData{meth_mdl});
if meth_mdl==1
    set(h.edit_TA_mdlBin,'string',num2str(bin));
    set(h.edit_TA_mdlJmax,'string',num2str(Dmax));
    set(h.edit_TA_mdlDPHrestart,'string',num2str(T_dph));
else
    set([h.text_TA_mdlBin,h.edit_TA_mdlBin,h.text_TA_mdlJmax,...
        h.edit_TA_mdlJmax,h.text_TA_mdlDPHrestart,h.edit_TA_mdlDPHrestart],...
        'enable','off');
    set([h.edit_TA_mdlBin,h.edit_TA_mdlJmax,h.edit_TA_mdlDPHrestart],...
        'string','');
end

% set ML-DPH results
if (meth_mdl==1 && isfield(prm,'mdl_res') && size(prm.mdl_res,2)>=6 && ...
        ~isempty(prm.mdl_res{6})) || (meth_mdl==2  && ...
        isfield(prm,'mdl_res') && size(prm.mdl_res,2)>=5 && ...
        ~isempty(prm.mdl_res{5}))
    
    % set lists
    states = prm.mdl_res{5}';
    statevals = unique(states);
    V = numel(statevals);
    
    h.popupmenu_TA_mdlHist.String = cellstr(num2str(statevals'));
    if h.popupmenu_TA_mdlHist.Value<1
        h.popupmenu_TA_mdlHist.Value = 1;
    end
    if h.popupmenu_TA_mdlHist.Value>V
        h.popupmenu_TA_mdlHist.Value = V;
    end
    v = h.popupmenu_TA_mdlHist.Value;
    
    D = sum(states==statevals(v));
    h.popupmenu_TA_mdlDegen.String = cellstr(num2str((1:D)'));
    if h.popupmenu_TA_mdlDegen.Value<1
        h.popupmenu_TA_mdlDegen.Value = 1;
    end
    if h.popupmenu_TA_mdlDegen.Value>D
        h.popupmenu_TA_mdlDegen.Value = D;
    end
    d = h.popupmenu_TA_mdlDegen.Value;

    % collect state lifetimes
    if meth_mdl==1
        mdl = prm.mdl_res{6}{3};
        lt = expT/(1-mdl.tp_fit{v}(d,d));
    elseif meth_mdl==2
        boba = prm.lft_start{1}{v,1}(5);
        if boba
            dec = prm.lft_res{v,1}(:,3,1)';
        else
            dec = prm.lft_res{v,2}(:,2,1)';
        end
        lt = dec(d);
    end
    
    set(h.edit_TA_mdlD,'string',num2str(D));
    set(h.edit_TA_mdlLifetime,'string',num2str(lt));
    
    if meth_mdl==2 
        set([h.text_TA_mdlTrans,h.popupmenu_TA_mdlTrans,...
            h.text_TA_mdlTransProb,h.edit_TA_mdlTransProb],'enable','off');
    else
        str = cell(1,D);
        j2s = 1:D;
        j2s(j2s==d) = [];
        for j = 1:numel(j2s)
            str{j} = [num2str(d),' to ',num2str(j2s(j))];
        end
        str{end} = 'absorption';
        h.popupmenu_TA_mdlTrans.String = str;
        if h.popupmenu_TA_mdlTrans.Value<1
            h.popupmenu_TA_mdlTrans.Value = 1;
        end
        if h.popupmenu_TA_mdlTrans.Value>D
            h.popupmenu_TA_mdlTrans.Value = D;
        end
        tr = h.popupmenu_TA_mdlTrans.Value;
        
        tp = mdl.tp_fit{v}(d,:);
        tp(d) = [];
        tp = tp/sum(tp);
        w = tp(tr);
        set(h.edit_TA_mdlTransProb,'string',num2str(w));
    end
    
else
    set([h.text_TA_mdlRes,h.text_TA_mdlHist,h.popupmenu_TA_mdlHist,...
        h.text_TA_mdlD,h.edit_TA_mdlD,h.text_TA_mdlDegen,...
        h.popupmenu_TA_mdlDegen,h.text_TA_mdlLifetime,...
        h.edit_TA_mdlLifetime,h.text_TA_mdlTrans,h.popupmenu_TA_mdlTrans,...
        h.text_TA_mdlTransProb,h.edit_TA_mdlTransProb],'enable','off');
end

% set Baum-Welch inferrence
set(h.edit_TA_mdlRestartNb,'string',num2str(T_bw));


