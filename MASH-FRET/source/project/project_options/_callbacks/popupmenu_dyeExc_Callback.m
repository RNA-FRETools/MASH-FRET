function popupmenu_dyeExc_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);
str = get(obj, 'String');
val = get(obj, 'Value');
if val == size(str,1)
    exc = 0;
else
    exc = getValueFromStr('', str{val});
end
chan = get(h.itgExpOpt.popupmenu_dyeChan,'Value');
if exc==p{6}(chan)
    return;
end
if exc==0 
    ud_fret = 0;
    ud_s = 0;
    for id = 1:numel(str)
        if ~isempty(strfind(str{id},num2str(p{6}(chan))))
            break;
        end
    end
    if isfield(h.itgExpOpt,'popupmenu_Spairs') && sum(sum(p{4}==chan)) && ...
        isfield(h.itgExpOpt,'popupmenu_FRETto') && sum(p{3}(:,1)==chan)
        choice = questdlg({cat(2,'Selected emitter is invoved in ',...
            'FRET and stoichiometry calculations. Changing its specific ',...
            'illumination to "none" will automatically remove the ',...
            'corresponding FRET and stoichiometry from the lists'),'',...
            cat(2,'Do you want to turn illumination to "none" and remove ',...
            'the FRET and stoichiometry from the lists?')},'',...
            'Yes, remove','cancel','cancel');
        if strcmp(choice,'Yes, remove')
            ud_fret = 1;
            ud_s = 1;
        else
            set(obj,'Value',id);
            return;
        end
    elseif isfield(h.itgExpOpt,'popupmenu_Spairs') && sum(sum(p{4}==chan))
        choice = questdlg({cat(2,'Selected emitter is invoved in ',...
            'stoichiometry calculations. Changing its specific ',...
            'illumination to "none" will automatically remove the ',...
            'corresponding stoichiometry from the list'),'',...
            cat(2,'Do you want to turn illumination to "none" and remove ',...
            'the stoichiometry from the list?')},'',...
            'Yes, remove','Cancel','Cancel');
        if strcmp(choice,'Yes, remove')
            ud_s = 1;
        else
            set(obj,'Value',id);
            return;
        end
    elseif isfield(h.itgExpOpt,'popupmenu_FRETto') && sum(p{3}(:,1)==chan)
        choice = questdlg({cat(2,'Selected emitter is invoved in ',...
            'FRET calculations as a donor. Changing its specific ',...
            'illumination to "none" will automatically remove the ',...
            'corresponding FRET from the list'),'',...
            cat(2,'Do you want to turn illumination to "none" and remove ',...
            'the FRET from the list?')},'',...
            'Yes, remove','Cancel','Cancel');
        if strcmp(choice,'Yes, remove')
            ud_fret = 1;
        else
            set(obj,'Value',id);
            return;
        end
    end
    if ud_s
        p{4}(p{4}(:,1)==chan || p{4}(:,2)==chan) = [];
    end
    if ud_fret
        p{3}(p{3}(:,1)==chan,:) = [];
    end
end
p{6}(chan) = exc;
guidata(h.figure_itgExpOpt,p);
ud_fretPanel(h_fig);
ud_sPanel(h_fig);