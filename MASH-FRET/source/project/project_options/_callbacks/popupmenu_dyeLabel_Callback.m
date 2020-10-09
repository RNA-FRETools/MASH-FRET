function popupmenu_dyeLabel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);
str = get(obj, 'String');
val = get(obj, 'Value');
chan = get(h.itgExpOpt.popupmenu_dyeChan,'Value');
p{7}{2}(chan) = str(val);
guidata(h.figure_itgExpOpt,p);
ud_fretPanel(h_fig);
ud_sPanel(h_fig);