function s = checkField(s_in, fname, h_fig)

%%
% update by MH, 11.1.2020: add "ES" field
% update by MH, 7.1.2020: correct frame rate for dwell-time calculations when using ALEX data
% update by MH, 25.4.2019: (1) correct random generation of tag colors, (2) fetch default tag names and colors in interface's default parameters (default_param.ini)
% update by MH, 24.4.2019: (1) modify molecule tag names by removing label 'unlabelled', (2) modify molecule tag structure to allow multiple tags per molecule, by using the first dimension for molecule idexes and the second dimension for label indexes, (3) add tag's default colors to project, (4) adjust tags from older projects to new format
% update by MH, 3.4.2019: if labels are empty (ASCII import), set default labels
%%

s = s_in;

% added by MH, 25.4.2019
h = guidata(h_fig);
p = h.param;

%% load data

% project
s.date_creation = adjustParam('date_creation', datestr(now), s_in);
s.date_last_modif = adjustParam('date_last_modif', s.date_creation, s_in);
figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH-FRET ');
b = a + numel('MASH-FRET ');
s.MASH_version = adjustParam('MASH_version', figname(b:end), s_in);
s.proj_file = fname;
% s.uptodate = adjustParam('uptodate', initUptodateArr, s_in);

% movie
s.movie_file = adjustParam('movie_file', [], s_in); % movie path/file
s.is_movie = adjustParam('is_movie', ~isempty(s.movie_file), s_in);
s.movie_dim = adjustParam('movie_dim', [], s_in);
s.movie_dat = adjustParam('movie_dat', [], s_in);
s.spltime_from_video = adjustParam('spltime_from_video',s.is_movie,s_in);
s.aveImg = adjustParam('aveImg',[],s_in);

s.frame_rate = adjustParam('frame_rate', 1, s_in);
s.frame_rate(s.frame_rate<=0) = 1;

s.nb_channel = adjustParam('nb_channel', 1, s_in); % nb of channel
s.nb_channel = ceil(abs(s.nb_channel));
s.nb_channel(s.nb_channel==0) = 1;
nChan = s.nb_channel;

s.nb_excitations = adjustParam('nb_excitations', 1, s_in);
s.nb_excitations = ceil(abs(s.nb_excitations));
s.nb_excitations(s.nb_excitations==0) = 1;
nExc = s.nb_excitations;

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

% units
s.cnt_p_sec = adjustParam('cnt_p_sec', 0, s_in);
s.time_in_sec = adjustParam('time_in_sec', 0, s_in);

% intensity-time traces processing
s.intensities = adjustParam('intensities', nan(4000, ...
    size(s.coord,1)*s.nb_channel, s.nb_excitations), s_in);
L = size(s.intensities,1);
nMol = size(s.intensities,2)/nChan;
s.FRET = adjustParam('FRET', [], s_in);
nFRET = size(s.FRET,1);
s.S = adjustParam('S', [], s_in);
nS = size(s.S,1);
s.intensities_bgCorr = adjustParam('intensities_bgCorr',nan(L,nMol*nChan), ...
    s_in);
s.intensities_crossCorr = adjustParam('intensities_crossCorr', ...
    nan(L,nMol*nChan), s_in);
s.intensities_denoise = adjustParam('intensities_denoise', ...
    nan(L,nMol*nChan), s_in);
if nFRET>0
    defES = cell(1,nFRET);
else
    defES = {};
end
s.ES = adjustParam('ES',defES, s_in);
s.intensities_DTA = adjustParam('intensities_DTA',nan(L,nMol*nChan), s_in);
s.FRET_DTA = adjustParam('FRET_DTA', nan(L,nMol*nFRET), s_in);
s.S_DTA = adjustParam('S_DTA', nan(L,nMol*nS), s_in);
s.bool_intensities = adjustParam('bool_intensities', true(L,nMol), s_in);
s.colours = adjustParam('colours', [], s_in); % plot colours

% dwell-times: in construction (fields not used)
s.dt_ascii = adjustParam('dt_ascii', false, s_in);
s.dt_pname = adjustParam('dt_pname', [], s_in);
s.dt_fname = adjustParam('dt_fname', [], s_in);
s.dt = adjustParam('dt', {}, s_in);

% molecule tags; added by FS, 24.4.2018
% modified by MH, 24.4.2019: remove label 'unlabelled', use second 
% dimension for label indexes and first dimension for molecule idexes
% s.molTag = adjustParam('molTag', ones(1,size(s.intensities,2)/s.nb_channel), s_in);
% s.molTagNames = adjustParam('molTagNames', {'unlabeled', 'static', 'dynamic'}, s_in);
% modified by MH, 25.4.2019: fetch tag names in interface's defaults
% s.molTagNames = adjustParam('molTagNames', {'static', 'dynamic'}, s_in);
s.molTagNames = adjustParam('molTagNames',p.es.tagNames,s_in);

