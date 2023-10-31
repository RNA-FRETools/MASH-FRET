function isOn = prepPanel(h_pan,h)
% isOn = prepPanel(h_pan,h)
%
% Adjust control visibilities & enablilities and reset edit field 
% background colors of input panel regarding if the panel is 
% collapsed/expended, the project list is populated/empty, and the parent 
% module is available/unavailable for use.
%
% h_pan: handle to panel
% h: main figure guidata structure

% default
isOn = false;

% make elements disabled and invisible if module is unavailable
p = h.param;
prnt = get(h_pan,'parent');
while prnt~=h.figure_MASH
    if ~any([h.uipanel_S,h.uipanel_VP,h.uipanel_TP,h.uipanel_HA,...
            h.uipanel_TA,h.uipanel_S_scroll,h.uipanel_VP_scroll,...
            h.uipanel_TP_scroll,h.uipanel_HA_scroll,...
            h.uipanel_TA_scroll]==prnt)
        prnt = get(prnt,'parent');
        continue
    end
    switch prnt
        case {h.uipanel_S_scroll,h.uipanel_S}
            mod = 'sim';
        case {h.uipanel_VP_scroll,h.uipanel_VP}
            mod = 'VP';
        case {h.uipanel_TP_scroll,h.uipanel_TP}
            mod = 'TP';
        case {h.uipanel_HA_scroll,h.uipanel_HA}
            mod = 'HA';
        case {h.uipanel_TA_scroll,h.uipanel_TA}
            mod = 'TA';
    end
    if ~isModuleOn(p,mod)
        setProp(get(h_pan,'children'),'visible','off','enable','off');
        return
    end
    break
end

% make elements invisible if panel is collapsed
if isPanelOpen(h_pan)==2
    setProp(get(h_pan,'children'),'visible','off');
    return
else
    setProp(get(h_pan,'children'),'visible','on');
end

% enable all panel elements
setProp(get(h_pan,'children'),'enable','on');

% reset edit fields background color
setProp(get(h_pan,'children'),'backgroundcolor',[1,1,1],'style','edit');

isOn = true;

