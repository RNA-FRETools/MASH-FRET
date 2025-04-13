function [s,ok] = checkField(s_in, fname, h_fig)

% defaults
ok = 1;
vidfmt = {'.sif','.vsi','.ets','.sira','.tif','.gif','.png','.spe','.pma',...
    '.avi'};
L0 = 4000; % default nb. of frames

s = s_in;

% added by MH, 25.4.2019
h = guidata(h_fig);
p = h.param;

% project
s.folderRoot = adjustParam('folderRoot', userpath, s_in);
if ~exist(s.folderRoot,'dir')
    [s.folderRoot,~,~] = fileparts(fname);
end
s.date_creation = adjustParam('date_creation', datestr(now), s_in);
s.date_last_modif = adjustParam('date_last_modif', s.date_creation, s_in);
figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH-FRET ');
b = a + numel('MASH-FRET ');
s.MASH_version = adjustParam('MASH_version', figname(b:end), s_in);
s.proj_file = fname;
% s.uptodate = adjustParam('uptodate', initUptodateArr, s_in);

% movie
s.movie_file = adjustParam('movie_file', {[]}, s_in); % movie path/file
s.movie_dim = adjustParam('movie_dim', {[]}, s_in);
s.movie_dat = adjustParam('movie_dat', {[]}, s_in);
if ~iscell(s.movie_file)
    s.movie_file = {s.movie_file};
    s.movie_dim = {s.movie_dim};
    s.movie_dat = {s.movie_dat};
end
s.is_movie = adjustParam('is_movie', ~any(cellfun('isempty',s.movie_file)),...
    s_in);
s.spltime_from_video = adjustParam('spltime_from_video',s.is_movie,s_in);
s.aveImg = adjustParam('aveImg',cell(numel(s.movie_file),s.nb_excitations),...
    s_in);

if isfield(s,'frame_rate')
    s.sampling_time = s_in.frame_rate; % historical mistake in field name
else
    s.sampling_time = adjustParam('sampling_time', 1, s_in);
end
s.sampling_time(s.sampling_time<=0) = 1;
s.resampling_time = adjustParam('resampling_time',s.sampling_time,s_in);

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
s.FRET = adjustParam('FRET', [], s_in);
nFRET = size(s.FRET,1);
s.S = adjustParam('S', [], s_in);
nS = size(s.S,1);

% coordinates
s.coord = adjustParam('coord', [], s_in);
s.coord_file = adjustParam('coord_file', [], s_in);
s.coord_imp_param = adjustParam('coord_imp_param', {[1 2] 1}, s_in);
s.is_coord = adjustParam('is_coord', ~isempty(s.coord), s_in);
s.coord_incl = adjustParam('coord_incl', [], s_in);
N = numel(s.coord_incl);

% intensity integration
s.pix_intgr = adjustParam('pix_intgr', [1 1], s_in);

% units
s.cnt_p_sec = adjustParam('cnt_p_sec', 0, s_in);
s.time_in_sec = adjustParam('time_in_sec', 0, s_in);

% intensity-time traces processing
s.spltime_from_traj = adjustParam('spltime_from_traj',~s.is_movie,s_in);
s.intensities = adjustParam('intensities',nan(L0,N*nChan,nExc),s_in);
L = size(s.intensities,1);
N = size(s.intensities,2)/nChan;

s.intensities_bgCorr = adjustParam('intensities_bgCorr',[],s_in);
s.intensities_bin = adjustParam('intensities_bin',[],s_in);
s.bool_intensities = adjustParam('bool_intensities',[],s_in);
s.emitter_is_on = adjustParam('emitter_is_on',[],s_in);
s.intensities_crossCorr = adjustParam('intensities_crossCorr',[],s_in);
s.intensities_denoise = adjustParam('intensities_denoise',[],s_in);
s.intensities_DTA = adjustParam('intensities_DTA',[],s_in);

if nFRET>0
    defES = cell(1,nFRET);
else
    defES = {};
end
s.ES = adjustParam('ES',defES, s_in);
s.FRET_DTA = adjustParam('FRET_DTA',[],s_in);
s.S_DTA = adjustParam('S_DTA',[],s_in);
s.colours = adjustParam('colours', [], s_in); % plot colours
s.traj_import_opt = adjustParam('traj_import_opt', [], s_in); % trajectory import options

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
s.molTag = adjustParam('molTag', false(N,nTag), s_in);

