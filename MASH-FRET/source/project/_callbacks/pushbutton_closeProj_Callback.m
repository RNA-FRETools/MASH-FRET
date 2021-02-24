function pushbutton_closeProj_Callback(obj, evd, h_fig, varargin)
% pushbutton_closeProj_Callback([],[],h_fig)
% pushbutton_closeProj_Callback([],[],h_fig,mute)
%
% h_fig: handle to main figure
% mute: (1) to mute user confirmations and action display, (0) otherwise

h = guidata(h_fig);
pTP = h.param.ttPr;
pHA = h.param.thm;
pTA = h.param.TDP;
if isempty(pTP.proj)
    return
end

mute = h.mute_actions;
if ~isempty(varargin)
    mute = mute | varargin{1};
end
    
% collect selected projects
slct = get(h.listbox_traceSet, 'Value');

% build confirmation message box
if mute
    del = 'Yes';
else
    str_proj = ['"' pTP.proj{slct(1)}.exp_parameters{1,2} '"'];
    for pj = 2:numel(slct)
        str_proj = [str_proj ', "' pTP.proj{slct(pj)}.exp_parameters{1,2} ...
            '"'];
    end
    del = questdlg(['Remove project ' str_proj ' from the list?'], ...
        'Remove project', 'Yes', 'No', 'No');
end
if ~strcmp(del, 'Yes')
    return
end

% build action
list_str = get(h.listbox_traceSet, 'String');
str_act = '';
for i = slct
    str_act = cat(2,str_act,'"',list_str{i},'" (',...
        pTP.proj{i}.proj_file,')\n');
end
str_act = str_act(1:end-2);

% update current project, molecule index, data type and molecule subgroup
pTP.proj(slct) = [];
pHA.proj(slct) = [];
pTA.proj(slct) = [];
pTP.curr_mol(slct) = [];
pHA.curr_tpe(slct) = [];
pHA.curr_tag(slct) = [];
pTA.curr_type(slct) = [];
pTA.curr_tag(slct) = [];

% set new current project
if size(pTP.proj,2) <= 1
    pTP.curr_proj = 1;
elseif slct(end) < size(pTP.proj,2)
    pTP.curr_proj = slct(end)-numel(slct) + 1;
else
    pTP.curr_proj = slct(end)-numel(slct);
end
pHA.curr_proj = pTP.curr_proj;
pTA.curr_proj = pTP.curr_proj;

% update project lists
pTP = ud_projLst(pTP, h.listbox_traceSet);
pHA = ud_projLst(pHA, h.listbox_thm_projLst);
pTA = ud_projLst(pTA, h.listbox_TDPprojList);
h.param.ttPr = pTP;
h.param.thm = pHA;
h.param.TDP = pTA;
guidata(h_fig, h);

% update GUI with current project parameters
ud_TTprojPrm(h_fig);

% update sample management area
ud_trSetTbl(h_fig);

% clear HA's axes
cla(h.axes_hist1);
cla(h.axes_hist2);

% update calculations and GUI
updateFields(h_fig, 'ttPr');
updateFields(h_fig, 'thm');
updateFields(h_fig, 'TDP');

% display action
if numel(slct)>1
    str_act = cat(2,'Project has been sucessfully removed form ',...
        'the list: ',str_act);
else
    str_act = cat(2,'Projects have been sucessfully removed form ',...
        'the list:\n',str_act);
end
setContPan(str_act,'none',h_fig);