nTag = numel(s.molTagNames);
s.molTag = adjustParam('molTag', false(nMol,nTag), s_in);

% added by MH, 24.4.2019
% modified by MH, 25.4.2019: fetch tag colors in interface's defaults
% s.molTagClr = adjustParam('molTagClr', ...
%     {'#4298B5','#DD5F32','#92B06A','#ADC4CC','#E19D29'}, s_in);
s.molTagClr = adjustParam('molTagClr',p.es.tagClr,s_in);


%% check video entries
% check movie file >> set movie dimensions and reading infos
if ~isempty(s.movie_file) && istestfile(s.movie_file)
    s.movie_file = which(s.movie_file); % get machine-dependent path for test files
end
if ~isempty(s.movie_file) && exist(s.movie_file, 'file')
    s.is_movie = 1;
    if size(s.aveImg,2)~=(s.nb_excitations+1)
        s.aveImg = calcAveImg('all',s.movie_file,s.movie_dat,...
            s.nb_excitations,s,h_fig);
    end
    
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
        [data,ok] = getFrames([pname fname], 1, {}, h_fig, false);
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
    [data,ok] = getFrames(s.movie_file, 1, {}, h_fig, false);
    if ~ok
        return;
    end
    s.movie_dim = [data.pixelX data.pixelY];
    s.movie_dat = {data.fCurs [data.pixelX data.pixelY] data.frameLen};
end

% set movie reading infos if movie exists
if (isempty(s.movie_dat) || size(s.movie_dat, 2) ~= 3) && s.is_movie
    [data,ok] = getFrames(s.movie_file, 1, {}, h_fig, false);
    if ~ok
        return;
    end
    s.movie_dat = {data.fCurs [data.pixelX data.pixelY] data.frameLen};
end

%% check emitter label entries
if isempty(s.labels) || size(s.labels,2) < s.nb_channel
    h = guidata(h_fig);
    label_def = h.param.movPr.labels_def;
    for c = 1:nChan
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

%% check emitter specificities
if isempty(s.chanExc) || size(s.chanExc,2) < s.nb_channel
    s.chanExc = zeros(1,s.nb_channel);
    for c = 1:nChan
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

%% check experimental parameters
if isempty(s.exp_parameters) || size(s.exp_parameters,2) ~= 3
    s.exp_parameters = {'Project title' '' ''
                        'Molecule name' '' ''
                        '[Mg2+]' [] 'mM'
                        '[K+]' [] 'mM'};
    for i = 1:nExc
        s.exp_parameters{size(s.exp_parameters,1)+1,1} = ['Power(' ...
            num2str(round(s.excitations(i))) 'nm)'];
        s.exp_parameters{size(s.exp_parameters,1),2} = '';
        s.exp_parameters{size(s.exp_parameters,1),3} = 'mW';
    end
end

%% check trajectroies
if isempty(s.intensities_bgCorr)
    s.intensities_bgCorr = nan(L,nMol*nChan,nExc);
end
if isempty(s.intensities_crossCorr)
    s.intensities_crossCorr = nan(L,nMol*nChan,nExc);
end
if isempty(s.intensities_denoise)
    s.intensities_denoise = nan(L,nMol*nChan,nExc);
end
if isempty(s.intensities_DTA)
    s.intensities_DTA = nan(L,nMol*nChan,nExc);
end
if nFRET>0
    if isempty(s.FRET_DTA)
        s.FRET_DTA = nan(L,nMol*nFRET);
    end
    if isempty(s.ES)
        s.ES = defES;
    end
end
if nS>0
    if isempty(s.S_DTA)
        s.S_DTA = nan(L,nMol*nS);
    end
end
if isempty(s.bool_intensities)
    s.bool_intensities = true(L,nMol);
end

%% check molecule tags
if isempty(s.molTag)
    s.molTag = false(nMol,nTag);
end

%% check coordinates
s.is_coord = ~isempty(s.coord);
if s.is_coord
    if size(s.coord_incl,2) < size(s.coord,1)
        s.coord_incl((size(s.coord_incl,2)+1):size(s.coord,1)) = ...
            true(1,(size(s.coord,1)-size(s.coord_incl,2)));
    end
end
if isempty(s.coord_incl)
    s.coord_incl = true(1,nMol);
end


