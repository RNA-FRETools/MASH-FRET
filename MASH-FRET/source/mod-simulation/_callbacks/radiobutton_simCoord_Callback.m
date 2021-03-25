function radiobutton_simCoord_Callback(obj,evd,h_fig)

h = guidata(h_fig);

switch obj
    case h.radiobutton_randCoord
        h.radiobutton_simCoordFile.Value = ...
            double(~h.radiobutton_randCoord.Value);

        % clear file data, coordinates and PSF factorization matrix
        h.param.sim.coordFile = [];
        h.param.sim.coord = [];
        h.param.sim.matGauss = cell(1,4);

        % set default to random coordinates
        h.param.sim.genCoord = 1;
        
        % save changes
        guidata(h_fig, h);

    case h.radiobutton_simCoordFile
        h.radiobutton_randCoord.Value = ...
            double(~h.radiobutton_simCoordFile.Value);
        pushbutton_simImpCoord_Callback(h.pushbutton_simImpCoord,[],h_fig);

    otherwise
        disp('radiobutton_simCoord_Callback: unknown object handle.')
        return
end

% set GUI to proper values
updateFields(h_fig, 'sim');

