function ud_ttBg(h_fig)

% defaults
str = {'BG:','mean BG:'};
ttstr = {['Calculated <b>mean background intensity</b> for the selected ',...
    'intensity-time trace.'],['Calculated <b>background intensity</b> for',...
    ' the selected intensity-time trace.']};

% collect interface parameters
h = guidata(h_fig);
p = h.param;
q = h.dimprm;

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
apply = p_panel{1}(l,c,1);
dynbg = p_panel{1}(l,c,2);
method = p_panel{2}(l,c);
prm = p_panel{3}{l,c}(method,:);
autoDark = prm(6);
set(h.popupmenu_trBgCorr, 'Value', method);

set(h.popupmenu_trBgCorr_data, 'String', getStrPop('bg_corr', ...
    {labels exc clr}));

if ~(isMov && isCoord)
    set(h.pushbutton_optBg, 'Enable', 'off');
end

% adjust control properties according to dynamic/static background
if method==1
    dynbg = 0;
end
if ~dynbg
    set(h.pushbutton_showDark,'enable','off');
end
set(h.text_trBgCorr_bgInt,'string',str{dynbg+1});
set(h.edit_trBgCorr_bgInt,'tooltipstring',...
    wrapHtmlTooltipString(ttstr{dynbg+1}));

% shift controls positions
wtxt = getUItextWidth(str{dynbg+1},q.fntun,q.fntsz1,'normal',q.tbl);
postxt = getPixPos(h.text_trBgCorr_bgInt);
posed = getPixPos(h.edit_trBgCorr_bgInt);
poscb = getPixPos(h.checkbox_trBgCorr);
setPixPos(h.text_trBgCorr_bgInt,[postxt([1,2]),wtxt,postxt(4)]);
setPixPos(h.edit_trBgCorr_bgInt,[postxt(1)+wtxt,posed(2:4)]);
setPixPos(h.checkbox_trBgCorr,[postxt(1)+wtxt+posed(3)+q.mg/2,poscb(2:4)]);

% adjust control properties according to method
switch method
    case 1 % Manual
        set([h.edit_trBgCorrParam_01 h.edit_xDark h.edit_yDark ...
            h.checkbox_autoDark h.pushbutton_showDark h.text_xDark ...
            h.text_yDark,h.checkbox_TP_bgdyn],'Enable', 'off');
        set([h.edit_trBgCorrParam_01 h.edit_xDark h.edit_yDark],'string',...
            '');

    case 2 % 20 darkest
        set([h.edit_trBgCorrParam_01 h.edit_xDark h.edit_yDark ...
            h.checkbox_autoDark h.text_xDark h.text_yDark],'Enable','off');
        set([h.edit_trBgCorrParam_01 h.edit_xDark h.edit_yDark],'string',...
            '');

    case 3 % Mean value
        set([h.edit_xDark h.edit_yDark h.checkbox_autoDark ...
            h.text_xDark h.text_yDark],'Enable','off');
        set([h.edit_xDark h.edit_yDark],'string','');
        set(h.edit_trBgCorrParam_01, 'TooltipString', 'Tolerance cutoff');

    case 4 % Most frequent value
        set([h.edit_xDark h.edit_yDark h.checkbox_autoDark h.text_xDark ...
            h.text_yDark], 'Enable', 'off');
        set([h.edit_xDark h.edit_yDark],'string','');
        set(h.edit_trBgCorrParam_01, 'TooltipString', ...
            'Number of binning interval');

    case 5 % Histothresh
        set([h.edit_xDark h.edit_yDark h.checkbox_autoDark h.text_xDark ...
            h.text_yDark], 'Enable', 'off');
        set([h.edit_xDark h.edit_yDark],'string','');
        set(h.edit_trBgCorrParam_01, 'TooltipString', ...
            'Cumulative probability threshold');

    case 6 % Dark coordinates
        if autoDark
           set([h.edit_xDark h.edit_yDark], 'Enable', 'inactive');
        end
        if dynbg
            set(h.edit_trBgCorrParam_01, 'TooltipString', ...
                'Running average window size');
        else
            set(h.edit_trBgCorrParam_01,'string','','enable','off');
        end

    case 7 % Median value
        set([h.edit_xDark h.edit_yDark h.checkbox_autoDark ...
            h.text_xDark h.text_yDark], 'Enable', 'off');
        set([h.edit_xDark h.edit_yDark],'string','');
        set(h.edit_trBgCorrParam_01, 'TooltipString', ...
            sprintf(['Calculation method\n\t1: median(median_y)\n\t2: ',...
            '0.5*(median(median_y)+median(median_x))']));
end
if perSec
    prm(3) = prm(3)/rate;
end
if all(method~=[1,2])
    set(h.edit_trBgCorrParam_01, 'String', num2str(prm(1)));
end
if method==6
    set(h.edit_xDark, 'String', num2str(prm(4)));
    set(h.edit_yDark, 'String', num2str(prm(5)));
end
set(h.edit_subImg_dim, 'String', num2str(prm(2)), 'TooltipString', ...
    'Sub-image window size for background calculation');
set(h.edit_trBgCorr_bgInt, 'String', num2str(prm(3)));
set(h.checkbox_TP_bgdyn, 'Value', dynbg);
set(h.checkbox_trBgCorr, 'Value', apply);
set(h.checkbox_autoDark, 'Value', autoDark);
