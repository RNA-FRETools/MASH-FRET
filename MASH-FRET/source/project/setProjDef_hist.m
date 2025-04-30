function proj = setProjDef_hist(proj,p)
% proj = setProjDef_hist(proj,h_fig)
%
% Import histograms and set default project parameters 
%
% proj: project structure
% p: interface parameters structure

% defaults
nChan = 1;
nExc = 1;
projttl = 'histogram';

% set default project experiment settings
proj.nb_channel = nChan;
proj.labels = {'data'};
proj.nb_excitations = nExc;
proj.excitations = p.es.excWl{nExc,nChan};
proj.chanExc = p.es.excWl{nExc,nChan};
proj.FRET = [];
proj.S = [];
proj.exp_parameters = p.es.expCond{nExc,nChan};
proj.exp_parameters{1,2} = projttl;
proj.colours = p.es.plotClr{nExc,nChan};
proj.traj_import_opt = p.es.impTrajPrm{nExc,nChan};
proj.hist_import_opt = p.es.impHistPrm;

% set video parameters
proj.spltime_from_video = false;
