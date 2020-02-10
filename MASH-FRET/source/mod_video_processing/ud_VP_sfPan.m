function ud_VP_sfPan(h_fig)
% ud_VP_sfPan(h_fig)
%
% Set panel "Spot finder" in module Video processing to proper values
%
% h_fig: handle to main figure

% default
resClr = [0.75 1 0.75];
ttstr0 = wrapHtmlTooltipString('<b>Minimum peak amplitude</b> for selection (%s)');
ttstr1 = {'',... % none
    wrapHtmlTooltipString('<b>Minimum peak amplitude</b> for peak detection (%s)'),... % "in-line" screening
    wrapHtmlTooltipString('<b>Threshold</b> (%s)'),... % houghpeaks
    wrapHtmlTooltipString('<b>Threshold</b>'),... % Schmied2012
    wrapHtmlTooltipString('<b>Minimum peak volume</b> (%s)')}; % twotone
ttstr2 = {'',... % none
    wrapHtmlTooltipString('<b>Dimension</b> in the <b>x</b>-direction of the dark area (in pixels)'),... % "in-line" screening
    wrapHtmlTooltipString('<b>NHoodSize</b> in the <b>x</b>-direction (in pixels)'),... % houghpeaks
    wrapHtmlTooltipString(''),... % Schmied2012
    wrapHtmlTooltipString('<b>Diameter</b> of band-pass kernel (in pixels)')}; % twotone
ttstr3 = {'',... % none
    wrapHtmlTooltipString('<b>Dimension</b> in the <b>y</b>-direction of the dark area (in pixels)'),... % "in-line" screening
    wrapHtmlTooltipString('<b>NHoodSize</b> in the <b>y</b>-direction (in pixels)'),... % houghpeaks
    wrapHtmlTooltipString('<b>Number of pixels</b> around image edges to ignore during analysis'),... % Schmied2012
    ''}; % twotone

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% set all uicontrol enabled
setProp(h.uipanel_VP_spotfinder,'enable','on');

% reset edit fields background color
set([h.edit_SFintThresh,h.edit_SFparam_minI,h.edit_SFparam_w,...
    h.edit_SFparam_h,h.edit_SFparam_darkW,h.edit_SFparam_darkH,...
    h.edit_SFparam_maxN,h.edit_SFparam_minHWHM,h.edit_SFparam_maxHWHM,...
    h.edit_SFparam_maxAssy,h.edit_SFparam_minDspot,h.edit_SFparam_minDedge,...
    h.edit_SFres],'backgroundcolor',[1,1,1]);

% collect processing parameters
nC = p.nChan;
labels = p.labels;
meth = p.SF_method;
isRes = size(p.SFres,1)>=2;

% set channel
chan = get(h.popupmenu_SFchannel, 'Value');
if chan > nC
    chan = nC;
end
set(h.popupmenu_SFchannel, 'Value', chan, 'String', ...
    getStrPop('chan',{labels,[]}));

% convert intensity to proper units
str_units = 'counts';
if p.perSec
    str_units = strcat(str_units, ' /s');
    p.SF_intThresh(chan) = p.SF_intThresh(chan)/p.rate;
    p.SF_minI(chan) = p.SF_minI(chan)/p.rate;
end

% set method settings
set(h.popupmenu_SF, 'Value', meth);
set(h.checkbox_SFgaussFit, 'Value', p.SF_gaussFit);
set(h.checkbox_SFall, 'Value', p.SF_all);

% set spot detection parameters
set(h.edit_SFparam_minI,'String',num2str(p.SF_minI(chan)),'TooltipString',...
    sprintf(ttstr0,str_units));
set(h.edit_SFparam_darkW,'String',num2str(p.SF_darkW(chan)),...
    'TooltipString',ttstr2{meth});
set(h.edit_SFparam_darkH,'String',num2str(p.SF_darkH(chan)),...
    'TooltipString',ttstr3{meth});
set(h.edit_SFparam_maxN,'String',num2str(p.SF_maxN(chan)));
set(h.edit_SFparam_minDspot,'String',num2str(p.SF_minDspot(chan)));
set(h.edit_SFparam_minDedge,'String',num2str(p.SF_minDedge(chan)));
if meth==1 % none
    set([h.edit_SFintThresh h.edit_SFparam_minI h.edit_SFparam_w ...
        h.edit_SFparam_h h.edit_SFparam_darkW h.edit_SFparam_darkH ...
        h.edit_SFparam_maxN h.edit_SFparam_minHWHM h.edit_SFparam_maxHWHM ...
        h.edit_SFparam_maxAssy h.edit_SFparam_minDspot ...
        h.edit_SFparam_minDedge h.edit_SFres],'Enable','off','String','');
    set([h.popupmenu_SFchannel h.checkbox_SFgaussFit h.checkbox_SFall], ...
        'Enable','off');
elseif meth==4 % Schmied2012
    set(h.edit_SFintThresh, 'String', num2str(p.SF_intRatio(chan)),...
        'TooltipString', ttstr1{meth});
    set(h.edit_SFparam_darkW, 'Enable', 'off');
else
    set(h.edit_SFintThresh, 'String', num2str(p.SF_intThresh(chan)),...
        'TooltipString', sprintf(ttstr1{meth},str_units));
    if meth==5 % twotone
        set(h.edit_SFparam_darkH, 'Enable', 'off');
    end
end

% set spot selection parameters
if p.SF_gaussFit
    set(h.edit_SFparam_w, 'String', num2str(p.SF_w(chan)));
    set(h.edit_SFparam_h, 'String', num2str(p.SF_h(chan)));
    set(h.edit_SFparam_minHWHM, 'String', num2str(p.SF_minHWHM(chan)));
    set(h.edit_SFparam_maxHWHM, 'String', num2str(p.SF_maxHWHM(chan)));
    set(h.edit_SFparam_maxAssy, 'String', num2str(p.SF_maxAssy(chan)));
else
    set([h.edit_SFparam_w h.edit_SFparam_h h.edit_SFparam_minHWHM ...
        h.edit_SFparam_maxHWHM h.edit_SFparam_maxAssy],'Enable','off',...
        'String','');
end

% set results
if isRes
    set(h.edit_SFres, 'String', num2str(size(p.SFres{2,chan},1)), 'Enable', ...
        'inactive', 'BackgroundColor', resClr);
else
    set(h.edit_SFres, 'Enable', 'off', 'String', '');
end