% added by MH, 24.4.2019
% modified by MH, 25.4.2019: fetch tag colors in interface's defaults
% s.molTagClr = adjustParam('molTagClr', ...
%     {'#4298B5','#DD5F32','#92B06A','#ADC4CC','#E19D29'}, s_in);
s.molTagClr = adjustParam('molTagClr',p.es.tagClr,s_in);

% check machine-dependent path for test video files
if all(~cellfun('isempty',s.movie_file)) && ...
        all(cellfun(@istestfile,s.movie_file))
    for c = 1:numel(s.movie_file)
        s.movie_file{c} = strrep(strrep(s.movie_file{c},'\',filesep),'/',...
            filesep);
        s.movie_file{c} = which(s.movie_file{c}); 
    end
end

% check existence of video file
str0 = ['*',vidfmt{1}];
str1 = ['(*',vidfmt{1}];
for fmt = 2:numel(vidfmt)
    str0 = cat(2,str0,';*',vidfmt{fmt});
    str1 = cat(2,str1,',*',vidfmt{fmt});
end
str1 = [str1,')'];
if all(~cellfun('isempty',s.movie_file)) && ...
        ~all(cellfun(@(C) exist(C,'file'),s.movie_file))
    [o,name_proj,ext] = fileparts(fname);
    name_proj = [name_proj ext];
    if numel(s.movie_file)>1
        chanstr = 'channel %i of ';
    else
        chanstr = '';
    end
    for c = 1:numel(s.movie_file)
        if exist(s.movie_file{c},'file')
            continue
        end
        load_mov = questdlg({['Impossible to find the video file(s) for ',...
            chanstr,'project "',name_proj,'".'],...
            'Load the video manually?'},'Unkown video file','Browse',...
            'Continue without video','Browse');
        disp(['No video file for project: ',name_proj]);
        
        if strcmp(load_mov, 'Browse')
            [fname,pname,o] = uigetfile({...
                str0,['Supported Graphic File Format',str1]; ...
                '*.*','All File Format(*.*)'},'Select a video file');
            if ~(~isempty(fname) && sum(fname))
                s = [];
                ok = 0;
                return
            end
            [data,ok] = getFrames([pname fname], 1, {}, h_fig, false);
            if ~ok
                s = [];
                ok = 0;
                return
            end
            s.movie_file{c} = [pname fname];
            s.movie_dim{c} = [data.pixelX data.pixelY];
            s.movie_dat{c} = {data.fCurs [data.pixelX data.pixelY] ...
                data.frameLen};
            disp(['Loading video file: ' fname ' from folder: ' pname]);

        elseif strcmp(load_mov, 'Continue without video')
            s.movie_file{c} = [];
            s.movie_dim{c} = [];
            s.movie_dat{c} = [];
            break
        else
            s = [];
            ok = 0;
            return
        end
    end
    s.is_movie = all(~cellfun('isempty',s.movie_file));
    if ~s.is_movie
        s.movie_file = {[]};
        s.movie_dim = {[]};
        s.movie_dat = {[]};
    end
end

% import full-length video data and calculate average images
if all(~cellfun('isempty',s.movie_file)) && ...
        all(cellfun(@(C) exist(C,'file'),s.movie_file))
    s.is_movie = 1;
    
    % import video data
    if numel(s.movie_file)==1 && ~isFullLengthVideo(s.movie_file{1},h_fig)
        h = guidata(h_fig);
        h.movie.movie = [];
        h.movie.file = '';
        guidata(h_fig,h);
        [dat,ok] = getFrames(s.movie_file{1},'all',[],h_fig,true);
        if ~ok
            s = [];
            return
        end
        h = guidata(h_fig);
        if ~isempty(dat.movie)
            h.movie.movie = dat.movie;
            h.movie.file = s.movie_file{1};
            guidata(h_fig,h);
            ok = 2;
        elseif ~isempty(h.movie.movie)
            h.movie.file = s.movie_file{1};
            guidata(h_fig,h);
            ok = 2;
        end
    end
    if size(s.aveImg,2)~=(s.nb_excitations+1) || ...
            size(s.aveImg,1)~=numel(s.movie_file)
        setContPan('Calculate average images...','process',h_fig);
        s.aveImg = cell(numel(s.movie_file),s.nb_excitations+1);
        for c = 1:numel(s.movie_file)
            s.aveImg(c,:) = calcAveImg('all',s.movie_file{c},...
                s.movie_dat{c},s.nb_excitations,h_fig);
        end
    end
end
if any(cellfun('isempty',s.movie_file))
    s.is_movie = false;
end

% set movie dimensions and reading infos
if s.is_movie 
    for c = 1:numel(s.movie_file)
        if isempty(s.movie_dim{c}) || size(s.movie_dim{c},2)~=2 || ...
                isempty(s.movie_dat{c}) || size(s.movie_dat{c},2)~=3
            [data,ok] = getFrames(s.movie_file{c}, 1, {}, h_fig, false);
            if ~ok
                s = [];
                return
            end
            s.movie_dim{c} = [data.pixelX data.pixelY];
            s.movie_dat{c} = {data.fCurs [data.pixelX data.pixelY] ...
                data.frameLen};
        end
    end
end


% check emitter label entries
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

% check emitter specificities
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

% check experimental parameters
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

% check trajectroies
if ~isequal(size(s.intensities_bgCorr,[1,2,3]),[L,N*nChan,nExc])
    s.intensities_bgCorr = nan(L,N*nChan,nExc);
end
if ~isequal(size(s.intensities_bin,[2,3]),[N*nChan,nExc])
    s.intensities_bin = nan(L,N*nChan,nExc);
end
L2 = size(s.intensities_bin,1);

if ~isequal(size(s.intensities_crossCorr,[1,2,3]),[L2,N*nChan,nExc])
    s.intensities_crossCorr = nan(L2,N*nChan,nExc);
end
if ~isequal(size(s.intensities_denoise,[1,2,3]),[L2,N*nChan,nExc])
    s.intensities_denoise = nan(L2,N*nChan,nExc);
end
if ~isequal(size(s.intensities_DTA,[1,2,3]),[L2,N*nChan,nExc])
    s.intensities_DTA = nan(L2,N*nChan,nExc);
end
if nFRET>0
    if ~isequal(size(s.FRET_DTA),[L2,N*nFRET])
        s.FRET_DTA = nan(L2,N*nFRET);
    end
    if isempty(s.ES)
        s.ES = defES;
    end
end
if nS>0
    if ~isequal(size(s.S_DTA),[L2,N*nS])
        s.S_DTA = nan(L2,N*nS);
    end
end
if ~isequal(size(s.bool_intensities),[L2,N])
    s.bool_intensities = true(L2,N);
end
if ~isequal(size(s.emitter_is_on),[L2,N*nChan])
    s.emitter_is_on = true(L2,N*nChan);
end

% check molecule tags
if isempty(s.molTag)
    s.molTag = false(N,nTag);
end

% check coordinates
s.is_coord = ~isempty(s.coord);
if s.is_coord
    if size(s.coord_incl,2) < size(s.coord,1)
        s.coord_incl((size(s.coord_incl,2)+1):size(s.coord,1)) = ...
            true(1,(size(s.coord,1)-size(s.coord_incl,2)));
    end
end
if ~isequal(size(s.coord_incl),[1,N])
    s.coord_incl = true(1,N);
end


% check FRET and stoichiometry entries
if size(s.FRET,2) > 2
    s.FRET = s.FRET(:,1:2);
end
if nS>0 && size(s.S,2)~=2
    [S,s_incl] = getCorrectSid(s.S,s.FRET,s.excitations,s.chanExc);
    s.S = S;
    nS = size(s.S,1);
    if ~isempty(s.S_DTA)
        s.S_DTA = s.S_DTA(:,repmat(s_incl,[1,N]));
    end
end

% check colour entries
if isempty(s.colours) || size(s.colours,2)~=3
    s.colours = getDefTrClr(nExc,s.excitations,nChan,nFRET,nS);
end

% remove processing parameters
if isfield(s, 'prm')
    s.prmTT = s.prm;
    s = rmfield(s, 'prm');
end
if isfield(s, 'exp')
    s.expTT = s.exp;
    s = rmfield(s, 'exp');
end


% check dwell-times entries
if ~s.dt_ascii
    s.dt_pname = [];
    s.dt_fname = [];
end
s.dt = cell(N, nChan*nExc+nFRET+nS);
for m = 1:N
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
                    s.nb_excitations*s.resampling_time);
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
            s.dt{m,j} = getDtFromDiscr(tr,s.nb_excitations*s.resampling_time);
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
            s.dt{m,j} = getDtFromDiscr(tr,s.nb_excitations*s.resampling_time);
        else
            s.dt{m,j} = {};
        end
    end
end

% added by MH, 24.4.2019
% check molecule tag entries
oldTag = cell2mat(strfind(s.molTagNames,'unlabeled'));
if ~isempty(oldTag)
    newMolTag = false(N,numel(s.molTagNames));
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


