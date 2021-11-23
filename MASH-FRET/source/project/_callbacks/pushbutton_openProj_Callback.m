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
    [dat,ok] = checkField(dat,'',h_fig);
    if ~ok
        return
    end
    
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
    cd(pname);

    % check if the project file is not already loaded
    excl_f = false(size(fname));
    str_proj = get(h.listbox_proj,'string');
    if isfield(p,'proj') && ~isempty(p.proj)
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
    
    % display process
    if numel(fname)==1
        setContPan(['Importing project from file: ',fname{1},' ...'],...
            'process',h_fig);
    else
        str_fname = '';
        for i = 1:numel(fname)
            str_fname = cat(2,str_fname,fname{i},', ');
        end
        str_fname = str_fname(1:end-2);
        setContPan(['Importing projects from files: ',str_fname,' ...'],...
            'process',h_fig);
    end

    % load project data
    [dat,ok] = loadProj(pname, fname, [], h_fig);
    if ~ok
        return
    end
    if ok==2 % video data was loaded
        h = guidata(h_fig);
        p = h.param;
    end
end

% add project to list
proj1 = numel(p.proj)+1;
proj2 = numel(p.proj)+numel(dat);
p.proj = [p.proj dat];

% manage compatibility
p = projDownCompatibility(p,proj1:proj2);

% increment project lists
mod = {};
for pj = proj1:proj2
    if ~isempty(p.proj{pj}.TA)
        mod = cat(2,mod,'TA');
    elseif ~isempty(p.proj{pj}.HA)
        mod = cat(2,mod,'HA');
    elseif ~isempty(p.proj{pj}.TP)
        mod = cat(2,mod,'TP');
    elseif ~isempty(p.proj{pj}.VP)
        mod = cat(2,mod,'VP');
    elseif ~isempty(p.proj{pj}.sim)
        mod = cat(2,mod,'S');
    else
        setContPan('Invalid project can not be opened.','error',h_fig);
        return
    end
end
p = adjustProjIndexLists(p,proj1:proj2,mod);

% set interface parameters
p = importSim(p,proj1:proj2);
p = importVP(p,proj1:proj2);
p = importTP(p,proj1:proj2);
p = importHA(p,proj1:proj2);
p = importTA(p,proj1:proj2);

% set last-imported project as current project
p.curr_proj = size(p.proj,2);

% update project lists
p = ud_projLst(p, h.listbox_proj);

% save modifications
h.param = p;
guidata(h_fig,h);

% update project-dependant interface
ud_TTprojPrm(h_fig);

% switch to proper module
switchPan(eval(['h.togglebutton_',p.curr_mod{p.curr_proj}]),[],h_fig);

% bring project's current plot front
bringPlotTabFront([p.sim.curr_plot(p.curr_proj),...
    p.movPr.curr_plot(p.curr_proj),p.ttPr.curr_plot(p.curr_proj),...
    p.thm.curr_plot(p.curr_proj),p.TDP.curr_plot(p.curr_proj)],h_fig);

% update plots and GUI
updateFields(h_fig);

% display action
if ~iscell(evd)
    if size(fname,2) > 1
        str_files = 'files: ';
    else
        str_files = 'file: ';
    end
    for i = 1:size(fname,2)
        str_files = cat(2,str_files,pname,fname{i},', ');
    end
    str_files = str_files(1:end-2);
    setContPan(['Project successfully imported from ' str_files,' !'],...
        'success',h_fig);
end

