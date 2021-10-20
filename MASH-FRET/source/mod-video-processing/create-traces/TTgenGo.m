function TTgenGo(h_fig,varargin)
% TTgenGo(h_fig)
% TTgenGo(h_fig,pname,fname)
%
% Save traces to MASH project and other files.
% TTgenGo can be called either after pressing "create & export" button in Video processing, or from a test routine.
% 
% h_fig: handle to main figure
% pname: destination folder (from routine test)
% fname: destination .mash file (from routine test)

% Last update by MH, 28.3.2019: change MASH folder from /video-processing back to root folder
% update by MH, 18.2.2019: change default folder to video_processing comment code

h = guidata(h_fig);
p = h.param;
vidfile = p.proj{p.curr_proj}.movie_file;
viddat = p.proj{p.curr_proj}.movie_dat;

if ~isFullLengthVideo(h_fig)
    h.movie.movie = [];
    h.movie.proj = 0;
    guidata(h_fig,h);
    [dat,ok] = getFrames(vidfile,'all',viddat,h_fig,true);
    if ~ok
        return
    end
    h = guidata(h_fig);
    p = h.param;
    if ~isempty(dat.movie)
        h.movie.movie = dat.movie;
        h.movie.proj = p.curr_proj;
        guidata(h_fig,h);
    elseif ~isempty(h.movie.movie)
        h.movie.proj = p.curr_proj;
        guidata(h_fig,h);
    end
end

proj = p.curr_proj;
folderRoot = p.proj{proj}.folderRoot;
vidfile = p.proj{proj}.movie_file;
FRET = p.proj{proj}.FRET;
expprm = p.proj{proj}.VP.curr.gen_int{4};

% build file name
if ~isempty(varargin)
    pname = varargin{1};
    fname = varargin{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
    fromRoutine = true;
else
    [o,movName,o] = fileparts(vidfile);
    defName = cat(2,setCorrectPath(folderRoot,h_fig),movName,'.mash');
    [fname,pname,o] = uiputfile({'*.*','All Files (*.*)'},...
        'Export traces',defName);
     fromRoutine = false;
end
if ~sum(fname)
    return
end
cd(pname);
[o,fname,o] = fileparts(fname);
fname_proj = getCorrName(fname,pname,h_fig);
if ~sum(fname_proj)
    return
end

% export data
dat = exportProject(cat(2,pname,fname_proj),h_fig);
if isempty(dat)
    return
end
p.proj{p.curr_proj} = dat;

% export other files
if ~fromRoutine
    pname = [];
end
saveTraces(dat,pname,fname_proj,{expprm FRET},h_fig);

% tag project
p.proj{p.curr_proj}.TP.from = p.proj{p.curr_proj}.VP.from;
p.proj{p.curr_proj}.HA.from = p.proj{p.curr_proj}.VP.from;
p.proj{p.curr_proj}.TA.from = p.proj{p.curr_proj}.VP.from;

% set default TP parameters
p = importTP(p,p.curr_proj);
p = importHA(p,p.curr_proj);
% p = importTA(p,p.curr_proj);

% save modifications
h.param = p;
guidata(h_fig,h);

% update project-dependant interface
ud_TTprojPrm(h_fig);

% update plots and GUI
updateFields(h_fig);

