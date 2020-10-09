function pushbutton_applyTag_Callback(obj,evd,h_fig)

h = guidata(h_fig);

if ~h.mute_actions
    choice = questdlg({cat(2,'Applying tags to molecules belonging to this ',...
        'subgroup can not be reversed.'),'',...
        'Do you wish to continue?'},'Apply molecule tag',...
        'Yes, tag molecules','Cancel','Cancel');
    if ~strcmp(choice,'Yes, tag molecules')
        return
    end
end

listbox_ranges_Callback(h.tm.listbox_ranges,[],h_fig);
h = guidata(h_fig);

dat3 = get(h.tm.axes_histSort,'userdata');
range = get(h.tm.listbox_ranges,'value');

molIncl_slct = ud_popCalc(h_fig);

if ~sum(molIncl_slct) || ~sum(dat3.rangeTags(range,:))
    return
end

% molecule selection at last update
molId = find(dat3.slct);
h.tm.molTag(molId(molIncl_slct),~~dat3.rangeTags(range,:)) = true;

guidata(h_fig,h);

% update molecule tag lists
update_taglist_OV(h_fig,str2num(get(h.tm.edit_nbTotMol,'string')));

% update plot in VV
plotData_videoView(h_fig);

