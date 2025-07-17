function proj = setProjDef_vid(proj,p)
% proj = setProjDef_vid(proj,p)
%
% Import video and set default project parameters 
%
% proj: project structure
% p: interface parameters structure

% set default project experiment settings
proj.nb_channel = p.es.nChan;
proj.nb_excitations = p.es.nExc;
proj.labels = p.es.chanLabel{p.es.nExc,p.es.nChan};
proj.excitations = p.es.excWl{p.es.nExc,p.es.nChan};
proj.chanExc = p.es.chanExc{p.es.nExc,p.es.nChan};
proj.FRET = p.es.FRETpairs{p.es.nExc,p.es.nChan};
proj.S = p.es.Spairs{p.es.nExc,p.es.nChan};
proj.exp_parameters = p.es.expCond{p.es.nExc,p.es.nChan};
proj.exp_parameters{1,2} = 'video';
proj.colours = p.es.plotClr{p.es.nExc,p.es.nChan};
