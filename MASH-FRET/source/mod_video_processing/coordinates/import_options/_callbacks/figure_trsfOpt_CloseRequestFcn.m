function figure_trsfOpt_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'trsfOpt');
    h = rmfield(h, {'trsfOpt', 'figure_trsfOpt'});
    guidata(h_fig, h);
end

delete(obj);