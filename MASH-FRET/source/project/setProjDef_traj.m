function proj = setProjDef_traj(proj,h_fig)
% proj = setProjDef_traj(proj,h_fig)
%
% Import trajectories and set default project parameters 
%
% proj: project structure
% h_fig: handle to main figure

% retrieve interface parameters
h = guidata(h_fig);
p = h.param;

% set default project experiment settings
proj.nb_channel = p.es.nChan;
proj.labels = p.es.chanLabel;
proj.nb_excitations = p.es.nExc;
proj.excitations = p.es.excWl;
proj.chanExc = p.es.chanExc;
proj.FRET = p.es.FRETpairs;
proj.S = p.es.Spairs;
proj.exp_parameters = p.es.expCond;
proj.exp_parameters{1,2} = 'trajectories';
proj.colours = p.es.plotClr;
proj.traj_import_opt = p.es.impTrajPrm;
