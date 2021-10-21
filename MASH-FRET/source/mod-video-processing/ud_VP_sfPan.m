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
p = h.param;

if ~prepPanel(h.uipanel_VP_spotfinder,h)
    return
end

% collect experiemnt settings and processing parameters
proj = p.curr_proj;
expT = p.proj{proj}.frame_rate;
nC = p.proj{proj}.nb_channel;
labels = p.proj{proj}.labels;
curr = p.proj{proj}.VP.curr;
persec = curr.plot{1}(1);
meth = curr.gen_crd{2}{1}(1);
gaussfit = curr.gen_crd{2}{1}(2);
coordsf = curr.gen_crd{2}{4};
sfprm = curr.gen_crd{2}{2};
slctprm = curr.gen_crd{2}{3};

isRes = ~isempty(coordsf);

% set channel
chan = get(h.popupmenu_SFchannel, 'Value');
if chan > nC
    chan = nC;
end
set(h.popupmenu_SFchannel, 'Value', chan, 'String', ...
    getStrPop('chan',{labels,[]}));

% convert intensity to proper units
str_units = 'counts';
if persec
    str_units = strcat(str_units, ' /s');
    sfprm(chan,1) = sfprm(chan,1)/expT;
    slctprm(chan,2) = slctprm(chan,2)/expT;
end

% set method settings
set(h.popupmenu_SF, 'Value', meth);
set(h.checkbox_SFgaussFit, 'Value', gaussfit);

% set spot detection parameters
set(h.edit_SFparam_darkW,'String',num2str(sfprm(chan,3)),'TooltipString',...
    ttstr2{meth});
set(h.edit_SFparam_darkH,'String',num2str(sfprm(chan,4)),'TooltipString',...
    ttstr3{meth});
if meth==1 % none
    set([h.edit_SFintThresh h.edit_SFparam_minI h.edit_SFparam_w ...
        h.edit_SFparam_h h.edit_SFparam_darkW h.edit_SFparam_darkH ...
        h.edit_SFparam_maxN h.edit_SFparam_minHWHM h.edit_SFparam_maxHWHM ...
        h.edit_SFparam_maxAssy h.edit_SFparam_minDspot ...
        h.edit_SFparam_minDedge h.edit_SFres],'Enable','off','String','');
    set([h.popupmenu_SFchannel h.checkbox_SFgaussFit], 'Enable','off');
elseif meth==4 % Schmied2012
    set(h.edit_SFintThresh, 'String', num2str(sfprm(chan,2)),...
        'TooltipString', ttstr1{meth});
    set(h.edit_SFparam_darkW, 'Enable', 'off');
else
    set(h.edit_SFintThresh, 'String', num2str(sfprm(chan,1)),...
        'TooltipString', sprintf(ttstr1{meth},str_units));
    if meth==5 % twotone
        set(h.edit_SFparam_darkH, 'Enable', 'off');
    end
end
set(h.edit_SFparam_minI,'String',num2str(slctprm(chan,2)),'TooltipString',...
    sprintf(ttstr0,str_units));
set(h.edit_SFparam_maxN,'String',num2str(slctprm(chan,1)));
set(h.edit_SFparam_minDspot,'String',num2str(slctprm(chan,6)));
set(h.edit_SFparam_minDedge,'String',num2str(slctprm(chan,7)));

% set spot selection parameters
if gaussfit
    set(h.edit_SFparam_w, 'String', num2str(sfprm(chan,5)));
    set(h.edit_SFparam_h, 'String', num2str(sfprm(chan,6)));
    set(h.edit_SFparam_minHWHM, 'String', num2str(slctprm(chan,3)));
    set(h.edit_SFparam_maxHWHM, 'String', num2str(slctprm(chan,4)));
    set(h.edit_SFparam_maxAssy, 'String', num2str(slctprm(chan,5)));
else
    set([h.edit_SFparam_w h.edit_SFparam_h h.edit_SFparam_minHWHM ...
        h.edit_SFparam_maxHWHM h.edit_SFparam_maxAssy],'Enable','off',...
        'String','');
end

% set results
if isRes
    set(h.edit_SFres,'String',num2str(size(coordsf{chan},1)),'Enable', ...
        'inactive','BackgroundColor',resClr);
else
    set(h.edit_SFres, 'Enable', 'off', 'String', '');
end
