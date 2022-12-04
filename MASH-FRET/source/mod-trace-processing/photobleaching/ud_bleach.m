function ud_bleach(h_fig)

% defaults
ttstr0 = '<b>Data threshold (%s):</b> photobleaching is detected when the selected data-time trace drops below the threshold.';
ttstr1 = {...
    wrapHtmlTooltipString('<b>Tolerance (in seconds):</b> extra time to subtract to the detected photobleaching time'),...
    wrapHtmlTooltipString('<b>Tolerance (in frames):</b> extra frames to subtract to the detected photobleaching position')};
ttstr2 = {...
    wrapHtmlTooltipString('<b>Minimum cutoff time (in seconds):</b> photobleaching events detected below this time are ignored.')...
    wrapHtmlTooltipString('<b>Minimum cutoff position (in frames):</b> photobleaching events detected below this position are ignored.')};

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TP_photobleaching,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
labels = p.proj{p.curr_proj}.labels;
exc = p.proj{proj}.excitations;
clr = p.proj{proj}.colours;
rate = p.proj{proj}.frame_rate;
inSec = p.proj{proj}.time_in_sec;
perSec = p.proj{proj}.cnt_p_sec;
p_panel = p.proj{proj}.TP.curr{mol}{2};

cutIt = p_panel{1}(1);
method = p_panel{1}(2);
chan = p_panel{1}(3);
cutOff = p_panel{1}(4+method);
prm = p_panel{2}(chan,:);

if inSec
    cutOff = cutOff*rate;
    prm(2:3) = prm(2:3)*rate;
end
str_un = 'counts';
nFRET = size(FRET,1);
nS = size(S,1);
if chan > nFRET+nS % intensity channel
    if perSec
        prm(1) = prm(1)/rate;
        str_un = cat(2,str_un,' /second');
    end
end

set(h.edit_photobl_stop, 'String', num2str(cutOff));
set(h.popupmenu_debleachtype, 'Value', method);
set(h.checkbox_cutOff, 'Value', cutIt);

switch method
    case 1 % Manual
        set([h.edit_photoblParam_01 h.edit_photoblParam_02 ...
            h.edit_photoblParam_03 h.popupmenu_bleachChan], ...
            'Enable', 'off');

    case 2 % Threshold
        set(h.edit_photobl_stop, 'Enable', 'inactive');
end
if method == 2
    set(h.popupmenu_bleachChan, 'Value', chan, 'String', ...
        getStrPop('bleach_chan', {labels FRET S exc clr}));
else
    set(h.popupmenu_bleachChan, 'Value', 1, 'String', {'none'});
end
set(h.edit_photoblParam_01,'string',num2str(prm(1)),'tooltipstring',...
    wrapHtmlTooltipString(sprintf(ttstr0,str_un)));
set(h.edit_photoblParam_02, 'String', num2str(prm(2)));
set(h.edit_photoblParam_03, 'String', num2str(prm(3)));

if inSec
    set(h.edit_photoblParam_02, 'tooltipstring',ttstr1{1});
    set(h.edit_photoblParam_03, 'tooltipstring',ttstr2{1});
else
    set(h.edit_photoblParam_02, 'tooltipstring',ttstr1{2});
    set(h.edit_photoblParam_03, 'tooltipstring',ttstr2{2});
end
    