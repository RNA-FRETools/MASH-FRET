function tooglebutton_TDPmanStart_Callback(obj,evd,h_fig,action)

% get interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

switch action
    case 'close'
        set(h.uipanel_TA_selectTool,'visible','off');
        set(h.tooglebutton_TDPmanStart,'value',0);
        
    case 'open'
        isOn = get(obj,'value');
        switch isOn
            case 0
                set(h.uipanel_TA_selectTool,'visible','off');
            case 1
                ud_selectToolPan(h_fig);
                set(h.uipanel_TA_selectTool,'visible','on');
        end
end