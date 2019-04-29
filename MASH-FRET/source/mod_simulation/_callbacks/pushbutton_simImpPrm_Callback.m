function pushbutton_simImpPrm_Callback(obj, evd, h)
if ~iscell(obj)
    [fname, pname, o] = uigetfile({'*.mat', 'Matlab file(*.mat)'; ...
        '*.*', 'All files(*.*)'}, 'Select a parameters file');
else
    pname = obj{1};
    fname = obj{2};
end
if ~isempty(fname) && sum(fname)
    cd(pname);
    p = h.param.sim;
    p = impSimPrm(fname, pname, p, h.figure_MASH);
    p.matGauss = cell(1,4);
    h.param.sim = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end