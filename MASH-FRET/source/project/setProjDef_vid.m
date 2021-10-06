function proj = setProjDef_vid(proj,p,h_fig)
% proj = setProjDef_vid(proj,p,h_fig)
%
% Import video and set default project parameters 
%
% proj: project structure
% p: interface parameters structure
% h_fig: handle to main figure

% default
vidfmt = {'.sif','.vsi','.ets','.sira','.tif','.gif','.png','.spe','.pma',...
    '.avi'};

% ask for video file
str0 = ['*',vidfmt{1}];
str1 = ['(*',vidfmt{1}];
for fmt = 2:numel(vidfmt)
    str0 = cat(2,str0,';*',vidfmt{fmt});
    str1 = cat(2,str1,',*',vidfmt{fmt});
end
str1 = [str1,')'];
[fname,pname,o] = uigetfile({str0,['Supported Graphic File Format',str1]; ...
    '*.*','All File Format(*.*)'},'Select a video file');
if ~sum(pname)
    proj = [];
    return
end

% import video data
h = guidata(h_fig);
h.movie.movie = []; % reset video data currently loaded in memory
guidata(h_fig,h);
[dat,ok] = getFrames([pname,filesep,fname], 'all', [], h_fig, true);
if ~ok
    proj = [];
    return
end
vfile = [pname,filesep,fname];
vinfo = {dat.fCurs,[dat.pixelX,dat.pixelY],dat.frameLen};

% set project video infos
proj.folderRoot = pname;
proj.movie_file = vfile;
proj.is_movie = true;
proj.movie_dim = vinfo{2};
proj.movie_dat = vinfo;
proj.frame_rate = 1/dat.cycleTime;

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

% ask user for experiment settings & calculate average images
proj = setExpSetWin(proj,h_fig);
if isempty(proj)
    return
end

% set processing parameters according to experiment settings
h = guidata(h_fig); % recover possibly refilled video data (memory management)
if ~(isfield(h.movie,'movie') && ~isempty(h.movie.movie))
    h.movie.movie = dat.movie;
end

% set default video processing parameters
proj.VP = setDefPrm_VP(proj,p.movPr,dat.frameCur);
