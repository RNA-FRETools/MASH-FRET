function pushbutton_updateSim_Callback(obj, evd, h_fig)

h = guidata(h_fig);

% Set fields to proper values
updateFields(h_fig, 'sim');

if h.param.sim.bgType == 3 % pattern
    p = h.param.sim;
    [ok p] = checkBgPattern(p, h_fig);
    if ~ok
        return;
    end
    h.param.sim = p;
    guidata(h_fig, h);
end

updateMov(h_fig);
updateFields(h_fig, 'sim');