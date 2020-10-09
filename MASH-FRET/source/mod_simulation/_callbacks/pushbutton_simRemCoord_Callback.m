function pushbutton_simRemCoord_Callback(obj, evd, h_fig)

% Last update by MH, 6.12.2019
% >> modify first input argument of setSimCoordTable to display coordinates 
%  imported from preset files

% collect parameters
h = guidata(h_fig);

% clear file data, coordinates and PSF factorization matrix
h.param.sim.coordFile = [];
h.param.sim.coord = [];
h.param.sim.matGauss = cell(1,4);

% set default to random coordinates
h.param.sim.genCoord = 1;

% save changes
guidata(h_fig, h);

% clear coordinates table
setSimCoordTable(h.param.sim, h.uitable_simCoord);

% set GUI to proper values
updateFields(h_fig, 'sim');
