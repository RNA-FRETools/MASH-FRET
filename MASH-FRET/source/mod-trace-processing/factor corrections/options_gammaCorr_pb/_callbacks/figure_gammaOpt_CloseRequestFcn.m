function figure_gammaOpt_CloseRequestFcn(obj, ~, h_fig)

h = guidata(h_fig);
h = rmfield(h,'figure_gammaOpt');
guidata(h_fig,h);

delete(obj);