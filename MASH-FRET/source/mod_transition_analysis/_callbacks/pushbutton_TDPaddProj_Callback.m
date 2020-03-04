function pushbutton_TDPaddProj_Callback(obj, evd, h_fig)
% pushbutton_TDPaddProj_Callback([],[],h_fig)
% pushbutton_TDPaddProj_Callback(files,[],h_fig)
%
% h_fig: handle to main figure
% files: {1-by-2} source directory and files to import

h = guidata(h_fig);

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname,filesep)
        pname = [pname,filesep];
    end
else
    defPth = h.folderRoot;
    [fname,pname,o] = uigetfile({'*.mash', 'MASH project(*.mash)'; ...
        '*path.dat', 'HaMMy path files (*path.dat)'; '*.*',...
        'All files(*.*)'},'Select data files',defPth,'MultiSelect','on');
end
if ~(~isempty(fname) && sum(pname))
    return
end
if ~iscell(fname)
    fname = {fname};
end

p = h.param.TDP;

% check if the project file is not already loaded
excl_f = false(size(fname));
str_proj = get(h.listbox_TDPprojList,'string');
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

% stop if no file is left
if isempty(fname)
    return
end

% load project data
[dat,ok] = loadProj(pname, fname, 'intensities', h_fig);
if ~ok
    return;
end
p.proj = [p.proj dat];

% define data processing parameters applied (prm)
for i = (size(p.proj,2)-size(dat,2)+1):size(p.proj,2)
    
    nChan = p.proj{i}.nb_channel;
    nExc = p.proj{i}.nb_excitations;
    nFRET = size(p.proj{i}.FRET,1);
    nS = size(p.proj{i}.S,1);
    nTpe = nChan*nExc + nFRET + nS;
    nTag = numel(p.proj{i}.molTagNames);
    
    p.curr_type(i) = 1;
    p.curr_tag(i) = 1;

    p.proj{i}.def = setDefPrm_TDP(p,i);

    if ~isfield(p.proj{i}, 'prmTDP')
        p.proj{i}.prm = cell(nTag+1,nTpe);
    else
        p.proj{i}.prm = p.proj{i}.prmTDP;
        p.proj{i} = rmfield(p.proj{i}, 'prmTDP');
    end
    if ~isfield(p.proj{i}, 'expTDP')
        p.proj{i}.exp = [];
    else
        p.proj{i}.exp = p.proj{i}.expTDP;
        p.proj{i} = rmfield(p.proj{i}, 'expTDP');
    end
    
    % if the number of data changed, reset results and resize
    if size(p.proj{i}.prm,2)~=(nTpe)
        p.proj{i}.prm = cell(nTag+1,nTpe);
    end
    
    % if the number of tags changed, reset results and resize
    if size(p.proj{i}.prm,1)~=(nTag+1)
        p.proj{i}.prm = cat(1,p.proj{i}.prm(1,:),cell(nTag,nTpe));
    end

    for tpe = 1:nTpe
        for tag = 1:(nTag+1)

            p.proj{i} = downCompatibilityTDP(p.proj{i},tpe,tag);

            % if size of already applied parameters is different from
            % defaults, used defaults
            p.proj{i}.curr{tag,tpe} = checkValTDP(p,p.proj{i}.prm{tag,tpe},...
                p.proj{i}.def{tag,tpe});
        end
    end
end

% set last-imported project as current project
p.curr_proj = size(p.proj,2);

% update project list
p = ud_projLst(p, h.listbox_TDPprojList);

% display import action
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

% update TDP
proj = p.curr_proj;
tag = p.curr_tag(proj);
tpe = p.curr_type(proj);
[p,ok,str] = buildTDP(p,tag,tpe);
if ~ok
    setContPan(str, 'warning', h_fig);
end

% save modifications
h.param.TDP = p;
guidata(h_fig, h);

% update plots and GUI
updateFields(h_fig, 'TDP');

