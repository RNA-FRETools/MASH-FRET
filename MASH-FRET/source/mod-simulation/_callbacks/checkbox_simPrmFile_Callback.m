function checkbox_simPrmFile_Callback(obj,evd,h_fig)

switch obj.Value
    case 0
        resetSimPrm(h_fig);
        
    case 1
        h = guidata(h_fig);
        pushbutton_simImpPrm_Callback(h.pushbutton_simImpPrm,[],h_fig);
        
    otherwise
        disp('checkbox_simPrmFile_Callback: unknown object value.');
        return
end

% set GUI to proper values
updateFields(h_fig, 'sim');