function pushbutton_untagAll_Callback(obj, evd, h_fig)

h = guidata(h_fig);

% abort if no molecule tag is defined
if ~sum(sum(h.tm.molTag))
    return;
end

% ask confirmation to user
choice = questdlg({cat(2,'All molecule-specific tags will be lost after ',...
    'completion.'),'',cat(2,'Do you want to continue and remove tags to ',...
    'all molecules?')},'Remove molecule tags','Yes, remove all tags',...
    'Cancel','Cancel');
if ~strcmp(choice,'Yes, remove all tags')
    return;
end

% set all molecule tags to false
h.tm.molTag = false(size(h.tm.molTag));
guidata(h_fig,h);

% update molecule tag lists
nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
update_taglist_OV(h_fig,nb_mol_disp);

% update viveo view plot
plotData_videoView(h_fig);

