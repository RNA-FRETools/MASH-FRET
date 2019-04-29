function pushbutton_simImpCoord_Callback(obj, evd, h)
if ~iscell(obj)
    [fname, pname, o] = uigetfile({'*.txt', 'ASCII file(*.txt)'; ...
        '*.*', 'All files(*.*)'}, 'Select a coordinates file');
else
    pname = obj{1};
    fname = obj{2};
end
if ~isempty(fname) && sum(fname)
    cd(pname);
    p = h.param.sim;
    p = impSimCoord(fname, pname, p, h.figure_MASH);
    p.matGauss = cell(1,4);
    h.param.sim = p;
    guidata(h.figure_MASH, h);

    setSimCoordTable(h.param.sim.coord, h.uitable_simCoord);

    updateFields(h.figure_MASH, 'sim');
end