function s = checkField(s_in, fname, h_fig)

% Last update: by MH, 3.4.2019
% >> if labels are empty (ASCII import), set default labels

s = s_in;

%% load data

% project
s.date_creation = adjustParam('date_creation', datestr(now), s_in);
s.date_last_modif = adjustParam('date_last_modif', s.date_creation, s_in);
figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH-FRET ');
b = a + numel('MASH-FRET ');
s.MASH_version = adjustParam('MASH_version', figname(b:end), s_in);
s.proj_file = fname;

% movie
s.movie_file = adjustParam('movie_file', [], s_in); % movie path/file
s.is_movie = adjustParam('is_movie', ~isempty(s.movie_file), s_in);
s.movie_dim = adjustParam('movie_dim', [], s_in);
s.movie_dat = adjustParam('movie_dat', [], s_in);

s.frame_rate = adjustParam('frame_rate', 1, s_in);
s.frame_rate(s.frame_rate<=0) = 1;

s.nb_channel = adjustParam('nb_channel', 1, s_in); % nb of channel
s.nb_channel = ceil(abs(s.nb_channel));
s.nb_channel(s.nb_channel==0) = 1;

s.nb_excitations = adjustParam('nb_excitations', 1, s_in);
s.nb_excitations = ceil(abs(s.nb_excitations));
s.nb_excitations(s.nb_excitations==0) = 1;

s.excitations = adjustParam('excitations', ...
    round(532*(1 + 0.2*(0:s.nb_excitations-1))), s_in);
s.exp_parameters = adjustParam('exp_parameters', [], s_in);
s.labels = adjustParam('labels', {}, s_in);
s.chanExc = adjustParam('chanExc', {}, s_in);

% coordinates
s.coord = adjustParam('coord', [], s_in);
s.coord_file = adjustParam('coord_file', [], s_in);
s.coord_imp_param = adjustParam('coord_imp_param', {[1 2] 1}, s_in);
s.is_coord = adjustParam('is_coord', ~isempty(s.coord), s_in);
s.coord_incl = adjustParam('coord_incl', [], s_in);

% intensity integration
s.pix_intgr = adjustParam('pix_intgr', [1 1], s_in);
s.cnt_p_pix = adjustParam('cnt_p_pix', 1, s_in);
s.cnt_p_sec = adjustParam('cnt_p_sec', 0, s_in);

% intensity-time traces processing
nFrames = 4000;
s.intensities = adjustParam('intensities', nan(nFrames, ...
    size(s.coord,1)*s.nb_channel, s.nb_excitations), s_in);
s.FRET = adjustParam('FRET', [], s_in);
s.S = adjustParam('S', [], s_in);
s.intensities_bgCorr = adjustParam('intensities_bgCorr', ...
    nan(size(s.intensities)), s_in);
s.intensities_crossCorr = adjustParam('intensities_crossCorr', ...
    nan(size(s.intensities)), s_in);
s.intensities_denoise = adjustParam('intensities_denoise', ...
    nan(size(s.intensities)), s_in);
s.intensities_DTA = adjustParam('intensities_DTA', ...
    nan(size(s.intensities)), s_in);
s.FRET_DTA = adjustParam('FRET_DTA', nan(size(s.intensities,1), ...
    size(s.intensities,2)*size(s.FRET,1)/s.nb_channel), s_in);
s.S_DTA = adjustParam('S_DTA', nan(size(s.intensities,1), ...
    size(s.intensities,2)*size(s.S,1)/s.nb_channel), s_in);
s.bool_intensities = adjustParam('bool_intensities', ...
    true(size(s.intensities,1), size(s.intensities,2)/s.nb_channel), s_in);
s.colours = adjustParam('colours', [], s_in); % plot colours

% dwell-times: in construction (fields not used)
s.dt_ascii = adjustParam('dt_ascii', false, s_in);
s.dt_pname = adjustParam('dt_pname', [], s_in);
s.dt_fname = adjustParam('dt_fname', [], s_in);
s.dt = adjustParam('dt', {}, s_in);

% molecule tags; added by FS, 24.4.2018
s.molTag = adjustParam('molTag', ones(1,size(s.intensities,2)/s.nb_channel), s_in);
s.molTagNames = adjustParam('molTagNames', {'unlabeled', 'static', 'dynamic'}, s_in);

%% check movie entries

% check movie file >> set movie dimensions and reading infos
if ~isempty(s.movie_file) && exist(s.movie_file, 'file')
    s.is_movie = 1;
    
elseif ~isempty(s.movie_file)
    [o,name_proj,ext] = fileparts(fname);
    name_proj = [name_proj ext];
    load_mov = questdlg({['Impossible to find the movie file for ' ...
        'project "' name_proj '".'] 'Load the movie manually?'}, ...
        'Unkown movie file', 'Browse', 'Continue without movie', ...
        'Browse');
    disp(['No movie file for project: ' name_proj]);
    if strcmp(load_mov, 'Browse')
        [fname,pname,o] = uigetfile({ ...
            '*.sif;*.sira;*.tif;*.gif;*.png;*.spe;*.pma', ...
            ['Supported Graphic File Format' ...
            '(*.sif,*.sira,*.tif,*.gif,*.png,*.spe,*.pma)']; ...
            '*.*', 'All File Format(*.*)'}, 'Select a graphic file:');
        if ~(~isempty(fname) && sum(fname))
            s = [];
            return;
        end
        [data ok] = getFrames([pname fname], 1, {}, h_fig);
        if ok
            s.movie_file = [pname fname];
            s.is_movie = 1;
            s.movie_dim = [data.pixelX data.pixelY];
            s.movie_dat = {data.fCurs [data.pixelX data.pixelY] ...
                data.frameLen};
            disp(['Loading movie: ' fname 'from path: ' pname]);
        end
        
    elseif strcmp(load_mov, 'Continue without movie')
        s.movie_file = [];
        s.is_movie = 0;
    else
        s = [];
        return;
    end
