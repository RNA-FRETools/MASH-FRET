function push_setExpSet_impHistFiles(obj,evd,h_fig,h_fig0)

% default
maxflines = 100;

% retrieve project data
proj = h_fig.UserData;

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
else
    % ask for trajectory files
    [fname,pname,~] = uigetfile({'*.*','All files(*.*)'},...
        'Select one histogram file',proj.folderRoot,'MultiSelect','off');
    if ~sum(pname)
        return
    end
end
if pname(end)~=filesep
    pname = [pname,filesep];
end
cd(pname);

% display process
setContPan(['Import histogram from folder: ',pname,' ...'],'process',...
    h_fig0);

proj.hist_file = {pname,fname};

% read first 100 file lines
delimchar = collectsdelimchar(proj.hist_import_opt(2));
fdat = readfirstflines(pname,fname,delimchar,maxflines);

% store file content
h = guidata(h_fig);
set(h.table_fstrct,'userdata',fdat);

% save modifications
h_fig.UserData = proj;

% refresh histogram import options
ud_histImportOpt(h_fig);

ud_setExpSet_tabImp(h_fig);
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);

% display success
setContPan('Histogram successfully imported!','success',h_fig0);

