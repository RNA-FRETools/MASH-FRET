function ud_DTA(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    p_panel = p.proj{proj}.curr{mol}{4};
    chan = p.proj{proj}.fix{3}(4);
    
    method = p_panel{1}(1);
    toFRET = p_panel{1}(2);
    prm = p_panel{2}(method,:,chan);
    thresh = p_panel{4}(:,:,chan);
    states = p_panel{3}(chan,:);
    
    labels = p.proj{proj}.labels;
    exc = p.proj{proj}.excitations;
    FRET = p.proj{proj}.FRET;
    S = p.proj{proj}.S;
    nFRET = size(FRET,1);
    nS = size(S,1);
    if chan > (nFRET + nS)
        perSec = p.proj{proj}.fix{2}(4);
        perPix = p.proj{proj}.fix{2}(5);
        if perSec
            rate = p.proj{proj}.frame_rate;
            states = states/rate;
            thresh = thresh/rate;
            prm(4) = prm(4)/rate;
        end
        if perPix
            nPix = p.proj{proj}.pix_intgr(2);
            states = states/nPix;
            thresh = thresh/nPix;
            prm(4) = prm(4)/nPix;
        end
    end
    
    set(h.popupmenu_DTAmethod, 'Value', method);
    
    if method ~= 3 % one state
        set(h.popupmenu_DTAchannel, 'String', getStrPop('DTA_chan', ...
            {labels FRET S exc p.proj{proj}.colours}), 'Value', chan);
    else
        set(h.popupmenu_DTAchannel, 'String', {'none'}, 'Value', 1);
    end
    switch toFRET
        case 2
            set(h.radiobutton_DTA2all, 'Value', 1);
            set(h.radiobutton_DTA2bottom, 'Value', 0);
            set(h.radiobutton_DTA2top, 'Value', 0);
        case 1
            set(h.radiobutton_DTA2all, 'Value', 0);
            set(h.radiobutton_DTA2bottom, 'Value', 1);
            set(h.radiobutton_DTA2top, 'Value', 0);
        case 0
            set(h.radiobutton_DTA2all, 'Value', 0);
            set(h.radiobutton_DTA2bottom, 'Value', 0);
            set(h.radiobutton_DTA2top, 'Value', 1);
    end
    
    h_thresh = [h.edit_DTAthresh01 h.edit_DTAthresh02 ...
        h.edit_DTAthresh03 h.edit_DTAthresh04 h.edit_DTAthresh05 ...
        h.edit_DTAthresh06];
    h_low = [h.edit_low_01 h.edit_low_02 h.edit_low_03 h.edit_low_04 ...
        h.edit_low_05];
    h_up = [h.edit_up_02 h.edit_up_03 h.edit_up_04 h.edit_up_05 ...
        h.edit_up_06];
    h_states = [h.edit_DTAstate_01 h.edit_DTAstate_02 ...
        h.edit_DTAstate_03 h.edit_DTAstate_04 h.edit_DTAstate_05 ...
        h.edit_DTAstate_06];
    h_param = [h.edit_DTA_minN h.edit_DTA_maxN h.edit_DTA_smooth ...
        h.edit_DTA_bin h.edit_DTAparam_01 h.edit_DTAparam_02 ...
        h.edit_DTAparam_03 h.edit_DTAparam_04];
    
    for i = 1:numel(h_param)
        set(h_param(i), 'String', num2str(prm(i)), 'BackgroundColor', ...
            [1 1 1]);
    end
    
    set(h_states, 'BackgroundColor', [1 1 1]);
    for s = 1:numel(h_states)
        if ~isnan(states(s))
            set(h_states(s), 'String', num2str(states(s)), ...
                'BackgroundColor', [0.75 1 0.75]);
        else
            set(h_states(s), 'String', '', 'BackgroundColor', [1 1 1]);
        end
    end
    
    for i = 1:numel(h_thresh)
        set(h_thresh(i), 'String', num2str(thresh(1,i)), ...
            'BackgroundColor', [1 1 1]);
        if i < numel(h_thresh)
            set(h_low(i), 'String', num2str(thresh(2,i)), ...
                'BackgroundColor', [1 1 1]);
        end
        if i > 1
            set(h_up(i-1), 'String', num2str(thresh(3,i)), ...
                'BackgroundColor', [1 1 1]);
        end
    end

    if ~toFRET && (nFRET + nS) > 0
        set(h_param(8), 'Enable', 'on', 'BackgroundColor', [1 1 1]);
    else
        set(h_param(8), 'Enable', 'off');
    end
    
    set(h_states, 'Enable', 'inactive');

    if method == 1 % Thresholding
        set([h_thresh(1:prm(2)) h_low(1:prm(2)-1) h_up(1:prm(2)-1) ...
            h_param(2:4)], 'Enable', 'on', 'BackgroundColor', [1 1 1]);
        set(h.text_threshParam, 'Enable', 'on');
        if prm(2) < 6
            set([h_thresh(prm(2)+1:end) h_low(prm(2):end) ...
                h_up(prm(2):end)], 'Enable', 'off');
        end
        set(h_param([1 5:7]), 'Enable', 'off');
        set(h.popupmenu_DTAchannel, 'Enable', 'on');
        
    else
        set([h_thresh h_low h_up h.text_threshParam], 'Enable', 'off');
        
        switch method
            case 2 % VbFRET
                set(h_param(6:7), 'Enable', 'off');
                set(h_param(5), 'TooltipString', 'Iteration number');
                set(h_param(1:5), 'Enable', 'on', 'BackgroundColor', ...
                    [1 1 1]);
                set(h.popupmenu_DTAchannel, 'Enable', 'on');
                
            case 3 % One state
                set([h_param(1:8) h.popupmenu_DTAchannel], 'Enable', ...
                    'off');

            case 4 % CPA
                set(h_param([1 2]), 'Enable', 'off');
                set(h_param(3:7), 'Enable', 'on', 'BackgroundColor', ...
                    [1 1 1]);
                set(h_param(5), 'TooltipString', ...
                    'Number of bootstrap sample');
                set(h_param(6), 'TooltipString', 'Significance level');
                set(h_param(7), 'TooltipString', ...
                    'Change localisation (1 or 2 >> "max." or "MSE")');
                set(h.popupmenu_DTAchannel, 'Enable', 'on');
                
            case 5 % STaSI
                set(h_param([1 5:7]), 'Enable', 'off');
                set(h_param(2:4), 'Enable', 'on');
                set(h.popupmenu_DTAchannel, 'Enable', 'on');
        end
    end
end

