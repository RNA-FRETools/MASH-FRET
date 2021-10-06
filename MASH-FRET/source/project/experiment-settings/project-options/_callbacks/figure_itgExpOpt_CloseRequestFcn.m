function figure_itgExpOpt_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'itgExpOpt');
    h = rmfield(h, {'itgExpOpt', 'figure_itgExpOpt'});
    guidata(h_fig, h);
end

delete(obj);