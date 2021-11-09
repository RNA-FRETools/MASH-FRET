function push_setExpSet_impBetaFile(obj,evd,h_fig,h_fig0)

% retrieve project data
proj = h_fig.UserData;

% control trajectory files
if ~(isfield(proj,'traj_files') && size(proj.traj_files,2)>=2 && ...
        ~isempty(proj.traj_files{2}))
    setContPan(['No trajectroy detected. Please import trajectory files ',...
        'first.'],'error',h_fig0);
    return
end

% ask for beta files
[fname,pname,o] = uigetfile({'*.*','All files(*.*)'},...
    'Select beta factor file(s)',proj.folderRoot,'MultiSelect','on');
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

proj.traj_import_opt{6}{4} = pname;
proj.traj_import_opt{6}{5} = fname;
set(h_fig,'userdata',proj);

ud_setExpSet_tabImp(h_fig);
