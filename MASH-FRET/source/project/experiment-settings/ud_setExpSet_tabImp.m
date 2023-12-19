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
if imptraj
    if h.radio_impFileMulti.Value==1
        set([h.edit_impFileMulti,h.push_impFileMulti],'visible','on');
        set([h.push_addChan,h.push_remChan],'visible','off');
        set([h.edit_impFileSingle,h.push_impFileSingle],'visible','off');
        if ~isempty(proj.movie_file{1})
            [~,fname,fext] = fileparts(proj.movie_file{1});
            set(h.edit_impFileMulti,'string',[fname,fext]);
        else
            set(h.edit_impFileMulti,'string','');
        end
    else
        set([h.edit_impFileMulti,h.push_impFileMulti],'visible','off');
        set([h.push_addChan,h.push_remChan],'visible','on');
        set([h.edit_impFileSingle,h.push_impFileSingle],'visible','on');
        for c = 1:proj.nb_channel
            if ~isempty(proj.movie_file{c})
                [~,fname,fext] = fileparts(proj.movie_file{c});
                set(h.edit_impFileSingle(c),'string',[fname,fext]);
            else
                set(h.edit_impFileSingle(c),'string','');
            end
        end
    end
end
if proj.is_movie
    set(h.push_nextImp,'enable','on');
    if h.radio_impFileMulti.Value==1
        set(h.edit_impFileMulti,'enable','on');
    else
        set(h.edit_impFileSingle,'enable','on');
    end
else
    if ~imptraj
        set(h.push_nextImp,'enable','off');
    else
        if h.radio_impFileMulti.Value==1
            set(h.edit_impFileMulti,'enable','off');
        else
            set(h.edit_impFileSingle,'enable','off');
        end
    end
end

% control trajectory import
if ~imptraj
    ishistfile = isfield(proj,'hist_file') && ~isempty(proj.hist_file);
    if ishistfile
        set(h.edit_impHistFiles,'string',proj.hist_file{2},'enable','on');
        set(h.push_nextImp,'enable','on');
    else
        set(h.edit_impHistFiles,'string','','enable','off');
        set(h.push_nextImp,'enable','off');
    end
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
    [~,coordfname,coordfext] = fileparts(coordfile);
    set(h.edit_impCoordFile,'string',[coordfname,coordfext],'enable','on');
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