%% check FRET and stoichiometry entries
if size(s.FRET,2) > 2
    s.FRET = s.FRET(:,1:2);
end
if nS>0 && size(s.S,2)~=2
    [S,s_incl] = getCorrectSid(s.S,s.FRET,s.excitations,s.chanExc);
    s.S = S;
    nS = size(s.S,1);
    if ~isempty(s.S_DTA)
        s.S_DTA = s.S_DTA(:,repmat(s_incl,[1,nMol]));
    end
end

%% check colour entries
if isempty(s.colours) || size(s.colours,2) ~=3
    s.colours = getDefTrClr(nExc,s.excitations,nChan,nFRET,nS);
end

%% remove processing parameters
if isfield(s, 'prm')
    s.prmTT = s.prm;
    s = rmfield(s, 'prm');
end
if isfield(s, 'exp')
    s.expTT = s.exp;
    s = rmfield(s, 'exp');
end


%% check dwell-times entries
if ~s.dt_ascii
    s.dt_pname = [];
    s.dt_fname = [];
end
s.dt = cell(nMol, nChan*nExc+nFRET+nS);
for m = 1:nMol
    incl = s.bool_intensities(:,m);
    j = 0;
    for i_l = 1:s.nb_excitations
        for i_c = 1:s.nb_channel
            j = j + 1;
            if isempty(s.intensities_DTA)
                continue
            end
            I = s.intensities_DTA(incl,(m-1)*s.nb_channel+i_c,i_l);
            if sum(double(~isnan(I)))
                s.dt{m,j} = getDtFromDiscr(I,...
                    s.nb_excitations*s.frame_rate);
            else
                s.dt{m,j} = [];
            end
        end
    end
    for i_f = 1:size(s.FRET,1)
        j = j + 1;
        if isempty(s.FRET_DTA)
            continue
        end
        tr = s.FRET_DTA(incl,(m-1)*nFRET+i_f);
        if sum(double(~isnan(tr)))
            s.dt{m,j} = getDtFromDiscr(tr,s.nb_excitations*s.frame_rate);
        else
            s.dt{m,j} = {};
        end
    end
    for i_s = 1:size(s.S,1)
        j = j + 1;
        if isempty(s.S_DTA)
            continue
        end
        tr = s.S_DTA(incl,(m-1)*nS+i_s);
        if sum(double(~isnan(tr)))
            s.dt{m,j} = getDtFromDiscr(tr,s.nb_excitations*s.frame_rate);
        else
            s.dt{m,j} = {};
        end
    end
end

% added by MH, 24.4.2019
%% check molecule tag entries
oldTag = cell2mat(strfind(s.molTagNames,'unlabeled'));
if ~isempty(oldTag)
    newMolTag = false(nMol,numel(s.molTagNames));
    for tag = 1:numel(s.molTagNames)
        newMolTag(s.molTag==tag,tag) = s.molTag(s.molTag==tag)';
    end
    s.molTagNames(oldTag) = [];
    newMolTag(:,oldTag) = [];
    s.molTag = newMolTag;
    nTag = numel(s.molTagNames);
end

if numel(s.molTagClr)<nTag
    
    % corrected by MH, 25.4.2019
%     clr = round(255*rand(1,3));
%     s.molTagClr = [s.molTagClr cat(2,'#',num2str(dec2hex(clr(1))),...
%         num2str(dec2hex(clr(2))),num2str(dec2hex(clr(3))))];
    for t = (numel(s.molTagClr)+1):nTag
        if t<=numel(p.es.tagClr)
            clr_str = p.es.defTagClr{t};
        else
            clr = round(255*rand(1,3));
            clr_str = cat(2,'#',num2str(dec2hex(clr(1))),...
            num2str(dec2hex(clr(2))),num2str(dec2hex(clr(3))));
        end
        s.molTagClr = [s.molTagClr clr_str];
    end
    
end

% check uptodate's keys
% utd_ref = initUptodateArr;
% K1 = size(utd_ref,1);
% for k1 = 1:K1
%     key1 = utd_ref{k1,1};
%     val1 = utd_ref{k1,2};
%     if isempty(findKey(s.uptodate,key1))
%         s.uptodate = setKey(s.uptodate,key1,val1);
%     end
%     K2 = size(utd_ref{k1,2},1);
%     for k2 = 1:K2
%         key2 = utd_ref{k1,2}{k2,1};
%         val2 = utd_ref{k1,2}{k2,2};
%         if isempty(findKey(s.uptodate{findKey(s.uptodate,key1),2},key2))
%             s.uptodate = setKey(s.uptodate,key2,val2);
%         end
%     end
% end




