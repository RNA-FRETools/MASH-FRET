function ud_DTA(h_fig)

% Last update: by MH, 3.4.2019
% >> update "data" popupmenu string according to which traces are 
%    discretized: if only bottom traces are, only bottom traces data
%    are listed, otherwise all data aappear.
% >> improve code synthaxe
% >> adjust control enability when discretization is applied to top traces 
%    only and render static text off- or on- enable depending on settings

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    labels = p.proj{proj}.labels;
    exc = p.proj{proj}.excitations;
    FRET = p.proj{proj}.FRET;
    S = p.proj{proj}.S;
    nFRET = size(FRET,1);
    nS = size(S,1);
    p_panel = p.proj{proj}.curr{mol}{4};
    chan = p.proj{proj}.fix{3}(4);
    method = p_panel{1}(1);
    toFRET = p_panel{1}(2);
    
    data_str = getStrPop('DTA_chan',...
        {labels FRET S exc p.proj{proj}.colours});
    if toFRET==1 && (nFRET+nS)>0
        if chan>(nFRET+nS)
            chan = nFRET + nS;
        end
        set(h.popupmenu_TP_states_data,'String',data_str(1:nFRET+nS),...
            'Value',chan);
    else
        set(h.popupmenu_TP_states_data,'String',data_str,'Value',chan);
    end
    
    prm = p_panel{2}(method,:,chan);
    thresh = p_panel{4}(:,:,chan);
    states = p_panel{3}(chan,:);

    if chan > (nFRET + nS)
        perSec = p.proj{proj}.fix{2}(4);
        perPix = p.proj{proj}.fix{2}(5);
        if perSec
            rate = p.proj{proj}.frame_rate;
            states = states/rate;
            thresh = thresh/rate;
            prm(6) = prm(6)/rate;
        end
        if perPix
            nPix = p.proj{proj}.pix_intgr(2);
            states = states/nPix;
            thresh = thresh/nPix;
            prm(6) = prm(6)/nPix;
        end
    end
    
    set(h.popupmenu_TP_states_method, 'Value', method);
    
    if method == 3 % one state
        set(h.popupmenu_TP_states_data, 'String', {'none'}, 'Value', 1);
    end
    
    switch toFRET
        case 2 % all
            set(h.popupmenu_TP_states_applyTo, 'Value', 3);
        case 1 % bottom
            set(h.popupmenu_TP_states_applyTo, 'Value', 1);
        case 0 % top
            set(h.popupmenu_TP_states_applyTo, 'Value', 2);
    end

    h_param = [h.edit_TP_states_param1 h.edit_TP_states_param2 ...
        h.edit_TP_states_param3 h.edit_TP_states_paramTol ...
        h.edit_TP_states_paramRefine h.edit_TP_states_paramBin];
    h_param_txt = [h.text_TP_states_param1 h.text_TP_states_param2 ...
        h.text_TP_states_param3 h.text_states_paramTol ...
        h.text_TP_states_paramRefine h.text_TP_states_paramBin];
    
    set(h_param_txt, 'Enable', 'on');
    for i = 1:numel(h_param)
        set(h_param(i), 'String', num2str(prm(i)), 'BackgroundColor', ...
            [1 1 1], 'Enable', 'on');
    end
    
    data = get(h.popupmenu_TP_states_index,'value');
    J = sum(~isnan(states));
    set(h.text_TP_states_resultsStates,'string',cat(2,'Results (',...
        num2str(J),' states):'));
    if J>0
        set([h.text_TP_states_resultsStates h.popupmenu_TP_states_index ...
            h.text_TP_states_result],'enable','on');
        set(h.edit_TP_states_result,'enable','inactive');
        if data>J
            data = 1;
            set(h.popupmenu_TP_states_index,'value',data);
        end
        set(h.popupmenu_TP_states_index,'string',cellstr(num2str((1:J)')));
        set(h.edit_TP_states_result,'string',num2str(states(data)));
        
    else
        set(h.edit_TP_states_result,'string','');
        set([h.text_TP_states_resultsStates h.popupmenu_TP_states_index ...
            h.text_TP_states_result h.edit_TP_states_result],'enable',...
            'off');
    end

    if ~(~toFRET && (nFRET + nS)>0 && chan<=nFRET+nS)
        set(h_param(4),'Enable','off','string','');
        set(h_param_txt(4),'Enable','off');
    end

    if method == 1 % Thresholding

        set([h.text_TP_states_lowThresh,h.text_TP_states_state,...
            h.text_TP_states_highThresh h.text_TP_states_thresholds ...
            h.popupmenu_TP_states_indexThresh],'enable','on')
        
        set(h_param([2,3]),'Enable','off','string','');
        set(h_param_txt([2,3]),'Enable','off');
        
        set(h.popupmenu_TP_states_data, 'Enable', 'on');
        
        set([h.edit_TP_states_lowThresh,h.edit_TP_states_state,...
            h.edit_TP_states_highThresh],'Enable','on','BackgroundColor', ...
            [1 1 1]);
        
        data = get(h.popupmenu_TP_states_indexThresh,'value');
        if data>prm(1)
            data = 1;
            set(h.popupmenu_TP_states_indexThresh,'value',data);
        end
        set(h.popupmenu_TP_states_indexThresh,'string',...
            cellstr(num2str((1:prm(1))')));

        set(h.edit_TP_states_lowThresh,'string',num2str(thresh(2,data)));
        set(h.edit_TP_states_state,'string',num2str(thresh(1,data)));
        set(h.edit_TP_states_highThresh,'string',num2str(thresh(3,data)));
        
    else
        set([h.text_TP_states_thresholds h.popupmenu_TP_states_indexThresh ...
            h.text_TP_states_lowThresh h.text_TP_states_state ...
            h.text_TP_states_highThresh],'Enable','off');
        set([h.edit_TP_states_lowThresh h.edit_TP_states_state ...
            h.edit_TP_states_highThresh],'Enable','off','string','');
        
        switch method
            case 2 % VbFRET
                set(h_param(1),'TooltipString','Minimum number of states');
                set(h_param(2),'TooltipString','Maximum number of states');
                set(h_param(3),'TooltipString','Iteration number');
                
                set(h.popupmenu_TP_states_data, 'Enable', 'on');
                
            case 3 % One state
                set(h_param(1:6), 'Enable','off','string','');
                set(h_param_txt(1:6), 'Enable','off');
                
                set(h.popupmenu_TP_states_data,'enable','off');

            case 4 % CPA
                set(h_param(1),'TooltipString',...
                    'Number of bootstrap samples');
                set(h_param(2),'TooltipString','Significance level (in %)');
                set(h_param(3),'TooltipString',...
                    'Change localization (1:"max." or 2:"MSE")');
                
                set(h.popupmenu_TP_states_data,'Enable','on');
                
            case 5 % STaSI
                set(h_param([2,3]),'Enable','off','string','');
                set(h_param_txt([2,3]),'Enable','off');
                set(h_param(1),'TooltipString','Maximum number of states');
                
                set(h.popupmenu_TP_states_data,'Enable','on');
        end
    end
    
    if ~toFRET && chan<=nFRET+nS
        set(h_param(1:3),'Enable','off','string','');
        set(h_param_txt(1:3),'Enable','off');
        set([h.text_TP_states_thresholds h.popupmenu_TP_states_indexThresh ...
            h.text_TP_states_lowThresh h.text_TP_states_state ...
            h.text_TP_states_highThresh],'Enable','off');
        set([h.edit_TP_states_lowThresh h.edit_TP_states_state ...
            h.edit_TP_states_highThresh],'Enable','off','string','');
    end
end

