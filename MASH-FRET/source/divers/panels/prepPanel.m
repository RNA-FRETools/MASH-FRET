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

% make elements invisible if panel is collapsed
if isPanelOpen(h_pan)==2
    setProp(get(h_pan,'children'),'visible','off');
    return
else
    setProp(get(h_pan,'children'),'visible','on');
end

% disable elements if project list is empty
p = h.param;
if isempty(p.proj)
    setProp(get(h_pan,'children'),'enable','off');
    return
end

% disable elements if module is unavailable
proj = p.curr_proj;
prnt = get(h_pan,'parent');
while prnt~=h.figure_MASH
    if ~any([h.uipanel_S,h.uipanel_VP,h.uipanel_TP,h.uipanel_HA,...
            h.uipanel_TA]==prnt)
        prnt = get(prnt,'parent');
        continue
    end
    switch prnt
        case h.uipanel_S
            pmod = p.proj{proj}.sim;
        case h.uipanel_VP
            pmod = p.proj{proj}.VP;
        case h.uipanel_TP
            pmod = p.proj{proj}.TP;
        case h.uipanel_HA
            pmod = p.proj{proj}.HA;
        case h.uipanel_TA
            pmod = p.proj{proj}.TA;
    end
    if isempty(pmod)
        setProp(get(h_pan,'children'),'enable','off');
        return
    end
    break
end

% enable all panel elements
setProp(get(h_pan,'children'),'enable','on');

% reset edit fields background color
setProp(get(h_pan,'children'),'backgroundcolor',[1,1,1],'style','edit');

isOn = true;

