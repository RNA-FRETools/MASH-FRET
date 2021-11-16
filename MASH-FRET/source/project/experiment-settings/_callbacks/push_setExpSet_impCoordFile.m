function push_setExpSet_impCoordFile(obj,evd,h_fig,h_fig0)

% retrieve project data
proj = h_fig.UserData;

% control trajectory files
if ~(isfield(proj,'traj_files') && size(proj.traj_files,2)>=2 && ...
        ~isempty(proj.traj_files{2}))
    setContPan(['No trajectroy detected. Please import trajectory files ',...
        'first.'],'error',h_fig0);
    return
end

% ask for coordinates file
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
else
    [fname,pname,o] = uigetfile({'*.*','All files(*.*)'},...
    'Select a coordinates file',proj.folderRoot);
    if ~sum(pname)
        return
    end
end
if pname(end)~=filesep
    pname = [pname,filesep];
end
cd(pname);

% show process
setContPan(['Import coordinates from file ',pname,fname,'...'],'process',...
    h_fig0);

% import coordinates
fdat = {};
f = fopen([pname,fname],'r');
while ~feof(f)
    fdat = cat(1,fdat,fgetl_MASH(f));
end
fclose(f);

% organize coordinates in a column-wise fashion
coord = orgCoordCol(fdat,'cw',proj.traj_import_opt{3}{3},proj.nb_channel,...
    [],h_fig0);
if isempty(coord) || size(coord,2)~=(2*proj.nb_channel)
    return
end

% save modifications
proj.coord = coord;
proj.coord_file = [pname,fname];
proj.coord_imp_param = proj.traj_import_opt{3}{3};
set(h_fig,'userdata',proj);

ud_setExpSet_tabImp(h_fig);

% show success
setContPan('Coordinates successfully imported!','success',h_fig0);
