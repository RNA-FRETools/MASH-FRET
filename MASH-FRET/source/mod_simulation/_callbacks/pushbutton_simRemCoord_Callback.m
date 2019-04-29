function pushbutton_simRemCoord_Callback(obj, evd, h)
h.param.sim.coord = [];
h.param.sim.coordFile = [];
h.param.sim.genCoord = 1;
h.param.sim.matGauss = cell(1,4);
guidata(h.figure_MASH, h);

setSimCoordTable(h.param.sim.coord, h.uitable_simCoord);

updateFields(h.figure_MASH, 'sim');