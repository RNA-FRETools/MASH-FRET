function axes_histSort_ButtonDownFcn(obj,evd,h_fig)

h = guidata(h_fig);
q = guidata(h.tm.figure_traceMngr);
q.isDown = true;
guidata(h.tm.figure_traceMngr,q);

