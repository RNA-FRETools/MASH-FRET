function pushbutton_simImpCoord_Callback(obj, evd, h_fig)
if ~iscell(obj)
    [fname, pname, o] = uigetfile({'*.txt', 'ASCII file(*.txt)'; ...
        '*.*', 'All files(*.*)'}, 'Select a coordinates file');
else
    pname = obj{1};
    fname = obj{2};
end
if ~isempty(fname) && sum(fname)
    cd(pname);
    h = guidata(h_fig);
    p = h.param.sim;
    p = impSimCoord(fname, pname, p, h_fig);
    p.matGauss = cell(1,4);
    h.param.sim = p;
    guidata(h_fig, h);

    setSimCoordTable(h.param.sim.coord, h.uitable_simCoord);

    updateFields(h_fig, 'sim');
end