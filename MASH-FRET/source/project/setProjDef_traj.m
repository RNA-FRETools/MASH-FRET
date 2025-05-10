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
proj.nb_excitations = p.es.nExc;
proj.labels = p.es.chanLabel{p.es.nExc,p.es.nChan};
proj.excitations = p.es.excWl{p.es.nExc,p.es.nChan};
proj.chanExc = p.es.chanExc{p.es.nExc,p.es.nChan};
proj.FRET = p.es.FRETpairs{p.es.nExc,p.es.nChan};
proj.S = p.es.Spairs{p.es.nExc,p.es.nChan};
proj.exp_parameters = p.es.expCond{p.es.nExc,p.es.nChan};
proj.exp_parameters{1,2} = 'trajectories';
proj.colours = p.es.plotClr{p.es.nExc,p.es.nChan};
proj.traj_import_opt = adjustVal(p.es.impTrajPrm{p.es.nExc,p.es.nChan},...
    getDefTrajImpPrm(p.es.nChan,p.es.nExc));
