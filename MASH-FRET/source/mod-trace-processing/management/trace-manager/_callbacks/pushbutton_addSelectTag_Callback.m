function pushbutton_addSelectTag_Callback(obj,evd,h_fig)

h = guidata(h_fig);

tag = get(h.tm.popupmenu_addSelectTag,'value')-1;

if tag==0 % no tag selected
    return
end

% ask confirmation to user
if ~h.mute_actions
    choice = questdlg({cat(2,'Applying tags to selected molecules can not be ',...
        'reversed.'),'','Do you wish to continue?'},'Apply molecule tag',...
        'Tag molecules','Cancel','Cancel');
    if ~strcmp(choice,'Tag molecules')
        return
    end
end

h.tm.molTag(h.tm.molValid,tag) = true;

set(obj,'value',1);
guidata(h_fig,h);

% update view in panel "Molecule selection"
nDisp = numel(h.tm.axes_itt);
isBot = isfield(h.tm,'axes_frettt');
for i = 1:nDisp
    m = str2num(get(h.tm.checkbox_molNb(i),'string'));
    set(h.tm.checkbox_molNb(i),'value',h.tm.molValid(m));
    if h.tm.molValid(m)
        shad = [1,1,1];
    else
        shad = get(h.tm.checkbox_molNb(i),'backgroundcolor');
    end
    set([h.tm.axes_itt(i),h.tm.axes_itt_hist(i)],'color',shad);
    if isBot
        set([h.tm.axes_frettt(i),h.tm.axes_hist(i)],'color',shad);
    end
end

% update molecule tag lists
nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
update_taglist_OV(h_fig,nb_mol_disp);

% update viveo view plot
plotData_videoView(h_fig);
