function radiobutton_simCoord_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
curr = p.proj{proj}.sim.curr;

switch obj
    case h.radiobutton_randCoord
        h.radiobutton_simCoordFile.Value = ...
            double(~h.radiobutton_randCoord.Value);

        % clear file data, coordinates and PSF factorization matrix
        curr.gen_dat{1}{1}{2} = [];
        curr.gen_dat{1}{1}{3} = '';
        curr.gen_dat{6}{3} = cell(1,4);

        % set default to random coordinates
        curr.gen_dat{1}{1}{1} = 1;
        
        % save changes
        p.proj{proj}.sim.curr = curr;
        h.param = p;
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

