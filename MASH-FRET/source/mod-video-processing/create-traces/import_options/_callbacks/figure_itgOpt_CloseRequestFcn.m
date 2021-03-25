function figure_itgOpt_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'itgOpt');
    h = rmfield(h, {'itgOpt', 'figure_itgOpt'});
    guidata(h_fig, h);
end

delete(obj);