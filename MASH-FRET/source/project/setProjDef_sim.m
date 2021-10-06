function proj = setProjDef_sim(proj,p)
% proj = setProjDef_sim(proj)
%
% Set default project parameters when starting with simulation
%
% proj: project structure
% p: interface parameters structure

% defaults
nChan = 2;
lbl = {'don','acc'};
nExc = 1;
exc = 500;
chanExc = [500,0];
FRET = [1,2];
S = [];
expCond = {'Title','simulation',''};

% set project parameters
proj.nb_channel = nChan;
proj.labels = lbl;
proj.nb_excitations = nExc;
proj.excitations = exc;
proj.chanExc = chanExc;
proj.FRET = FRET;
proj.S = S;
proj.exp_parameters = expCond;
proj.colours = getDefTrClr(nExc,exc,nChan,size(FRET,1),size(S,1));

% set processing parameters
proj.sim = setDefPrm_sim(p);
