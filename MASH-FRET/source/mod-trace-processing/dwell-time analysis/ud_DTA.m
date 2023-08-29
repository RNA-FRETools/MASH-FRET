function ud_DTA(h_fig)

% Last update by MH, 23.12.2020: add method vbFRET 2D
% update by MH, 3.4.2019: (1) update "data" popupmenu string according to which traces are discretized: if only bottom traces are, only bottom traces data are listed, otherwise all data aappear, (2) improve code synthaxe, (3) adjust control enability when discretization is applied to top traces only and render static text off- or on- enable depending on settings

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TP_findStates,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
labels = p.proj{proj}.labels;
exc = p.proj{proj}.excitations;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
clr = p.proj{proj}.colours;
rate = p.proj{proj}.frame_rate;
perSec = p.proj{proj}.cnt_p_sec;
fix = p.proj{proj}.TP.fix;
curr = p.proj{proj}.TP.curr{mol};

p_panel = curr{4};
chan = fix{3}(4);
method = p_panel{1}(1);
toBot = p_panel{1}(2);
recalc = p_panel{1}(3);

set(h.checkbox_recalcStates,'value',recalc);

data_str = getStrPop('DTA_chan',{labels FRET S exc clr});
nFRET = size(FRET,1);
nS = size(S,1);
if toBot==1 && (nFRET+nS)>0
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
    if perSec
        states = states/rate;
        thresh = thresh/rate;
        prm(6) = prm(6)/rate;
    end
end

set(h.popupmenu_TP_states_method, 'Value', method);

if method==4 % one state
    set(h.popupmenu_TP_states_data, 'String', {'none'}, 'Value', 1);
end

switch toBot
    case 2 % all
        set(h.popupmenu_TP_states_applyTo, 'Value', 3);
    case 1 % bottom
        set(h.popupmenu_TP_states_applyTo, 'Value', 1);
    case 0 % top
        set(h.popupmenu_TP_states_applyTo, 'Value', 2);
end

h_param = [h.edit_TP_states_param1 h.edit_TP_states_param2 ...
    h.edit_TP_states_param3 h.edit_TP_states_paramTol ...
    h.edit_TP_states_paramRefine h.edit_TP_states_paramBin ...
    h.edit_TP_states_deblurr];
h_param_txt = [h.text_TP_states_param1 h.text_TP_states_param2 ...
    h.text_TP_states_param3 h.text_states_paramTol ...
    h.text_TP_states_paramRefine h.text_TP_states_paramBin ...
    h.text_TP_states_deblurr];

for i = 1:numel(h_param)
    set(h_param(i), 'String', num2str(prm(i)), 'BackgroundColor', [1 1 1]);
end

data = get(h.popupmenu_TP_states_index,'value');
J = sum(~isnan(states));
set(h.text_TP_states_resultsStates,'string',cat(2,'Results (',...
    num2str(J),' states):'));
if J>0
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

if ~(~toBot && (nFRET + nS)>0 && chan<=nFRET+nS)
    set(h_param(4),'Enable','off','string','');
    set(h_param_txt(4),'Enable','off');
end

if method==1 % Thresholding

    set(h_param([2,3]),'Enable','off','string','');
    set(h_param_txt([2,3]),'Enable','off');

    set([h.edit_TP_states_lowThresh,h.edit_TP_states_state,...
        h.edit_TP_states_highThresh],'BackgroundColor', [1 1 1]);

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
        case 2 % vbFRET-1D
            set(h_param(1),'TooltipString','Minimum number of states');
            set(h_param(2),'TooltipString','Maximum number of states');
            set(h_param(3),'TooltipString','Iteration number');

        case 3 % vbFRET-2D
            set(h_param(1),'TooltipString','Minimum number of states');
            set(h_param(2),'TooltipString','Maximum number of states');
            set(h_param(3),'TooltipString','Iteration number');

        case 4 % One state
            set(h_param(1:7), 'Enable','off','string','');
            set(h_param_txt(1:7), 'Enable','off');

            set(h.popupmenu_TP_states_data,'enable','off');

        case 5 % CPA
            set(h_param(1),'TooltipString',...
                'Number of bootstrap samples');
            set(h_param(2),'TooltipString','Significance level (in %)');
            set(h_param(3),'TooltipString',...
                'Change localization (1:"max." or 2:"MSE")');

        case 6 % STaSI
            set(h_param([2,3]),'Enable','off','string','');
            set(h_param_txt([2,3]),'Enable','off');
            set(h_param(1),'TooltipString','Maximum number of states');

        case 7 % imported
            set(h_param(1:3),'Enable','off','string','');
            set(h_param_txt(1:3),'Enable','off');
    end
end

if ~toBot && chan<=nFRET+nS
    set(h_param([1:3,5:6]),'Enable','off','string','');
    set(h_param_txt([1:3,5:6]),'Enable','off');
    set([h.text_TP_states_thresholds h.popupmenu_TP_states_indexThresh ...
        h.text_TP_states_lowThresh h.text_TP_states_state ...
        h.text_TP_states_highThresh],'Enable','off');
    set([h.edit_TP_states_lowThresh h.edit_TP_states_state ...
        h.edit_TP_states_highThresh],'Enable','off','string','');
end

