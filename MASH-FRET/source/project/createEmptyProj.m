function p = createEmptyProj(h_fig)
% p = createEmptyProj(h_fig)
%
% Initializes and returns a project structure
%
% h_fig: handle to main figure
% p: project structure

% get default parameters
h = guidata(h_fig);
es = h.param.es;

% project
p.date_creation = datestr(now);
p.date_last_modif = p.date_creation;
figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH-FRET ');
b = a + numel('MASH-FRET ');
p.MASH_version = figname(b:end);
p.proj_file = '';

% experiment settings
p.folderRoot = pwd;
p.nb_channel = 0;
p.labels = {};
p.nb_excitations = 0;
p.excitations = [];
p.chanExc = [];
p.FRET = [];
p.S = [];
p.exp_parameters = es.expCond;
p.frame_rate = 1;
p.colours = {};
p.traj_import_opt = [];

% video
p.movie_file = '';
p.is_movie = false;
p.movie_dim = [];
p.movie_dat = [];
p.aveImg = [];
p.is_coord = false;
p.coord = [];
p.coord_file = '';
p.coord_imp_param = [];
p.pix_intgr = [1,1];

% sample
p.coord_incl = [];
p.molTagNames = es.tagNames;
p.molTag = [];
p.molTagClr = es.tagClr;

% trajectories
p.cnt_p_pix = false;
p.cnt_p_sec = true;
p.intensities = [];
p.intensities_bgCorr = [];
p.intensities_crossCorr = [];
p.intensities_denoise = [];
p.bool_intensities = [];
p.ES = [];
p.intensities_DTA = [];
p.FRET_DTA = [];
p.S_DTA = [];
p.dt = [];

% processing parameters
p.sim = []; % simulation
p.VP = []; % video processing
p.TP = []; % trace processing
p.HA = []; % histogram analysis
p.TA = []; % transition analysis

