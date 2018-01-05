function ud_SFpanel(h_fig)
h = guidata(h_fig);
p = h.param.movPr;
nC = p.nChan;
labels = p.labels;
chan = get(h.popupmenu_SFchannel, 'Value');
if chan > nC
    chan = nC;
end

str_units = 'counts';
if p.perSec
    str_units = strcat(str_units, ' /s');
    p.SF_intThresh(chan) = p.SF_intThresh(chan)/p.rate;
    p.SF_minI(chan) = p.SF_minI(chan)/p.rate;
end

set(h.popupmenu_SF, 'Value', p.SF_method);
set(h.popupmenu_SFchannel, 'Value', chan, 'String', ...
    getStrPop('chan', {labels []}));
set(h.checkbox_SFgaussFit, 'Value', p.SF_gaussFit);
set(h.checkbox_SFall, 'Value', p.SF_all);
set(h.edit_SFparam_minI, 'String', num2str(p.SF_minI(chan)));
set(h.edit_SFparam_w, 'String', num2str(p.SF_w(chan)));
set(h.edit_SFparam_h, 'String', num2str(p.SF_h(chan)));
set(h.edit_SFparam_darkW, 'String', num2str(p.SF_darkW(chan)));
set(h.edit_SFparam_darkH, 'String', num2str(p.SF_darkH(chan)));
set(h.edit_SFparam_maxN, 'String', num2str(p.SF_maxN(chan)));
set(h.edit_SFparam_minHWHM, 'String', num2str(p.SF_minHWHM(chan)));
set(h.edit_SFparam_maxHWHM, 'String', num2str(p.SF_maxHWHM(chan)));
set(h.edit_SFparam_maxAssy, 'String', num2str(p.SF_maxAssy(chan)));
set(h.edit_SFparam_minDspot, 'String', num2str(p.SF_minDspot(chan)));
set(h.edit_SFparam_minDedge, 'String', num2str(p.SF_minDedge(chan)));

if p.SF_method == 1 % none
    set([h.edit_SFintThresh h.edit_SFparam_minI h.edit_SFparam_w ...
        h.edit_SFparam_h h.edit_SFparam_darkW h.edit_SFparam_darkH ...
        h.edit_SFparam_maxN h.edit_SFparam_minHWHM ...
        h.edit_SFparam_maxHWHM h.edit_SFparam_maxAssy ...
        h.edit_SFparam_minDspot h.edit_SFparam_minDedge ...
        h.popupmenu_SFchannel h.checkbox_SFgaussFit h.edit_SFres ...
        h.checkbox_SFall], 'Enable', 'off');
    
else
    set([h.edit_SFintThresh h.edit_SFparam_minI h.edit_SFparam_maxN ...
        h.edit_SFparam_minDspot h.edit_SFparam_minDedge ...
        h.popupmenu_SFchannel h.checkbox_SFgaussFit h.checkbox_SFall], ...
        'Enable', 'on');
    set(h.edit_SFres, 'Enable', 'inactive');
    set(h.edit_SFparam_minI, 'TooltipString', ['Minimum peak amplitude' ...
        'for selection (' str_units ')']);
    
    if p.SF_method == 2 % "in-line" screening
        set(h.edit_SFintThresh, 'TooltipString', ['Minimum peak ' ...
            'amplitude for peak detection (' str_units ')'], 'String', ...
            num2str(p.SF_intThresh(chan)));
        set(h.edit_SFparam_darkW, 'Enable', 'on', 'TooltipString', ...
            'Dark area width');
        set(h.edit_SFparam_darkH, 'Enable', 'on', 'TooltipString', ...
            'Dark area height');
        
    elseif p.SF_method == 3 % houghpeaks
        set(h.edit_SFintThresh, 'TooltipString', ['Threshold (' ...
            str_units ')'], 'String', num2str(p.SF_intThresh(chan)));
        set(h.edit_SFparam_darkW, 'Enable', 'on', 'TooltipString', ...
            'NHoodSize (x-direction)');
        set(h.edit_SFparam_darkH, 'Enable', 'on', 'TooltipString', ...
            'NHoodSize (y-direction)');
        
    elseif p.SF_method == 4 % Schmied2012
        set(h.edit_SFintThresh, 'TooltipString', 'Threshold', 'String', ...
            num2str(p.SF_intRatio(chan)));
        set(h.edit_SFparam_darkH, 'Enable', 'on', 'TooltipString', ...
            ['Distance from image edge not considered for analysis ' ...
            '(in pix)']);
        
        set(h.edit_SFparam_darkW, 'Enable', 'off');
        
    elseif p.SF_method == 5 % twotone
        set(h.edit_SFintThresh, 'TooltipString', ['Intensity (volume) ' ...
            'threshold (' str_units ')'], 'String', ...
            num2str(p.SF_intThresh(chan)));
        set(h.edit_SFparam_darkW, 'Enable', 'on', 'TooltipString', ...
            'Band pass kernel diameter');
        set(h.edit_SFparam_darkH, 'Enable', 'off');
    end

    if p.SF_gaussFit
        set([h.edit_SFparam_w h.edit_SFparam_h ...
            h.edit_SFparam_minHWHM h.edit_SFparam_maxHWHM ...
            h.edit_SFparam_maxAssy], 'Enable', ...
            'on');
    else
        set([h.edit_SFparam_w h.edit_SFparam_h ...
            h.edit_SFparam_minHWHM h.edit_SFparam_maxHWHM ...
            h.edit_SFparam_maxAssy], 'Enable', ...
            'off');
    end
end

if size(p.SFres,1) >= 2
    set(h.edit_SFres, 'String', num2str(size(p.SFres{2,chan},1)), ...
        'BackgroundColor', [0.75 1 0.75]);
else
    set(h.edit_SFres, 'String', '', 'BackgroundColor', [1 1 1]);
end