else
    s.is_movie = 0;
    s.movie_dat = [];
end

% set movie dimensions if movie exists >> set movie reading infos
if (isempty(s.movie_dim) || size(s.movie_dim, 2) ~= 2) && s.is_movie
    [data ok] = getFrames(s.movie_file, 1, {}, h_fig);
    if ~ok
        return;
    end
    s.movie_dim = [data.pixelX data.pixelY];
    s.movie_dat = {data.fCurs [data.pixelX data.pixelY] data.frameLen};
end

% set movie reading infos if movie exists
if (isempty(s.movie_dat) || size(s.movie_dat, 2) ~= 3) && s.is_movie
    [data ok] = getFrames(s.movie_file, 1, {}, h_fig);
    if ~ok
        return;
    end
    s.movie_dat = {data.fCurs [data.pixelX data.pixelY] data.frameLen};
end

if isempty(s.labels) || size(s.labels,2) < s.nb_channel
    h = guidata(h_fig);
    label_def = h.param.movPr.labels_def;
    for c = 1:s.nb_channel
        if c>numel(s.labels) || (c<=numel(s.labels) && ...
                ~isempty(s.labels{c}))
            if c<=numel(label_def)
                s.labels{c} = label_def{c};
            else
                s.labels{c} = cat(2,'chan ',num2str(c));
            end
        end
    end
end

if isempty(s.chanExc) || size(s.chanExc,2) < s.nb_channel
    s.chanExc = zeros(1,s.nb_channel);
    for c = 1:s.nb_channel
        if ~isempty(s.FRET) && size(s.FRET,2)==3
            [r,o,o] = find(s.FRET(:,1)==c);
            if ~isempty(r)
                s.chanExc(c) = s.excitations(s.FRET(r(1),3));
            elseif c <= s.nb_excitations
                s.chanExc(c) = s.excitations(c);
            end
        elseif c <= s.nb_excitations
            s.chanExc(c) = s.excitations(c);
        end
    end
end

if isempty(s.exp_parameters) || size(s.exp_parameters,2) ~= 3
    s.exp_parameters = {'Project title' '' ''
                        'Molecule name' '' ''
                        '[Mg2+]' [] 'mM'
                        '[K+]' [] 'mM'};
    for i = 1:s.nb_excitations
        s.exp_parameters{size(s.exp_parameters,1)+1,1} = ['Power(' ...
            num2str(round(p.excitations(i))) 'nm)'];
        s.exp_parameters{size(s.exp_parameters,1),2} = '';
        s.exp_parameters{size(s.exp_parameters,1),3} = 'mW';
    end
end


%% coordinates
if s.is_coord
    if size(s.coord_incl,2) < size(s.coord,1)
        s.coord_incl((size(s.coord_incl,2)+1):size(s.coord,1)) = ...
            true(1,(size(s.coord,1)-size(s.coord_incl,2)));
    end
end

if isempty(s.coord_incl)
    nMol = size(s.intensities,2)/s.nb_channel;
    s.coord_incl = true(1,nMol);
end


%% check intensity-time traces processing entries

if size(s.FRET,2) > 2
    s.FRET = s.FRET(:,1:2);
end
if size(s.S,2) > 1
    don_exc = s.S(:,1)';
    exc = s.excitations(don_exc);
    [o,don_chan,o] = find(s.chanExc==exc);
    s.S = don_chan';
end

if isempty(s.colours) || size(s.colours,2) ~=3
    s.colours = getDefTrClr(s.nb_excitations, s.excitations, ...
        s.nb_channel, size(s.FRET,1), size(s.S,1));
end

if isfield(s, 'prm')
    s.prmTT = s.prm;
    s = rmfield(s, 'prm');
end

if isfield(s, 'exp')
    s.expTT = s.exp;
    s = rmfield(s, 'exp');
end


%% check dwell-times entries

if ~s.dt_ascii;
    s.dt_pname = [];
    s.dt_fname = [];
end

nMol = size(s.coord_incl,2);
nChan = s.nb_channel;
nExc = s.nb_excitations;
nFRET = size(s.FRET,1);
nS = size(s.S,1);
perSec = s.cnt_p_sec;
perPix = s.cnt_p_pix;


s.dt = cell(nMol, nChan*nExc+nFRET+nS);
for m = 1:nMol
    incl = s.bool_intensities(:,m);
    j = 1;
    for i_l = 1:s.nb_excitations
        for i_c = 1:s.nb_channel
            I = s.intensities_DTA( ...
                incl,(m-1)*s.nb_channel+i_c,i_l);
            if perSec
                I = I/s.frame_rate;
            end
            if perPix
                I = I/s.pix_intgr(2);
            end
            if sum(double(~isnan(I)))
                s.dt{m,j} = getDtFromDiscr(I, s.frame_rate);
            else
                s.dt{m,j} = [];
            end
            j = j + 1;
        end
    end
    for i_f = 1:size(s.FRET,1)
        tr = s.FRET_DTA(incl,(m-1)*nFRET+i_f);
        if sum(double(~isnan(tr)))
            s.dt{m,j} = getDtFromDiscr(tr, s.frame_rate);
        else
            s.dt{m,j} = {};
        end
        j = j + 1;
    end
    for i_s = 1:size(s.S,1)
        tr = s.S_DTA(incl,(m-1)*nS+i_s);
        if sum(double(~isnan(tr)))
            s.dt{m,j} = getDtFromDiscr(tr, s.frame_rate);
        else
            s.dt{m,j} = {};
        end
        j = j + 1;
    end
end



