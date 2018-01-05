function s = intAscii2mash2(pname, fname, p, h_fig)

movname = []; movdim = []; movdat = {}; rate = 1; nChan = 1; nExc = 1;
wl = round(532*(1+0.2*(0:nExc-1))); labels = {}; chanExc = [];
coord = []; coordfile = []; coordprm = [];
intensities = []; FRETprm = []; Sprm = []; intensities_DTA = [];
FRET_DTA = []; S_DTA = []; bool_intensities = [];

%% intensity data
% p{1}{1}(1) = is time
% p{1}{1}(2) = time column
% p{1}{1}(3) = channel nb.
% p{1}{1}(4) = excitation nb.
% p{1}{1}(5) = starting row
% p{1}{1}(6) = ending row
% p{1}{1}(7) = starting column
% p{1}{1}(8) = ending column
% p{1}{1}(9) = is discr. intensities
% p{1}{1}(10) = discr. intensities column
% p{1}{2} = {1-by-nChan} channel labels
% p{1}{3} = [1-by-nExc] excitation wavelength
% p{1}{4} = [1-by-nChan] channel order

%% coordinates data
% p{2}{1}(1) = from external file
% p{2}{1}(2) = in trace file
% p{2}{1}(3) = file row
% p{2}{1}(4) = movie width
% p{2}{2} = coordinates file

%% movie data
% p{3}{1} = is movie file
% p{3}{2} = movie file

%% channel data
% p{4}

%% S data
% p{5}

% project
s.date_creation = datestr(now);
s.date_last_modif = datestr(now);
figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH smFRET ');
b = a + numel('MASH smFRET ');
s.MASH_version = figname(b:end);
s.proj_file = fname;

% movie
s.movie_file = movname; % movie path/file
s.is_movie = ~isempty(movname);
s.movie_dim = movdim;
s.movie_dat = movdat;

s.frame_rate = rate;
s.frame_rate(s.frame_rate<=0) = 1;

s.nb_channel = nChan; % nb of channel
s.nb_channel = ceil(abs(s.nb_channel));
s.nb_channel(s.nb_channel==0) = 1;

s.nb_excitations = nExc;
s.nb_excitations = ceil(abs(s.nb_excitations));
s.nb_excitations(s.nb_excitations==0) = 1;
s.excitations = wl;

[o,name,o] = fileparts(fname);
p_exp = {'Movie name' name ''
         'Molecule name' '' ''
         '[Mg2+]' [] 'mM'
         '[K+]' [] 'mM'};
for i = 1:s.nb_excitations
    p_exp{size(p_exp,1)+1,1} = ['Power(' ...
        num2str(round(s.excitations(i))) 'nm)'];
    p_exp{size(p_exp,1),2} = '';
    p_exp{size(p_exp,1),3} = 'mW';
end
s.exp_parameters = p_exp;
s.labels = labels;
s.chanExc = chanExc;

% coordinates
s.coord = coord;
s.coord_file = coordfile;
s.coord_imp_param = coordprm;
s.is_coord = ~isempty(s.coord);
s.coord_incl = true(1,size(intensities,2)/s.nb_channel);

% intensity integration
s.pix_intgr = [1 1];
s.cnt_p_pix = 1;
s.cnt_p_sec = 0;

% intensity-time traces processing
s.intensities = intensities;
s.FRET = FRETprm;
s.S = Sprm;
s.intensities_bgCorr = intensities;
s.intensities_crossCorr = intensities;
s.intensities_denoise = intensities;
s.intensities_DTA = intensities_DTA;
s.FRET_DTA = FRET_DTA;
s.S_DTA = S_DTA;
s.bool_intensities = bool_intensities;
s.colours = getDefTrClr(s.nb_excitations, s.excitations, s.nb_channel, ...
    size(s.FRET,1), size(s.S,1));

% dwell-times
s.dt_ascii = false;
s.dt_pname = [];
s.dt_fname = [];
s.dt = [];

