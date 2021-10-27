function ok = TTgenGo(h_fig,varargin)
% ok = TTgenGo(h_fig)
% ok = TTgenGo(h_fig,pname,fname)
%
% Save traces to MASH project and other files.
% TTgenGo can be called either after pressing "create & export" button in Video processing, or from a test routine.
% 
% h_fig: handle to main figure
% pname: destination folder (from routine test)
% fname: destination .mash file (from routine test)
% ok: (1) success, (0) failure

% Last update by MH, 28.3.2019: change MASH folder from /video-processing back to root folder
% update by MH, 18.2.2019: change default folder to video_processing comment code

% default
ok = 0;

% get parameters
h = guidata(h_fig);
p = h.param;
vidfile = p.proj{p.curr_proj}.movie_file;
viddat = p.proj{p.curr_proj}.movie_dat;

% control video data
if ~isFullLengthVideo(vidfile,h_fig)
    h.movie.movie = [];
    h.movie.file = '';
    guidata(h_fig,h);
    [dat,ok] = getFrames(vidfile,'all',viddat,h_fig,true);
    if ~ok
        return
    end
    h = guidata(h_fig);
    if ~isempty(dat.movie)
        h.movie.movie = dat.movie;
        h.movie.file = vidfile;
        guidata(h_fig,h);
    elseif ~isempty(h.movie.movie)
        h.movie.file = vidfile;
        guidata(h_fig,h);
    end
end

% calculate intensities and set project's fields
dat = exportProject(h_fig);
if isempty(dat)
    return
end
dat = checkField(dat,'',h_fig);
if isempty(dat)
    return
end
p.proj{p.curr_proj} = dat;

% tag project
p.proj{p.curr_proj}.TP.from = p.proj{p.curr_proj}.VP.from;
p.proj{p.curr_proj}.HA.from = p.proj{p.curr_proj}.VP.from;
p.proj{p.curr_proj}.TA.from = p.proj{p.curr_proj}.VP.from;

% set default TP, HA and TA parameters
p = importTP(p,p.curr_proj);
p = importHA(p,p.curr_proj);
p = importTA(p,p.curr_proj);

% save modifications
h.param = p;
guidata(h_fig,h);

% update project-dependant interface
ud_TTprojPrm(h_fig);

% update plots and GUI
updateFields(h_fig);

% set success
ok = 1;

