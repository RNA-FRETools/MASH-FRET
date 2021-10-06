function es = setExpSetFromProj(proj)
% es = setExpSetFromProj(proj)
%
% Gather project's experiment settings and return them organized in one 
% stucture
%
% proj: project's structure
% es: experiment settings structure

es.nChan = proj.nb_channel;
es.chanLabel = proj.labels;
es.nExc = proj.nb_excitations;
es.excWl = proj.excitations; 
es.chanExc = proj.chanExc; 
es.FRETpairs = proj.FRET;
es.Spairs = proj.S;
es.expCond = proj.exp_parameters;
es.frameRate = proj.frame_rate;
es.plotClr = proj.colours;
es.tagNames = proj.molTagNames;
es.tagClr = proj.molTagClr;
% if ~isempty(proj.traj_import_opt)
%     es.impTrajPrm = proj.traj_import_opt;
% end
