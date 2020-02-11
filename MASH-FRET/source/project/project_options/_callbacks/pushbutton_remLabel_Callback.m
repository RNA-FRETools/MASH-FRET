function pushbutton_remLabel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
slct = get(h.itgExpOpt.listbox_dyeLabel,'Value');
p = guidata(h.figure_itgExpOpt);
for c = 1:size(p{7}{2},2)
    if strcmp(p{7}{2}{c}, p{7}{1}{slct})
        updateActPan(sprintf('The label is used for channel %i.',c), ...
            h_fig, 'error');
        return;
    end
end

p{7}{1}(slct) = [];

for c = size(p{7}{1},2)+1:size(p{7}{2},2)
    p{7}{1}(c) = {sprintf('dye %i',c)};
end

guidata(h.figure_itgExpOpt,p);
set(h.itgExpOpt.listbox_dyeLabel,'Value',size(p{7}{1},2),'String',p{7}{1});
set(h.itgExpOpt.popupmenu_dyeLabel,'String',p{7}{1});
popupmenu_dyeLabel_Callback(h.itgExpOpt.popupmenu_dyeLabel,evd,h_fig);