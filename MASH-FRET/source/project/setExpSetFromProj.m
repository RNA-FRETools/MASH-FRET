function es = setExpSetFromProj(es,proj)
% es = setExpSetFromProj(es,proj)
%
% Gather project's experiment settings and return them organized in one 
% stucture
%
% es: experiment settings structure
% proj: project's structure

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
if isfield(proj,'traj_import_opt') && ~isempty(proj.traj_import_opt)
    es.impTrajPrm{1} = proj.traj_import_opt{1};
end
if isfield(proj,'hist_import_opt') && ~isempty(proj.hist_import_opt)
    es.impHistPrm = proj.hist_import_opt;
end
