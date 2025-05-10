function es = setExpSetFromProj(es,proj)
% es = setExpSetFromProj(es,proj)
%
% Gather project's experiment settings and return them organized in one 
% stucture
%
% es: experiment settings structure
% proj: project's structure

es.nChan = proj.nb_channel;
es.nExc = proj.nb_excitations;
es.splt = proj.sampling_time;
es.tagNames = proj.molTagNames;
es.tagClr = proj.molTagClr;

es.chanLabel = adjustcellsize(es.chanLabel,es.nExc,es.nChan);
es.excWl = adjustcellsize(es.excWl,es.nExc,es.nChan);
es.chanExc = adjustcellsize(es.chanExc,es.nExc,es.nChan);
es.FRETpairs = adjustcellsize(es.FRETpairs,es.nExc,es.nChan);
es.Spairs = adjustcellsize(es.Spairs,es.nExc,es.nChan);
es.expCond = adjustcellsize(es.expCond,es.nExc,es.nChan);
es.plotClr = adjustcellsize(es.plotClr,es.nExc,es.nChan);
es.impTrajPrm = adjustcellsize(es.impTrajPrm,es.nExc,es.nChan);

es.chanLabel{es.nExc,es.nChan} = proj.labels;
es.excWl{es.nExc,es.nChan} = proj.excitations; 
es.chanExc{es.nExc,es.nChan} = proj.chanExc; 
es.FRETpairs{es.nExc,es.nChan} = proj.FRET;
es.Spairs{es.nExc,es.nChan} = proj.S;
es.expCond{es.nExc,es.nChan} = proj.exp_parameters;
es.plotClr{es.nExc,es.nChan} = proj.colours;
if isfield(proj,'traj_import_opt') && ~isempty(proj.traj_import_opt)
    es.impTrajPrm{es.nExc,es.nChan} = adjustVal(...
        es.impTrajPrm{es.nExc,es.nChan},...
        getDefTrajImpPrm(es.nChan,es.nExc));
    es.impTrajPrm{es.nExc,es.nChan}{1} = proj.traj_import_opt{1};
    es.impTrajPrm{es.nExc,es.nChan}{3}{3}{1} = ...
        proj.traj_import_opt{3}{3}{1};
end
if isfield(proj,'hist_import_opt') && ~isempty(proj.hist_import_opt)
    es.impHistPrm = proj.hist_import_opt;
end
