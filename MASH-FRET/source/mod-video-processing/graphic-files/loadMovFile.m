function ok = loadMovFile(n, txt, setMovParam, h_fig)
% ok = loadMovFile(n, txt, setMovParam, h_fig)
%
% Load a new video/image file in MASH
%
% n: 'all' to load all video frames, or the index in the video of the frame to import 
% txt: text display as title of browser window
% setMovParam: obsolete
% h_fig: handle to the main figure

% default
vidfmt = {'.sif','.vsi','.ets','.sira','.tif','.gif','.png','.spe','.pma',...
    '.avi'};

% initialize output
ok = 0;

% get source file
if ~iscell(txt)
    str0 = ['*',vidfmt{1}];
    str1 = ['(*',vidfmt{1}];
    for fmt = 2:numel(vidfmt)
        str0 = cat(2,str0,';*',vidfmt{fmt});
        str1 = cat(2,str1,',*',vidfmt{fmt});
    end
    str1 = [str1,')'];
    [fname,pname,o] = uigetfile({...
        str0,['Supported Graphic File Format',str1]; ...
        '*.*','All File Format(*.*)'},txt);
else
    pname = txt{1}; % ex: C:\Users\MASH\Documents\MATLAB\
    fname = txt{2}; % ex: movie.sif
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
end
if ~sum(fname)
    return
end
cd(pname);
    
updateActPan(['Loading file ' fname ' from path :\n', pname], h_fig);

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% reset video data
h.movie.movie = [];

% reset files and coordinates
p.SFres = {};
p.coordTrsf = [];
p.coordTrsf_file = [];
p.coordItg = [];
p.coordItg_file = [];
p.itg_movFullPth = [];
p.itg_coordFullPth = [];

% save modifications
h.param.movPr = p;
guidata(h_fig,h);

% get video data
[data,ok] = getFrames([pname fname], n, [], h_fig, true);
if ~ok
    return
end

% recover possibly refilled video data if previously allocated
h = guidata(h_fig);
p = h.param.movPr;

[o, o, fExt] = fileparts(fname);
switch fExt
    case '.vsi'
        fExt = 'bf';
    case '.ets'
        fExt = 'bf';
    case '.sif'
        fExt = 'sif';
    case '.gif'
        fExt = 'gif';
    case '.png'
        fExt = 'png';
    case '.tif'
        fExt = 'tif';
    case '.TIF'
        fExt = 'tif';
    case '.spe'
        fExt = 'spe'; 
    case '.sira'
        fExt = 'sira';
    case '.pma'
        fExt = 'pma';
    case '.avi'
        fExt = 'avi';
    case '.crd'
        fExt = 'crd';
    case '.coord'
        fExt = 'coord';
    case '.spots'
        fExt = 'spots';
    otherwise
        updateActPan('File format not supported.', h_fig, 'error');
        return
end

% set video parameters
h.movie.format = fExt;
h.movie.file = fname;
h.movie.path = pname;
h.movie.framesTot = data.frameLen;
if ~strcmp(n, 'all')
    h.movie.frameCurNb = n;
else
    h.movie.frameCurNb = 1;
end
h.movie.cyctime = data.cycleTime;
if ~(isfield(h.movie,'movie') && ~isempty(h.movie.movie))
    h.movie.movie = data.movie;
end
h.movie.frameCur = data.frameCur; % image data of input (displayed) frame
h.movie.pixelX = data.pixelX; % width of the movie
h.movie.pixelY = data.pixelY; % height of the movie
h.movie.speCursor = data.fCurs; % cursor position in the file where movie data begin
nChan = str2double(get(h.edit_nChannel, 'String'));
sub_w = floor(h.movie.pixelX/nChan);
h.movie.split = (1:nChan-1)*sub_w;

% set experiment settings read from video file if any
if isfield(data,'lasers')
    p.itg_nLasers = numel(data.lasers);
    p.itg_wl = data.lasers;
    p = ud_VP_nL(p);
end

% store video processing parameters
p.rate = h.movie.cyctime;
p.mov_start = 1;
p.mov_end = h.movie.framesTot;
p.ave_start = 1;
p.ave_stop = h.movie.framesTot;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% show action
updateActPan('File loaded!', h_fig, 'success');

ok = 1;