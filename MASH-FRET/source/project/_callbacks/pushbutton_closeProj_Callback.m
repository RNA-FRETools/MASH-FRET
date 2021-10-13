function pushbutton_closeProj_Callback(obj, evd, h_fig, varargin)
% pushbutton_closeProj_Callback([],[],h_fig)
% pushbutton_closeProj_Callback([],[],h_fig,mute)
%
% h_fig: handle to main figure
% mute: (1) to mute user confirmations and action display, (0) otherwise

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

% build action
list_str = get(h.listbox_proj, 'String');
str_act = '';
for i = slct
    str_act = cat(2,str_act,'"',list_str{i},'"');
    if ~isempty(p.proj{i}.proj_file)
        str_act = cat(2,str_act,'(',p.proj{i}.proj_file,')');
    end
    str_act = cat(2,str_act,'\n');
end
str_act = str_act(1:end-2);

% update current project, molecule index, data type and molecule subgroup
p.proj(slct) = [];
p.curr_mod(slct) = [];
p.sim.curr_plot(slct) = [];
p.movPr.curr_plot(slct) = [];
p.movPr.curr_frame(slct) = [];
p.ttPr.curr_mol(slct) = [];
p.ttPr.curr_plot(slct) = [];
p.thm.curr_tpe(slct) = [];
p.thm.curr_tag(slct) = [];
p.thm.curr_plot(slct) = [];
p.TDP.curr_type(slct) = [];
p.TDP.curr_tag(slct) = [];
p.TDP.curr_plot(slct) = [];

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

% display action
if numel(slct)>1
    str_act = cat(2,'Project has been sucessfully removed form ',...
        'the list: ',str_act);
else
    str_act = cat(2,'Projects have been sucessfully removed form ',...
        'the list:\n',str_act);
end
setContPan(str_act,'none',h_fig);

