function pushbutton_updateSim_Callback(obj, evd, h)
% Set fields to proper values
updateFields(h.figure_MASH, 'sim');

if h.param.sim.bgType == 3 % pattern
    p = h.param.sim;
    [ok p] = checkBgPattern(p, h.figure_MASH);
    if ~ok
        return;
    end
    h.param.sim = p;
    guidata(h.figure_MASH, h);
end

updateMov(h.figure_MASH);
updateFields(h.figure_MASH, 'sim');