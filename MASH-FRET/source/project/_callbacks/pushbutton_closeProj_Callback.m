function pushbutton_closeProj_Callback(obj, evd, h_fig, varargin)
% pushbutton_closeProj_Callback([],[],h_fig)
% pushbutton_closeProj_Callback([],[],h_fig,mute)
%
% h_fig: handle to main figure
% mute: (1) to mute user confirmations and action display, (0) otherwise

% adjust current project index in case it is out of list range (can happen 
% when project import failed)

h = guidata(h_fig);
p = h.param;
if isempty(p.proj)
    return
end

mute = h.mute_actions;
if ~isempty(varargin)
    mute = mute | varargin{1};
end
    
% collect selected projects
slct = get(h.listbox_proj, 'Value');
if isempty(slct)
    return
end

% build confirmation message box
if mute
    del = 'Yes';
else
    str_proj = ['"' p.proj{slct(1)}.exp_parameters{1,2} '"'];
    for pj = 2:numel(slct)
        str_proj = [str_proj ', "' p.proj{slct(pj)}.exp_parameters{1,2} ...
            '"'];
    end
    del = questdlg(['Remove project ' str_proj ' from the list?'], ...
        'Remove project', 'Yes', 'No', 'No');
end
if ~strcmp(del, 'Yes')
    return
end

% display process
if numel(slct)>1
    setContPan('Closing projects...','process',h_fig);
else
    setContPan('Closing project...','process',h_fig);
end

% build action
list_str = get(h.listbox_proj, 'String');
str_act = '';
for i = slct
    str_act = cat(2,str_act,'"',list_str{i},'"');
    if ~isempty(p.proj{i}.proj_file)
        str_act = cat(2,str_act,'(',p.proj{i}.proj_file,')');
    end
    str_act = cat(2,str_act,', ');
end
str_act = str_act(1:end-2);

% erase video store in memory
for i = slct
    if ~(isfield(h,'movie') && isfield(h.movie,'movie') && ...
            ~isempty(h.movie.movie))
        break
    end
    for c = 1:numel(p.proj{i}.movie_file)
        if ~isFullLengthVideo(p.proj{i}.movie_file{c},h_fig)
            continue
        end
        h.movie.movie = [];
        h.movie.file = '';
        break
    end
end

% update current project, molecule index, data type and molecule subgroup
p = adjustProjIndexLists(p,-slct,[]);
p.proj(slct) = [];

% set new current project
if size(p.proj,2) <= 1
    p.curr_proj = 1;
elseif slct(end) < size(p.proj,2)
    p.curr_proj = slct(end)-numel(slct) + 1;
else
    p.curr_proj = slct(end)-numel(slct);
end

% update project lists
p = ud_projLst(p, h.listbox_proj);
h.param = p;
guidata(h_fig, h);

% update GUI with current project parameters
ud_TTprojPrm(h_fig);

% update sample management area
ud_trSetTbl(h_fig);

% clear HA's axes
cla(h.axes_hist1);
cla(h.axes_hist2);

% update calculations and GUI
updateFields(h_fig);

% switch to new current project's module
if ~isempty(p.proj)
    switchPan(eval(['h.togglebutton_',p.curr_mod{p.curr_proj}]),[],h_fig);
end

% display success
if numel(slct)>1
    str_act = cat(2,'Project ',str_act,' sucessfully closed!');
else
    str_act = cat(2,'Projects ',str_act,' sucessfully closed!',str_act);
end
setContPan(str_act,'success',h_fig);

