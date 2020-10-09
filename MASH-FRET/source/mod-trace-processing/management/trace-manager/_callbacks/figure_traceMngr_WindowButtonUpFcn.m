function figure_traceMngr_WindowButtonUpFcn(obj,evd,h_fig)

h = guidata(h_fig);
if isfield(h,'tm') && isfield(h.tm,'figure_traceMngr') && ...
        ishandle(h.tm.figure_traceMngr)
    q = guidata(h.tm.figure_traceMngr);
    q.isDown = false;
    guidata(h.tm.figure_traceMngr,q);
    pos = get(h.tm.axes_histSort,'currentpoint');
    adjustMaskPos_AS(q,pos(1,[1,2]));
end
