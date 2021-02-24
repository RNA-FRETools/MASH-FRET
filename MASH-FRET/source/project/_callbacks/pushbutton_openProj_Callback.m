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
pTP = h.param.ttPr;
pHA = h.param.thm;
pTA = h.param.TDP;

% get project data
if iscell(evd) % from project merging
    dat = evd{1};
    fext = '.mash';
    
else % from file
    if iscell(obj) % called by test routine
        pname = obj{1};
        fname = obj{2};
        if ~strcmp(pname,filesep)
            pname = [pname,filesep];
        end
        
    else % called by GUI
        fmt = questdlg(...
            'What file format would you like to import data from?',...
            'File format','.mash file(s)','Text file(s)','Cancel',...
            '.mash file(s)');
        if strcmp(fmt,'Cancel')
            return
        end
        if strcmp(fmt,'Text file(s)')
            h_opt = openTrImpOpt([],[],h_fig);
            uiwait(h_opt);
            h = guidata(h_fig);
            if ~h.trImpOpt_ok % import option settings were aborted
                h = rmfield(h,'trImpOpt_ok');
                guidata(h_fig,h);
                return
            end
            h = rmfield(h,'trImpOpt_ok');
        end
        
        % open file browser
        defPth = h.folderRoot;
        [fname,pname,o] = uigetfile({'*.*', 'All files(*.*)'},...
            'Select trace files',defPth,'MultiSelect','on');
    end
    if isempty(pname) || ~sum(pname)
        return
    end
    if ~iscell(fname) % covert to cell if only one file is imported
        fname = {fname};
    end

    % check if the project file is not already loaded
    excl_f = false(size(fname));
    str_proj = get(h.listbox_traceSet,'string');
    if isfield(pTP,'proj')
        for i = 1:numel(fname)
            for j = 1:numel(pTP.proj)
                if strcmp(cat(2,pname,fname{i}),pTP.proj{j}.proj_file)
                    excl_f(i) = true;
                    disp(cat(2,'project "',str_proj{j},'" is already ',...
                        'opened (',pTP.proj{j}.proj_file,').'));
                end
            end
        end
    end
    fname(excl_f) = [];
    if isempty(fname)
        return
    end
    
    % get file extension
    [o,o,fext] = fileparts(fname{1});

    % load project data
    [dat,ok] = loadProj(pname, fname, 'intensities', h_fig);
    if ~ok
        return
    end
end

% set interface parameters
pTP = importTP(pTP,dat,fext,numel(fname),h_fig);
pHA = importHA(pHA,dat,h_fig);
pTA = importTA(pTA,dat,h_fig);

% set last-imported project as current project
pTP.curr_proj = size(pTP.proj,2);
pHA.curr_proj = pTP.curr_proj;
pTA.curr_proj = pTP.curr_proj;

% update project lists
pTP = ud_projLst(pTP, h.listbox_traceSet);
pHA = ud_projLst(pHA, h.listbox_thm_projLst);
pTA = ud_projLst(pTA, h.listbox_TDPprojList);

% update TDP
proj = pTA.curr_proj;
tag = pTA.curr_tag(proj);
tpe = pTA.curr_type(proj);
[pTA,ok,str] = buildTDP(pTA,tag,tpe);
if ~ok
    setContPan(str, 'warning', h_fig);
end

% save modifications
h.param.ttPr = pTP;
h.param.thm = pHA;
h.param.TDP = pTA;
guidata(h_fig,h);

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

% update TP's GUI according to new project parameters
ud_TTprojPrm(h_fig);

% update TP's sample management area
ud_trSetTbl(h_fig);

% clear HA's axes
cla(h.axes_hist1);
cla(h.axes_hist2);

% update plots and GUI
updateFields(h_fig,'ttPr');
updateFields(h_fig,'thm');
updateFields(h_fig,'TDP');

