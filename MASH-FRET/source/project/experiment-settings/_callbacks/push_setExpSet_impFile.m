function push_setExpSet_impFile(obj,evd,h_fig,h_fig0)

% default
vidfmt = {'.sif','.vsi','.ets','.sira','.tif','.gif','.png','.spe','.pma',...
    '.avi'};

% retrieve project data
proj = h_fig.UserData;

% ask for video file
str0 = ['*',vidfmt{1}];
str1 = ['(*',vidfmt{1}];
for fmt = 2:numel(vidfmt)
    str0 = cat(2,str0,';*',vidfmt{fmt});
    str1 = cat(2,str1,',*',vidfmt{fmt});
end
str1 = [str1,')'];
[fname,pname,o] = uigetfile({str0,['Supported Graphic File Format',str1]; ...
    '*.*','All File Format(*.*)'},'Select a video file',proj.folderRoot);
if ~sum(pname)
    return
end
if pname(end)~=filesep
    pname = [pname,filesep];
end
cd(pname);

% display process
setContPan(['Import video from file: ',pname,fname,' ...'],'process',...
    h_fig0);

% import video data
h0 = guidata(h_fig0);
h0.movie.movie = [];
h0.movie.file = '';
guidata(h_fig0,h0);
[dat,ok] = getFrames([pname,fname],'all',[],h_fig0,true);
if ~ok
    return
end
h0 = guidata(h_fig0);
p = h0.param;
if ~isempty(dat.movie)
    h0.movie.movie = dat.movie;
    h0.movie.file = [pname,fname];
    guidata(h_fig0,h0);
elseif ~isempty(h0.movie.movie)
    h0.movie.file = [pname,fname];
    guidata(h_fig0,h0);
end

vinfo = {dat.fCurs,[dat.pixelX,dat.pixelY],dat.frameLen};
vfile = [pname,fname];

% set project video infos
proj.folderRoot = pname;
proj.movie_file = vfile;
proj.is_movie = true;
proj.movie_dim = vinfo{2};
proj.movie_dat = vinfo;
proj.frame_rate = dat.cycleTime;
if isfield(dat,'lasers')
    proj.excitations = dat.lasers;
    proj.nb_excitations = numel(dat.lasers);
end
if dat.cycleTime==1
    proj.spltime_from_video = false;
else
    proj.spltime_from_video = true;
end

% update laser-related data (including average images)
if isfield(dat,'lasers')
    
    % save modifications
    h_fig.UserData = proj;
    
    % GUI-based data modifications
    h = guidata(h_fig);
    h.edit_nExc.String = num2str(proj.nb_excitations);
    edit_setExpSet_nExc(h.edit_nExc,[],h_fig,h_fig0);
    h = guidata(h_fig);
    for exc = 1:proj.nb_excitations
        h.edit_excWl(exc).String = num2str(proj.excitations(exc));
        edit_setExpSet_excWl(h.edit_excWl(exc),[],h_fig,exc);
    end
    
else
    % display process
    setContPan('Calculate average images...','process',h_fig0);

    % calculate average images
    aveimg = calcAveImg('all',vfile,vinfo,proj.nb_excitations,h_fig0);

    proj.aveImg = aveimg;
    
    % save modifications
    h_fig.UserData = proj;
end

% refresh panels
ud_expSet_chanPlot(h_fig);
ud_expSet_excPlot(h_fig);
ud_setExpSet_tabImp(h_fig)
ud_setExpSet_tabDiv(h_fig);

% display success
setContPan('Video successfully imported!','success',h_fig0);
