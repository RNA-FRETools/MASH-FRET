function set_TP_findStates(meth,trace,prm,thresh,nChan,nL,h_fig)
% set_TP_findStates(meth,prm,thresh,nChan,nL,h_fig)
%
% Set state finding algorithm to proper settings
%
% meth: index of state finding method in list
% prm: [nMeth-by-8-by-nDat] method parameters as set in getDefault_TP
% trace: use algorithm on (1) bottom traces, (2) top traces, or (3) all traces
% thresh: [J-by-3] low threshold, state and upper threshold values for "Threshold" method
% nChan: number of video channels
% nL: number of alternating lasers
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

nTraces = size(prm,3);
nTop = nChan*nL;
nBot = nTraces-nTop;

set(h.popupmenu_TP_states_method,'value',meth);
popupmenu_TP_states_method_Callback(h.popupmenu_TP_states_method,[],h_fig);
if meth ~= h.popupmenu_TP_states_method.Value
    return
end

set(h.popupmenu_TP_states_applyTo,'value',trace);
popupmenu_TP_states_applyTo_Callback(h.popupmenu_TP_states_applyTo,[],...
    h_fig);
if trace ~= h.popupmenu_TP_states_applyTo.Value
    return
end

switch trace
    case 1 % bottom
        datlist = 1:nBot;
        prm = prm(:,:,1:nBot);
    case 2 % top
        datlist = (nBot+1):nTraces;
    case 3 % all
        datlist = 1:nTraces;
end

for dat = datlist
    setIfEnabled(h.popupmenu_TP_states_data,'value',dat,1);
    setIfEnabled(h.edit_TP_states_param1,'string',num2str(prm(meth,1,dat)),...
        1);
    setIfEnabled(h.edit_TP_states_param2,'string',num2str(prm(meth,2,dat)),...
        1);
    setIfEnabled(h.edit_TP_states_param3,'string',num2str(prm(meth,3,dat)),...
        1);
    setIfEnabled(h.edit_TP_states_paramRefine,'string',...
        num2str(prm(meth,5,dat)),1);
    setIfEnabled(h.edit_TP_states_paramBin,'string',...
        num2str(prm(meth,6,dat)),1);
    setIfEnabled(h.edit_TP_states_deblurr,'string',...
        num2str(prm(meth,7,dat)),1);

    J = numel(get(h.popupmenu_TP_states_indexThresh,'string'));
    for state = 1:J
        setIfEnabled(h.popupmenu_TP_states_indexThresh,'value',state,1);
        if size(thresh,1)<state
            continue
        end
        setIfEnabled(h.edit_TP_states_lowThresh,'string',...
            num2str(thresh(state,1,dat)),1);
        setIfEnabled(h.edit_TP_states_state,'string',...
            num2str(thresh(state,2,dat)),1);
        setIfEnabled(h.edit_TP_states_highThresh,'string',...
            num2str(thresh(state,3,dat)),1);
    end
    
    setIfEnabled(h.checkbox_recalcStates,'value',prm(meth,8,dat),1);
end

for dat = 1:nBot
    setIfEnabled(h.edit_TP_states_paramTol,'string',...
        num2str(prm(meth,4,dat)),1);
end
