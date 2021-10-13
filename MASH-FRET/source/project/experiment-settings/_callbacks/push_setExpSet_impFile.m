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

% import video data
h = guidata(h_fig0);
h.movie.movie = []; % reset video data currently loaded in memory
guidata(h_fig0,h);
[dat,ok] = getFrames([pname,filesep,fname],1,[],h_fig0,true);
if ~ok
    return
end
h = guidata(h_fig0); % recover possibly refilled video data (memory management)
if ~(isfield(h.movie,'movie') && ~isempty(h.movie.movie))
    h.movie.movie = dat.movie;
    guidata(h_fig0,h);
end

% calculate average images
vinfo = {dat.fCurs,[dat.pixelX,dat.pixelY],dat.frameLen};
vfile = [pname,filesep,fname];
aveimg = calcAveImg('all',vfile,vinfo,proj.nb_excitations,h_fig0);

% set project video infos
proj.folderRoot = pname;
proj.movie_file = vfile;
proj.is_movie = true;
proj.movie_dim = vinfo{2};
proj.movie_dat = vinfo;
proj.frame_rate = 1/dat.cycleTime;
proj.aveImg = aveimg;
if dat.cycleTime==1
    proj.spltime_from_video = false;
else
    proj.spltime_from_video = true;
end
proj.firstFrame = dat.frameCur; % add first video frame to project param

h_fig.UserData = proj;

ud_expSet_chanPlot(h_fig);
ud_expSet_excPlot(h_fig);
ud_setExpSet_tabImp(h_fig)
ud_setExpSet_tabDiv(h_fig);
