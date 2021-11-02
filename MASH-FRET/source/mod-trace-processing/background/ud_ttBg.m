function ud_ttBg(h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TP_backgroundCorrection,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
isMov = p.proj{proj}.is_movie;
isCoord = p.proj{proj}.is_coord;
labels = p.proj{proj}.labels;
exc = p.proj{proj}.excitations;
nChan = p.proj{proj}.nb_channel;
clr = p.proj{proj}.colours;
rate = p.proj{proj}.frame_rate;
perSec = p.proj{proj}.cnt_p_sec;
fix = p.proj{proj}.TP.fix;
curr = p.proj{proj}.TP.curr{mol};

% get channel and laser corresponding to selected data
selected_chan = fix{3}(6);
chan = 0;
nExc = numel(exc);
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
p_panel = curr{3};
apply = p_panel{1}(l,c);
method = p_panel{2}(l,c);
prm = p_panel{3}{l,c}(method,:);
autoDark = prm(6);
set(h.popupmenu_trBgCorr, 'Value', method);

set(h.popupmenu_trBgCorr_data, 'String', getStrPop('bg_corr', ...
    {labels exc clr}));

if isMov && isCoord
    set(h.pushbutton_optBg, 'Enable', 'off');
end

switch method
    case 1 % Manual
        set([h.edit_trBgCorrParam_01 h.edit_xDark h.edit_yDark ...
            h.checkbox_autoDark h.pushbutton_showDark ...
            h.text_trBgCorr_bgInt h.text_xDark h.text_yDark], ...
            'Enable', 'off');

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
        set(h.edit_trBgCorrParam_01, 'TooltipString', 'Tolerance cutoff');

    case 4 % Most frequent value
        set([h.edit_xDark h.edit_yDark h.checkbox_autoDark ...
            h.pushbutton_showDark h.text_trBgCorr_bgInt ...
            h.text_xDark h.text_yDark], 'Enable', 'off');
        set(h.edit_trBgCorr_bgInt, 'Enable', 'inactive');
        set(h.edit_trBgCorrParam_01, 'TooltipString', ...
            'Number of binning interval');

    case 5 % Histothresh
        set([h.edit_xDark h.edit_yDark h.checkbox_autoDark ...
            h.pushbutton_showDark h.text_trBgCorr_bgInt ...
            h.text_xDark h.text_yDark], 'Enable', 'off');
        set(h.edit_trBgCorr_bgInt, 'Enable', 'inactive');
        set(h.edit_trBgCorrParam_01, 'TooltipString', ...
            'Cumulative probability threshold');

    case 6 % Dark trace
        if autoDark
           set([h.edit_xDark h.edit_yDark], 'Enable', 'inactive');
        end

        set(h.edit_trBgCorr_bgInt, 'Enable', 'inactive');
        set(h.edit_trBgCorrParam_01, 'TooltipString', ...
            'Running average window size');

    case 7 % Median value
        set([h.edit_xDark h.edit_yDark h.checkbox_autoDark ...
            h.pushbutton_showDark h.text_trBgCorr_bgInt ...
            h.text_xDark h.text_yDark], 'Enable', 'off');
        set(h.edit_trBgCorr_bgInt, 'Enable', 'inactive');
        set(h.edit_trBgCorrParam_01, 'TooltipString', ...
            sprintf(['Calculation method\n\t1: median(median_y)\n\t2: ',...
            '0.5*(median(median_y)+median(median_x))']));
end
if perSec
    prm(3) = prm(3)/rate;
end
set(h.edit_trBgCorrParam_01, 'String', num2str(prm(1)));
set(h.edit_subImg_dim, 'String', num2str(prm(2)), 'TooltipString', ...
    'Sub-image window size for background calculation');
set(h.edit_trBgCorr_bgInt, 'String', num2str(prm(3)));
set(h.checkbox_trBgCorr, 'Value', apply);
set(h.edit_xDark, 'String', num2str(prm(4)));
set(h.edit_yDark, 'String', num2str(prm(5)));
set(h.checkbox_autoDark, 'Value', autoDark);
