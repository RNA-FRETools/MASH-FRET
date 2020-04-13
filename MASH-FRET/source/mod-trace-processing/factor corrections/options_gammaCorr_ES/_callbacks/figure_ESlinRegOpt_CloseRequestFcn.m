function figure_ESlinRegOpt_CloseRequestFcn(obj,evd,h_fig)

h = guidata(h_fig);
h = rmfield(h,'figure_ESlinRegOpt');
guidata(h_fig,h);

delete(obj);




