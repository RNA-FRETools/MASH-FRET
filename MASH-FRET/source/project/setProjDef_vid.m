function proj = setProjDef_vid(proj,p)
% proj = setProjDef_vid(proj,p)
%
% Import video and set default project parameters 
%
% proj: project structure
% p: interface parameters structure

% set default project experiment settings
proj.nb_channel = p.es.nChan;
proj.labels = p.es.chanLabel;
proj.nb_excitations = p.es.nExc;
proj.excitations = p.es.excWl;
proj.chanExc = p.es.chanExc;
proj.FRET = p.es.FRETpairs;
proj.S = p.es.Spairs;
proj.exp_parameters = p.es.expCond;
proj.exp_parameters{1,2} = 'video';
proj.colours = p.es.plotClr;
