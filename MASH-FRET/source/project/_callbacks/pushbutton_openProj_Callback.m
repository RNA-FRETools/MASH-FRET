function pushbutton_openProj_Callback(obj, evd, h_fig)
% pushbutton_openProj_Callback([],[],h_fig)
% pushbutton_openProj_Callback(files,[],h_fig)
% pushbutton_openProj_Callback([],merged,h_fig)
%
% h_fig: handle to main figure
% files: {1-by-2} source directory and files to import
% merged: project structure from merged projects

% created by MH, 23.2.2021

% get interface parameters
h = guidata(h_fig);
p = h.param;

% get project data
if iscell(evd) % from project merging
    dat = evd{1};
    
else % from file
    if iscell(obj) % called by test routine
        pname = obj{1};
        fname = obj{2};
        if ~strcmp(pname,filesep)
            pname = [pname,filesep];
        end
        
    else % called by GUI        
        % open file browser
        if ~isempty(p.proj)
            proj = p.curr_proj;
            defPth = p.proj{proj}.folderRoot;
        else
            defPth = p.folderRoot;
        end
        [fname,pname,o] = uigetfile({'*.mash','MASH-FRET project files';...
            '*.*', 'All files(*.*)'},'Select project',defPth,'MultiSelect',...
            'on');
    end
    if isempty(pname) || ~sum(pname)
        return
    end
    if ~iscell(fname) % covert to cell if only one file is imported
        fname = {fname};
    end

    % check if the project file is not already loaded
    excl_f = false(size(fname));
    str_proj = get(h.listbox_proj,'string');
    if isfield(p,'proj')
        for i = 1:numel(fname)
            for j = 1:numel(p.proj)
                if strcmp(cat(2,pname,fname{i}),p.proj{j}.proj_file)
                    excl_f(i) = true;
                    disp(cat(2,'project "',str_proj{j},'" is already ',...
                        'opened (',p.proj{j}.proj_file,').'));
                end
            end
        end
    end
    fname(excl_f) = [];
    if isempty(fname)
        return
    end

    % load project data
    [dat,ok] = loadProj(pname, fname, 'intensities', h_fig);
    if ~ok
        return
    end
end

% add project to list
proj1 = numel(p.proj)+1;
proj2 = numel(p.proj)+numel(dat);
p.proj = [p.proj dat];

% manage compatibility
p = projDownCompatibility(p,proj1:proj2);

% set interface parameters
p = importSim(p,proj1:proj2);
p = importVP(p,proj1:proj2);
p = importTP(p,proj1:proj2);
p = importHA(p,proj1:proj2);
p = importTA(p,proj1:proj2);

% set last-imported project as current project
p.curr_proj = size(p.proj,2);

% set current modules of all projects
for pj = proj1:proj2
    if ~isempty(p.proj{p.curr_proj}.TA)
        p.curr_mod = cat(2,p.curr_mod,'TA');
    elseif ~isempty(p.proj{p.curr_proj}.HA)
        p.curr_mod = cat(2,p.curr_mod,'HA');
    elseif ~isempty(p.proj{p.curr_proj}.TP)
        p.curr_mod = cat(2,p.curr_mod,'TP');
    elseif ~isempty(p.proj{p.curr_proj}.VP)
        p.curr_mod = cat(2,p.curr_mod,'VP');
    elseif ~isempty(p.proj{p.curr_proj}.sim)
        p.curr_mod = cat(2,p.curr_mod,'S');
    else
        p.curr_mod = cat(2,p.curr_mod,'S');
    end
end

% update project lists
p = ud_projLst(p, h.listbox_proj);

% save modifications
h.param = p;
guidata(h_fig,h);

% update TP project-dependant interface
ud_TTprojPrm(h_fig);

% display action
if ~iscell(evd)
    if size(fname,2) > 1
        str_files = 'files:\n';
    else
        str_files = 'file: ';
    end
    for i = 1:size(fname,2)
        str_files = cat(2,str_files,pname,fname{i},'\n');
    end
    str_files = str_files(1:end-2);
    setContPan(['Project successfully imported from ' str_files],'success',...
        h_fig);
end

% switch to proper module
switchPan(eval(['h.togglebutton_',p.curr_mod{p.curr_proj}]),[],h_fig);

% update plots and GUI
updateFields(h_fig);

