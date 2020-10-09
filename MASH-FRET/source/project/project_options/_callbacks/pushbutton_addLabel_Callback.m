function pushbutton_addLabel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
label = get(h.itgExpOpt.edit_dyeLabel,'String');
if ~isempty(label)
    p = guidata(h.figure_itgExpOpt);
    p{7}{1} = [p{7}{1} label];
    guidata(h.figure_itgExpOpt,p);
    set(h.itgExpOpt.listbox_dyeLabel,'String',p{7}{1});
    set(h.itgExpOpt.popupmenu_dyeLabel,'String',p{7}{1});
    popupmenu_dyeLabel_Callback(h.itgExpOpt.popupmenu_dyeLabel,evd,h_fig);
end