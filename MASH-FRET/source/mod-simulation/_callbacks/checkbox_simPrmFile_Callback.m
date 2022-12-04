function checkbox_simPrmFile_Callback(obj,evd,h_fig)

switch obj.Value
    case 0
        % erase presets
        resetSimPrm(h_fig);
        
    case 1
        % ask user for presets file
        h = guidata(h_fig);
        if ~iscell(evd)
            evd = h.pushbutton_simImpPrm;
        end
        pushbutton_simImpPrm_Callback(evd,[],h_fig);
        
    otherwise
        disp('checkbox_simPrmFile_Callback: unknown object value.');
        return
end

% refresh all Simulation panels
updateFields(h_fig, 'sim');