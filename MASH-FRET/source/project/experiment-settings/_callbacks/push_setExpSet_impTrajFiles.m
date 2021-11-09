function push_setExpSet_impTrajFiles(obj,evd,h_fig,h_fig0)

% default
maxflines = 100;

% retrieve project data
proj = h_fig.UserData;

% ask for trajectory files
[fname,pname,o] = uigetfile({'*.*','All files(*.*)'},...
    'Select trajectory files',proj.folderRoot,'MultiSelect','on');
if ~sum(pname)
    return
end
if pname(end)~=filesep
    pname = [pname,filesep];
end
if ~iscell(fname)
    fname = {fname};
end
cd(pname);

% display process
setContPan(['Import trajectories from folder: ',pname,' ...'],...
    'process',h_fig0);

proj.traj_files = {pname,fname};

switch proj.traj_import_opt{1}{1}(2)
    case 1
        delimchar = sprintf('\t');
    case 2
        delimchar = ',';
    case 3
        delimchar = ';';
    case 4
        delimchar = ' ';
    otherwise
        delimchar = sprintf('\t');
end

% read first 100 file lines
fdat = {};
fline = 0;
f = fopen([pname,fname{1}],'r');
while fline<maxflines && ~feof(f)
    rowdat = split(fgetl(f),delimchar)';
    if ~isempty(fdat) && size(rowdat,2)~=size(fdat,2)
        if size(rowdat,2)<size(fdat,2)
            rowdat = cat(2,rowdat,...
                cell(1,size(fdat,2)-size(rowdat,2)));
        else
            fdat = cat(2,fdat,...
                cell(size(fdat,1),size(rowdat,2)-size(fdat,2)));
        end
    end
    fdat = cat(1,fdat,rowdat);
    fline = fline+1;
end
fclose(f);

% store file content
h = guidata(h_fig);
set(h.table_fstrct,'userdata',fdat);

% save modifications
h_fig.UserData = proj;

% refresh trajectory import options
ud_trajImportOpt(h_fig);

% refresh panels
ud_expSet_chanPlot(h_fig);
ud_expSet_excPlot(h_fig);
ud_setExpSet_tabImp(h_fig);
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);

% display success
setContPan('Trajectories successfully imported!','success',h_fig0);
