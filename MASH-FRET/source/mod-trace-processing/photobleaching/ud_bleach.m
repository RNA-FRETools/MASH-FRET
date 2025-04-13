function ud_bleach(h_fig)

% defaults
ttstr0 = '<b>Data threshold</b> (%s): data value (relative to max. signal value) below which the trajectory is considered to be in a <b>"off" state</b>. <b>Photobleaching</b> cutoff is set when the data dwells 99%% of the remaining time in a "off" state.';
ttstr1 = '<b>Minimum bleaching time</b> (%s): minimum duration for the last "off" dwell time to be considered as photobleaching instead of blinking.';

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TP_photobleaching,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
chanExc = p.proj{p.curr_proj}.chanExc;
labels = p.proj{p.curr_proj}.labels;
exc = p.proj{proj}.excitations;
clr = p.proj{proj}.colours;
rate = p.proj{proj}.resampling_time;
inSec = p.proj{proj}.time_in_sec;
p_panel = p.proj{proj}.TP.curr{mol}{2};

method = p_panel{1}(2);
cutEv = p_panel{1}(3);
cutOff = p_panel{1}(4+method);
chan = h.popupmenu_bleachChan.Value;
if method==2
    popstr = getStrPop('bleach_chan', {labels exc chanExc clr});
    if chan>numel(popstr)
        chan = numel(popstr);
    end
end
prm = p_panel{2}(chan,:);

if inSec
    cutOff = cutOff*rate;
    prm(2:3) = prm(2:3)*rate;
    str_tun = 'in seconds';
else
    str_tun = 'in time steps';
end
str_iun = 'relative to max.';

set(h.edit_photobl_stop, 'String', num2str(cutOff));
set(h.popupmenu_debleachtype, 'Value', method);
set(h.popupmenu_TP_pbEvent, 'Value', cutEv);

switch method
    case 1 % Manual
        set([h.text_TP_pbEvent h.popupmenu_TP_pbEvent ...
            h.edit_photoblParam_01  h.edit_photoblParam_02 ...
            h.edit_photoblParam_03 h.text_bleachChan ...
            h.popupmenu_bleachChan],'Enable','off');

    case 2 % Threshold
        set([h.edit_photobl_stop,h.edit_photoblParam_03], 'Enable', ...
            'inactive');
end
if method==2
    set(h.popupmenu_bleachChan, 'Value', chan, 'String',popstr);
else
    set(h.popupmenu_bleachChan, 'Value', 1, 'String', {'none'});
end
set(h.edit_photoblParam_01,'string',num2str(prm(1)),'tooltipstring',...
    wrapHtmlTooltipString(sprintf(ttstr0,str_iun)));
set(h.edit_photoblParam_02, 'String', num2str(prm(2)),'tooltipstring',...
    wrapHtmlTooltipString(sprintf(ttstr1,str_tun)));
set(h.edit_photoblParam_03, 'String', num2str(prm(3)));

    