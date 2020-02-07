function pushbutton_simImpCoord_Callback(obj, evd, h_fig)

% Last update by MH, 17.12.2019
% >> modify input & output arguments of impSimCoord according to new
%  definition
%
% update by MH, 6.12.2019
% >> modify first input argument of setSimCoordTable to display coordinates 
%  imported from preset files

% get source file
if ~iscell(obj)
    % open browser and ask for file
    [fname, pname, o] = uigetfile({'*.txt', 'ASCII file(*.txt)'; ...
        '*.*', 'All files(*.*)'}, 'Select a coordinates file');
else
    % call from script routine: file is stored in the first input argument
    pname = obj{1};
    fname = obj{2};
    if pname(end)~=filesep
        pname = [pname,filesep];
    end
end
if ~(~isempty(fname) && sum(fname))
    return
end
cd(pname);

% import coordinates from file
impSimCoord(fname, pname, h_fig);

% show potentially new coordinates in table
h = guidata(h_fig);
setSimCoordTable(h.param.sim, h.uitable_simCoord);

% set GUI to proper values
updateFields(h_fig, 'sim');

