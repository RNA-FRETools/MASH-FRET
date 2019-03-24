function ud_ttBg(h_fig)
h = guidata(h_fig);
p = h.param.ttPr.proj;
if ~isempty(p)
    proj = h.param.ttPr.curr_proj;
    isMov = p{proj}.is_movie;
    isCoord = p{proj}.is_coord;
    mol = h.param.ttPr.curr_mol(proj);
    labels = p{proj}.labels;
    exc = p{proj}.excitations;
    nExc = numel(exc);
    nChan = p{proj}.nb_channel;
    
    % get channel and laser corresponding to selected data
    selected_chan = p{proj}.fix{3}(6);
    chan = 0;
    for l = 1:nExc
        for c = 1:nChan
            chan = chan+1;
            if chan==selected_chan
                break;
            end
        end
        if chan==selected_chan
            break;
        end
    end
    p_panel = p{proj}.curr{mol}{3};
    apply = p_panel{1}(l,c);
    method = p_panel{2}(l,c);
    prm = p_panel{3}{l,c}(method,:);
    autoDark = prm(6);
    set(h.popupmenu_trBgCorr, 'Value', method);
    
    set(h.popupmenu_trBgCorr_data, 'String', getStrPop('bg_corr', ...
        {labels exc p{proj}.colours}));
    
    if isMov && isCoord
        set(h.pushbutton_optBg, 'Enable', 'on');
    else
        set(h.pushbutton_optBg, 'Enable', 'off');
    end
    
    switch method
        case 1 % Manual
            set([h.edit_trBgCorrParam_01 h.edit_xDark h.edit_yDark ...
                h.checkbox_autoDark h.pushbutton_showDark ...
                h.text_trBgCorr_bgInt h.text_xDark h.text_yDark], ...
                'Enable', 'off');
            set(h.edit_trBgCorr_bgInt, 'Enable', 'on');
            
        case 2 % 20 darkest
            set([h.edit_trBgCorrParam_01 h.edit_xDark h.edit_yDark ...
                h.checkbox_autoDark h.pushbutton_showDark ...
                h.text_trBgCorr_bgInt h.text_xDark h.text_yDark], ...
                'Enable', 'off');
            set(h.edit_trBgCorr_bgInt, 'Enable', 'inactive');
            
        case 3 % Mean value
            set([h.edit_xDark h.edit_yDark h.checkbox_autoDark ...
                h.pushbutton_showDark h.text_trBgCorr_bgInt ...
                h.text_xDark h.text_yDark], 'Enable', 'off');
            set(h.edit_trBgCorr_bgInt, 'Enable', 'inactive');
            set(h.edit_trBgCorrParam_01, 'Enable', 'on', ...
                'TooltipString', 'Tolerance cutoff');
            
        case 4 % Most frequent value
            set([h.edit_xDark h.edit_yDark h.checkbox_autoDark ...
                h.pushbutton_showDark h.text_trBgCorr_bgInt ...
                h.text_xDark h.text_yDark], 'Enable', 'off');
            set(h.edit_trBgCorr_bgInt, 'Enable', 'inactive');
            set(h.edit_trBgCorrParam_01, 'Enable', 'on', ...
                'TooltipString', 'Number of binning interval');
            
        case 5 % Histothresh
            set([h.edit_xDark h.edit_yDark h.checkbox_autoDark ...
                h.pushbutton_showDark h.text_trBgCorr_bgInt ...
                h.text_xDark h.text_yDark], 'Enable', 'off');
            set(h.edit_trBgCorr_bgInt, 'Enable', 'inactive');
            set(h.edit_trBgCorrParam_01, 'Enable', 'on', ...
                'TooltipString', 'Cumulative probability threshold');
            
        case 6 % Dark trace
            if ~autoDark
                set([h.edit_xDark h.edit_yDark h.checkbox_autoDark ...
                    h.pushbutton_showDark h.text_trBgCorr_bgInt ...
                    h.text_xDark h.text_yDark], 'Enable', 'on');
            else
               set([h.checkbox_autoDark h.pushbutton_showDark ...
                   h.text_trBgCorr_bgInt h.text_xDark h.text_yDark], ...
                   'Enable', 'on');
               set([h.edit_xDark h.edit_yDark], 'Enable', 'inactive');
            end
            
            set(h.edit_trBgCorr_bgInt, 'Enable', 'inactive');
            set(h.edit_trBgCorrParam_01, 'Enable', 'on', ...
                'TooltipString', 'Running average window size');
        
        case 7 % Median value
            set([h.edit_xDark h.edit_yDark h.checkbox_autoDark ...
                h.pushbutton_showDark h.text_trBgCorr_bgInt ...
                h.text_xDark h.text_yDark], 'Enable', 'off');
            set(h.edit_trBgCorr_bgInt, 'Enable', 'inactive');
            set(h.edit_trBgCorrParam_01, 'Enable', 'on', ...
                'TooltipString', sprintf(['Calculation method\n\t1: ' ...
                'median(median_y)\n\t2: 0.5*(median(median_y)+' ...
                'median(median_x))']));
    end
    perSec = p{proj}.fix{2}(4);
    perPix = p{proj}.fix{2}(5);
    if perSec
        rate = p{proj}.frame_rate;
        prm(3) = prm(3)/rate;
    end
    if perPix
        nPix = p{proj}.pix_intgr(2);
        prm(3) = prm(3)/nPix;
    end
    set(h.edit_trBgCorrParam_01, 'String', num2str(prm(1)));
    set(h.edit_subImg_dim, 'String', num2str(prm(2)), 'TooltipString', ...
        'Sub-image window size for background calculation');
    set(h.edit_trBgCorr_bgInt, 'String', num2str(prm(3)));
    set(h.checkbox_trBgCorr, 'Value', apply);
    set(h.edit_xDark, 'String', num2str(prm(4)));
    set(h.edit_yDark, 'String', num2str(prm(5)));
    set(h.checkbox_autoDark, 'Value', autoDark);
end