function pushbutton_simImpPrm_Callback(obj, evd, h_fig)

% Last update by MH, 12.12.2019:
% >> show coordinates after loading pre-sets

if ~iscell(obj)
    [fname, pname, o] = uigetfile({'*.mat', 'Matlab file(*.mat)'; ...
        '*.*', 'All files(*.*)'}, 'Select a parameters file');
else
    pname = obj{1};
    fname = obj{2};
end
if ~isempty(fname) && sum(fname)
    cd(pname);
    h = guidata(h_fig);
    p = h.param.sim;
    p = impSimPrm(fname, pname, p, h_fig);
    p.matGauss = cell(1,4);
    h.param.sim = p;
    guidata(h_fig, h);
    
    setSimCoordTable(h.param.sim,h.uitable_simCoord);
    
    updateFields(h_fig, 'sim');
end