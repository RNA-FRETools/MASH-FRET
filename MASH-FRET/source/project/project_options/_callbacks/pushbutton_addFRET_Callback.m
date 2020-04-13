function pushbutton_addFRET_Callback(obj, evd, h_fig)
h = guidata(h_fig);
chanFrom = get(h.itgExpOpt.popupmenu_FRETfrom, 'Value');
chanTo = get(h.itgExpOpt.popupmenu_FRETto, 'Value');
p = guidata(h.figure_itgExpOpt);
ldon = p{6}(chanFrom);

% control donor and acceptor channels
if chanFrom == chanTo
    return
elseif ldon==0
    updateActPan(['FRET calculation impossible: no excitation wavelength ',...
        'specific to donor emitter is defined.'], h_fig, 'error');
    return
end
for i = 1:size(p{3},1)
    if isequal(p{3}(i,:),flip([chanFrom chanTo],2))
        updateActPan(['Channel ' p{7}{2}{chanTo} ...
            ' is already defined as the donor in the pair ' ...
            p{7}{2}{chanTo} '/' p{7}{2}{chanFrom}], h_fig, 'error');
        return
    end
    if isequal(p{3}(i,:),[chanFrom chanTo])
        return
    end
end

% add FRET pair
p{3}(size(p{3},1)+1,1:2) = [chanFrom chanTo];

% save
guidata(h.figure_itgExpOpt, p);

% update panels
ud_fretPanel(h_fig);
ud_sPanel(h_fig);

% set selection to last pair in list
l = size(p{3},1);
set(h.itgExpOpt.listbox_FRETcalc, 'Value', l);
