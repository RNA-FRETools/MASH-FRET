function pushbutton_simImpCoord_Callback(obj, evd, h_fig)

% Last update by MH, 17.12.2019
% >> modify input & output arguments of impSimCoord according to new
%  definition
%
% update by MH, 6.12.2019
% >> modify first input argument of setSimCoordTable to display coordinates 
%  imported from preset files

if ~iscell(obj)
    [fname, pname, o] = uigetfile({'*.txt', 'ASCII file(*.txt)'; ...
        '*.*', 'All files(*.*)'}, 'Select a coordinates file');
else
    pname = obj{1};
    fname = obj{2};
end

if ~(~isempty(fname) && sum(fname))
    return
end

cd(pname);

% modified by MH, 17.12.2019
% h = guidata(h_fig);
% p = h.param.sim;
% p = impSimCoord(fname, pname, p, h_fig);
% p.matGauss = cell(1,4);
% h.param.sim = p;
% guidata(h_fig, h);
impSimCoord(fname, pname, h_fig);

% added by MH, 17.12.2019
h = guidata(h_fig);

% modified by MH, 6.12.2019
% setSimCoordTable(h.param.sim.coord, h.uitable_simCoord);
setSimCoordTable(h.param.sim, h.uitable_simCoord);

updateFields(h_fig, 'sim');

