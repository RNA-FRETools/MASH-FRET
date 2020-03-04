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

set(h.popupmenu_TP_states_applyTo,'value',trace);
popupmenu_TP_states_applyTo_Callback(h.popupmenu_TP_states_applyTo,[],...
    h_fig);

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
    if meth~=3
        set(h.popupmenu_TP_states_data,'value',dat);
        popupmenu_TP_states_data_Callback(h.popupmenu_TP_states_data,[],...
            h_fig);

        set(h.edit_TP_states_param1,'string',num2str(prm(meth,1,dat)));
        edit_TP_states_param1_Callback(h.edit_TP_states_param1,[],h_fig);
        
        if sum(meth==[2,4])
            set(h.edit_TP_states_param2,'string',num2str(prm(meth,2,dat)));
            edit_TP_states_param2_Callback(h.edit_TP_states_param2,[],...
                h_fig);

            set(h.edit_TP_states_param3,'string',num2str(prm(meth,3,dat)));
            edit_TP_states_param3_Callback(h.edit_TP_states_param3,[],...
                h_fig);
        end

        set(h.edit_TP_states_paramRefine,'string',num2str(prm(meth,5,dat)));
        edit_TP_states_paramRefine_Callback(h.edit_TP_states_paramRefine,...
            [],h_fig);

        set(h.edit_TP_states_paramBin,'string',num2str(prm(meth,6,dat)));
        edit_TP_states_paramBin_Callback(h.edit_TP_states_paramBin,[],...
            h_fig);

        set(h.edit_TP_states_deblurr,'string',num2str(prm(meth,7,dat)));
        edit_TP_states_deblurr_Callback(h.edit_TP_states_deblurr,[],h_fig);

        if meth==1
            for state = 1:J
                set(h.popupmenu_TP_states_indexThresh,'value',state);
                popupmenu_TP_states_indexThresh_Callback(...
                    h.popupmenu_TP_states_indexThresh,[],h_fig);

                set(h.edit_TP_states_lowThresh,'string',...
                    num2str(thresh(state,1,dat)));
                edit_TP_states_lowThresh_Callback(...
                    h.edit_TP_states_lowThresh,[],h_fig);

                set(h.edit_TP_states_state,'string',...
                    num2str(thresh(state,2,dat)));
                edit_TP_states_state_Callback(h.edit_TP_states_state,[],...
                    h_fig);

                set(h.edit_TP_states_highThresh,'string',...
                    num2str(thresh(state,3,dat)));
                edit_TP_states_highThresh_Callback(...
                    h.edit_TP_states_highThresh,[],h_fig);
            end
        end
    end
    set(h.checkbox_recalcStates,'value',prm(meth,8,dat));
    checkbox_recalcStates_Callback(h.checkbox_recalcStates,[],h_fig);
end

if trace==2 && meth~=3
    for dat = 1:nBot
        set(h.edit_TP_states_paramTol,'string',num2str(prm(meth,4,dat)));
        edit_TP_states_paramTol_Callback(h.edit_TP_states_paramTol,[],...
            h_fig);
    end
end
