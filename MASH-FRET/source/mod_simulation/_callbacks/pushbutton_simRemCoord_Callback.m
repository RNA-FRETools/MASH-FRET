function pushbutton_simRemCoord_Callback(obj, evd, h_fig)
% Last update by MH, 6.12.2019
% >> modify first input argument of setSimCoordTable to display coordinates 
%  imported from preset files

h = guidata(h_fig);

h.param.sim.coord = [];
h.param.sim.coordFile = [];
h.param.sim.genCoord = 1;
h.param.sim.matGauss = cell(1,4);
guidata(h_fig, h);

% modified by MH, 6.12.2019
% setSimCoordTable(h.param.sim.coord, h.uitable_simCoord);
setSimCoordTable(h.param.sim, h.uitable_simCoord);

updateFields(h_fig, 'sim');