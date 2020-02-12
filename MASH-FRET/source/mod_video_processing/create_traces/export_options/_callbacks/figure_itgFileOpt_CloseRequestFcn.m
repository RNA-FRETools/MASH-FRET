function figure_itgFileOpt_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'itgFileOpt');
    h = rmfield(h, {'itgFileOpt', 'figure_itgFileOpt'});
    guidata(h_fig, h);
end

delete(obj);