function ud_setExpSet_tabImp(h_fig)
% ud_setExpSet_tabImp(h_fig)
% 
% Set properties of controls in "Import" tab of window "Experimental 
% settings" to proper values
%
% h_fig: handle to "Experiment settings" figure

% get interface content
h = guidata(h_fig);

if ~(isfield(h,'tab_imp') && ishandle(h.tab_imp))
    return
end

% get project parameters
proj = h_fig.UserData;

% determine data to import
imptraj = isfield(h,'text_impTrajFiles') && ishandle(h.text_impTrajFiles);

% set video file
if proj.is_movie
    set(h.edit_impFile,'string',proj.movie_file,'enable','on');
    set(h.push_nextImp,'enable','on');
else
    set(h.edit_impFile,'string','','enable','off');
    if ~imptraj
        set(h.push_nextImp,'enable','off');
    end
end

% control trajectory import
if ~imptraj
    return
end

% collect trajectory import options
opt = proj.traj_import_opt;
coordfile = proj.coord_file;
gammafile = opt{6}{2};
betafile = opt{6}{5};
istrajfile = isfield(proj,'traj_files') && size(proj.traj_files,2)>=2 && ...
    ~isempty(proj.traj_files{2});

% set trajectory files
if istrajfile
    set(h.list_impTrajFiles,'string',proj.traj_files{2},'enable','on');
    set(h.push_nextImp,'enable','on');
else
    set(h.list_impTrajFiles,'string',{''},'enable','off');
    set(h.push_nextImp,'enable','off');
end

% set coordinates file
if ~isempty(coordfile)
    set(h.edit_impCoordFile,'string',coordfile,'enable','on');
else
    set(h.edit_impCoordFile,'string','','enable','off');
end

% set gamma file
if imptraj && ~isempty(gammafile)
    set(h.edit_impGammaFile,'string',gammafile,'enable','on');
else
    set(h.edit_impGammaFile,'string','','enable','off');
end

% set beta file
if ~isempty(betafile)
    set(h.edit_impBetaFile,'string',betafile,'enable','on');
else
    set(h.edit_impBetaFile,'string','','enable','off');
end
