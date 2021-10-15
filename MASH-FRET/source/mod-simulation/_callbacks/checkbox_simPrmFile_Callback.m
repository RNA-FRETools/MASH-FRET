function checkbox_simPrmFile_Callback(obj,evd,h_fig)

switch obj.Value
    case 0
        % erase presets
        resetSimPrm(h_fig);
        
    case 1
        % ask user for presets file
        h = guidata(h_fig);
        pushbutton_simImpPrm_Callback(h.pushbutton_simImpPrm,[],h_fig);
        
    otherwise
        disp('checkbox_simPrmFile_Callback: unknown object value.');
        return
end

% refresh all Simulation panels
updateFields(h_fig, 'sim');