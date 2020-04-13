function figure_traceMngr_WindowButtonUpFcn(obj,evd,h_fig)
% figure_traceMngr_WindowButtonUpFcn([],[],h_fig)
% figure_traceMngr_WindowButtonUpFcn(position,[],h_fig)
% 
% h_fig: handle to main figure
% position: cursor position at last click (used in test routine)

h = guidata(h_fig);
if isfield(h,'tm') && isfield(h.tm,'figure_traceMngr') && ...
        ishandle(h.tm.figure_traceMngr)
    q = guidata(h.tm.figure_traceMngr);
    q.isDown = false;
    guidata(h.tm.figure_traceMngr,q);
    if iscell(obj)
        pos = obj{1};
    else
        pos = get(h.tm.axes_histSort,'currentpoint');
    end
    axlim = get(h.tm.axes_histSort,'xlim');
    aylim = get(h.tm.axes_histSort,'ylim');
    if pos(1,1)>=axlim(1) && pos(1,1)<=axlim(2) && pos(1,2)>=aylim(1) && ...
            pos(1,2)<=aylim(2)
        adjustMaskPos_AS(q,pos(1,[1,2]));
    end
end
