function pushbutton_simRemCoord_Callback(obj, evd, h_fig)
h = guidata(h_fig);
h.param.sim.coord = [];
h.param.sim.coordFile = [];
h.param.sim.genCoord = 1;
h.param.sim.matGauss = cell(1,4);
guidata(h_fig, h);

setSimCoordTable(h.param.sim.coord, h.uitable_simCoord);

updateFields(h_fig, 'sim');